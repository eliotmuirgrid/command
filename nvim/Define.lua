local Define = function(opts)
   local Topic = opts.args;
   local Definition = AgentGpt("Define "..Topic.. " in a few paragraphs");
   Insert("# "..Topic.."\n"..Definition);
end

return Define, {nargs="+"}
