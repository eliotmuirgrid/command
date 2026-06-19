local Test=function()
   local T= {life="fff"}
   local S = JsonEncode(T);
   print(S);
end

return Test, {};
