local Go = function()
    local line = vim.fn.getline(".")
    print(line)

    local file = string.match(line, "%(([^)]*)%)")
    print(file or "")

    if file and file ~= "" then
        vim.cmd("edit " .. vim.fn.fnameescape(file))
    end
end

return Go, {};
