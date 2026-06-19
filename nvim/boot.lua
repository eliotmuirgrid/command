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
   print(Response);
   Response = FilterTrimBegin(Response,'"text"');
   Response = FilterTrimEnd(Response,'"role": "assistant"')
   Response = FilterTrimEnd(Response, '"');
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
