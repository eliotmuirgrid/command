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
   print(V);
end

function Insert(text)
    local lines = vim.split(text, "\n", { plain = true })

    vim.api.nvim_buf_set_lines(
        0, 0, 0,
        false,
        lines
    )
end

function Call(Command)
   return vim.fn.system(Command);
end

function StripExtension(FileName)
  return FileName:gsub("%.[^.]+$", "")
end

local Path = os.getenv('HOME').."/command/nvim/"

for Name in vim.fs.dir(Path) do
   if Name ~= 'boot.lua' and Name:sub(1,1) ~= "." then
      local FName = StripExtension(Name);
      local Func = require(FName);
      vim.api.nvim_create_user_command(FName, Func, {nargs="+"});
   end
end
