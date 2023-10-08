local M = {}

local data_file_path = vim.fn.stdpath('data') .. "/jira.json"

--- Saves the provided data to a local file in JSON format.
-- If the file doesn't exist, it creates a new file. If the file cannot be created,
-- an error message is displayed. The data is saved in a pretty-printed JSON format
-- for easier reading and debugging.
-- @param data The data to be saved, expected to be a table.
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

--- Loads data from a local file and returns it.
-- If the file exists and is readable, its contents are read,
-- parsed from JSON to a Lua table, and returned. If the file
-- doesn't exist or isn't readable, an empty table is returned.
-- @return A table containing the loaded data, or an empty table if the file doesn't exist or isn't readable.
M.load = function()
    if vim.fn.filereadable(data_file_path) == 1 then
        local data_str = table.concat(vim.fn.readfile(data_file_path), "\n")
        return vim.fn.json_decode(data_str)
    else
        return {}
    end
end

return M
