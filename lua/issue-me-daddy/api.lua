local M = {}

local http = require("socket.http")

M.get_my_issues = function(config)
    local base_url = config.base_url
    local auth = "Basic " .. vim.fn.system("echo -n " .. config.username .. ":" .. config.password .. " | base64")

    -- Constructing the JQL query:
    local jql_query = string.format(
        "assignee='%s' AND (status='In Progress' OR status='In Review')",
        config.username
    )

    local url = string.format("%s/rest/api/2/search?jql=%s", base_url, http.encode(jql_query))

    local response = http.request({
        url = url,
        method = "GET",
        headers = {
            ["Authorization"] = auth,
            ["Content-Type"] = "application/json",
        }
    })

    return response
end

return M