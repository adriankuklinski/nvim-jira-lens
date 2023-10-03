local M = {}

M.file_exists = function(file_path)
    local f = io.open(file_path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

M.write_credentials_to_file = function(file_path, username, password, base_url)
    local f = io.open(file_path, "w")

    if not f then
        return
    end

    if username then
        f:write(username .. "\n")
    end

    if password then
        f:write(password .. "\n")
    end

    if base_url then
        f:write(base_url .. "\n")
    end

    f:close()
end

M.load_credentials_from_file = function(file_path)
    if M.file_exists(file_path) then
        local lines = vim.fn.readfile(file_path)
        if #lines == 3 then
            return lines[1], lines[2], lines[3]
        end
    end
    return nil, nil, nil
end

return M
