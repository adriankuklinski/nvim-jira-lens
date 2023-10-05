local M = {}

local url_encode = require("issue-me-daddy.utils").url_encode

local cjson = require("cjson")
local http = require("socket.http")
local ltn12 = require("ltn12")

M.get_my_issues = function(config)
    local base_url = config.base_url
    local auth = "Basic " .. vim.fn.system("echo -n " .. config.username .. ":" .. config.password .. " | base64"):gsub("\n", "")

    -- Constructing the JQL query:
    local jql_query = string.format(
        "assignee='%s' AND (status='In Progress' OR status='In Review')",
        config.username
    )

    local url = string.format("%s/rest/api/2/search?jql=%s", base_url, url_encode(jql_query))

    -- Create an empty table to hold the chunks of data
    local chunks = {}

    -- The sink function that will capture the data
    local sink = ltn12.sink.table(chunks)

    http.request({
        url = url,
        method = "GET",
        headers = {
            ["Authorization"] = auth,
            ["Content-Type"] = "application/json",
        },
        sink = sink
    })

    local body = table.concat(chunks)
    local data = cjson.decode(body)
    local extracted_data = {}

    for i, issue in ipairs(data.issues) do
        local issue_data = {
            key = issue.key,
            summary = issue.fields.summary,
            description = issue.fields.status.name
        }
        table.insert(extracted_data, issue_data)
    end

    print(vim.inspect(data))
    return extracted_data
end

return M
