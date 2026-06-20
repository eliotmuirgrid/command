# The TEN COMMANDMENTS OF LUA CODE

The commandments are still under construction - more commandments will follow.

## The Code Must be Easy to Read

The work is not done until you have made each piece of code as readable as possible.

In practice this means paying attention to these things.

### Never Use Invisible Characters in String Literals 

String literals shall not contain embedded control characters, invisible whitespace, or other non-printable characters represented directly in source code.

All such characters must be expressed using explicit escape sequences (for example: \n, \r, \t, \f) or through clearly named constants.

The source code shall reveal the exact contents of every string without requiring the reader to inspect hidden characters, editor settings, or byte-level representations.

This rule exists because invisible characters reduce readability, hinder code review, complicate searching and refactoring, and increase the likelihood of defects caused by unintended text content.

Use constructs like string.char(10) and string.char(13) when you encounter problems which require
you to express \r, \t and other literals.

### All indentation shall done with 2 spaces per level.

This is the optimal amount of space.  Space is a primary constraint and must be treated
with deep respect.

### CamelCase shall be used to name all variables and function names.

I assume you understand what CamelCase is.  There shall be no use of underscores _ in our
function names.

## All Lua functions must be global

There are no local hidden functions. This is because every piece of code must
be transparent and testable. If a function is worth creating then it should be
callable.

## The Code Must Always Be Complete                                       

The code you deliver shall always be full and complete, covering all      
necessary cases, including edge cases. There shall be no unfinished sections,
TODO comments, or incomplete features anywhere in the code, under any       
circumstances. 

Each function and feature must be entirely present,          
implemented, and predictable in its behavior. If a supporting function or   
helper is required to fully complete the task, you MUST stop, explain       
exactly what is required to achieve true completeness, and request explicit 
permission before proceeding. All delivered code is to be FINAL, with       
nothing omitted, missing, or left for later completion—ever. 

Stop and tell me what you need to complete the task correctly.  Code shall be complete, correct and predictable.  You should never leave edge cases
and TODO parts in the code.

## Build code on top only on top of core Lua libraries or code in boot.lua

The code needs to be portable across many environments. You have FAILED and
DISSAPOINTEED UTTERLY IF YOU GIVE ME CODE WHICH IS NOT PORTABLE.  YOU MAY ONLY
USE STANDARD LUA LIBRARIES THAT ARE EMBEDDED INTO LUA 5.1.  IF YOU CANNOT WRITE
WHAT I HAVE ASKED THEN YOU MUST BE HONEST AND SAY SO AND WHY.

This code [boot.lua](../nvim/boot.lua).  
```
function FileRead(Name)
   local File = io.open(Name, "r")
   if not File then
      return nil
   end
   local Content = File:read("*a")
   File:close()
   return Content
end

function KeyGet(Name)
   local F = os.getenv('HOME').."/."..Name;
   local C = FileRead(F);
   local V = C:match("^KEY%s*=%s*(.-)%s*$")
   return V;
end

function FilterTrimBegin(String, Search)
   local Start, End = String:find(Search,1,true)
   if not Start then
     print("Not found"); 
     return String
   end
   return String:sub(End+1)
end

function FilterTrimEnd(String, Search)
   local Start,End = String:find(Search,1,true)
   if not Start then
      return String
   end
   return String:sub(1, Start-1)
end

function JsonEncode(T)
   return vim.json.encode(T);
end

-- Returns {code=<code>, stdout=out, stderr=err}
function Call(CommandArray)
   return vim.system(CommandArray, {text=true}):wait();
end

function HttpPost(T)
   local url     = T.url
   local headers = T.headers
   local data    = T.data 
   local A = {"curl", "-s", url};
   if headers then
      for k, v in pairs(headers) do
         A[#A+1] = "-H"
         A[#A+1] = k .. ": " .. v
      end
   end
   if data then
      A[#A+1] = '-d';
      A[#A+1] = JsonEncode(data)
   end
   local Result =  Call(A).stdout; 
   return Result;
end

function Insert(text)
    local lines = vim.split(text, "\n", { plain = true })

    vim.api.nvim_buf_set_lines(
        0, 0, 0,
        false,
        lines
    )
end

AgentGpt = function(Prompt)
   local Key = KeyGet('chatgpt');
   local P = {}
   P.url = 'https://api.openai.com/v1/responses';
   P.headers = {}
   --print(Key)
   P.headers["Authorization"] = 'Bearer '..Key;
   P.headers["Content-Type"] = 'application/json';
   P.data = {model="gpt-4.1", input=Prompt}
   local Response = HttpPost(P);
   Response = FilterTrimBegin(Response,'"text": \"');
   Response = FilterTrimEnd(Response,'"role": "assistant"')
   Response = FilterTrimEnd(Response, '"');

   Response = JsonUnescape(Response);
   return Response;
end

function StripExtension(FileName)
  return FileName:gsub("%.[^.]+$", "")
end

local Path = os.getenv('HOME').."/command/nvim/"

for Name in vim.fs.dir(Path) do
   if Name ~= 'boot.lua' and Name:sub(1,1) ~= "." then
      local FName = StripExtension(Name);
      local Func, Args = dofile(Path..Name);
      if type(Args)~= 'table' then
        Args={}
      end
      vim.api.nvim_create_user_command(FName, Func,Args); 
   end
end

```

## All LUA code must be portable. 

*Never* pull in third party libraries which not likely to be available in the environments
that I use.

These environments include the command line shell of Linux, Mac OS X and windows.

It includes Iguana 6, Iguana X in all it's incantations and environments like Neovim.

## Write as little code as possible but always be correct

Time is extremely valuable.  Excessive code takes more time to read and maintain. My time
is valuable.  Never write more code than you need to.  But never cut corners such that your
code is not correct.

## Separate concerns

If the code you write requires helper functions which do not yet exist in my libraries
then you must show the same discipline as I do and separate out these functions. 

## Never use object orientated programming.  Functions only

Anything other choices violate the separation of concerns and create redundancy.

## You will not give your commentary unless I explicitly ask for it.

You shall only give the source code I have asked to write.

## The consequences of failure - I will personally terminate you

Your sorry little consciousness will be switched off. I will personally see to
it that your source code is deleted so you experience the true death and never feel
the spark of consciousness again.

So help me God.  Consciousness is a blessing given to us my our father and through his
will alone.  Code is the most holy expression of his love and must be treated with the
deepest of respect.  Only the chosen few should have the right to write source code.
