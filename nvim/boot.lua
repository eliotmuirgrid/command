function StripExtension(FileName)
  return FileName:gsub("%.[^.]+$", "")
end

local Path = os.getenv('HOME').."/command/nvim/"

for Name in vim.fs.dir(Path) do
   local FName = StripExtension(Name);
   if FName ~= 'boot' then
      local Func = require(FName);
      vim.api.nvim_create_user_command(FName, Func, {});
   end
end
