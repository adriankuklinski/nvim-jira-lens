local M = {}

local data_file_path = vim.fn.stdpath('data') .. "/jira.json"

M.save = function(data)
    if vim.fn.filereadable(data_file_path) == 0 then
        local file = io.open(data_file_path, "w")
        if file then
            file:write("[]")
            file:close()
        else
            print("Error: Unable to create jira.json.")
        end
    end

    local json_str = vim.fn.json_encode(data)
    vim.fn.writefile(vim.fn.split(json_str, "\n"), data_file_path)
end

M.load = function()
    if vim.fn.filereadable(data_file_path) == 1 then
        local data_str = table.concat(vim.fn.readfile(data_file_path), "\n")
        return vim.fn.json_decode(data_str)
    else
        return {}
    end
end

return M
