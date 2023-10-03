local M = {}

local credentials = {
    username = "",
    password = "",
    base_url = ""
}

M.set_credentials = function(username, password, base_url)
    credentials.username = username
    credentials.password = password
    credentials.base_url = base_url
end

return M

