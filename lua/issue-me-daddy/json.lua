local M = {}

local data_file_path = vim.fn.stdpath('config') .. "/issue-me-daddy/jira.json"

M.save = function(data)
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
