local M = {}

local url_encode = require("issue-me-daddy.utils").url_encode

local cjson = require("cjson")
local http = require("socket.http")

M.get_my_issues = function(config)
    local base_url = config.base_url
    local auth = "Basic " .. vim.fn.system("echo -n " .. config.username .. ":" .. config.password .. " | base64")

    print(vim.inspect(auth))

    -- Constructing the JQL query:
    local jql_query = string.format(
        "assignee='%s' AND (status='In Progress' OR status='In Review')",
        config.username
    )

    local url = string.format("%s/rest/api/2/search?jql=%s", base_url, url_encode(jql_query))

    print(vim.inspect(url))

    local response, status, headers = http.request({
        url = url,
        method = "GET",
        headers = {
            ["Authorization"] = auth,
            ["Content-Type"] = "application/json",
        }
    })

    print("Response:", response)
    print("Status:", status)
    for k, v in pairs(headers) do
        print(string.format("Header: %s: %s", k, v))
    end

    local data = cjson.decode(response)

    return data
end

return M
