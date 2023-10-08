local M = {}

local utils = require("nvim-jira-lens.utils")
local json = require("nvim-jira-lens.json")

--- Fetches issues assigned to the user from Jira.
-- This function sends an async HTTP request to the Jira REST API to fetch
-- issues assigned to the configured user that are in 'In Progress' or 'In Review' status.
-- The fetched issues are processed, extracted, and saved locally for further use.
-- @param config A table containing the user's Jira configuration settings.
M.get_my_issues = function(config)
    local base_url = config.base_url
    local auth = "Basic " .. vim.fn.system("echo -n " .. config.username .. ":" .. config.password .. " | base64"):gsub("\n", "")

    -- Constructing the JQL query:
    local jql_query = string.format(
        "assignee='%s' AND (status='In Progress' OR status='In Review')",
        config.username
    )

    -- Compose Jira url string
    local url = string.format("%s/rest/api/2/search?jql=%s", base_url, utils.url_encode(jql_query))

    -- Prepare the curl command:
    local cmd = string.format(
        "curl -s -H 'Authorization: %s' -H 'Content-Type: application/json' '%s'",
        auth,
        url
    )

    -- Create pipes for stdout and stderr:
    local stdout = vim.uv.new_pipe(false)
    local stderr = vim.uv.new_pipe(false)

    -- Spawn a new job to execute the curl command:
    local handle
    handle, _ = vim.uv.spawn('bash', {
        args = {'-c', cmd},
        stdio = {nil, stdout, stderr}
    }, function(_, _)
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()
    end)

    -- Create an empty table to accumulate data chunks:
    local data_chunks = {}

    -- Read the response data from stdout:
    stdout:read_start(function(err, data)
        assert(not err, err)
        if data then
            -- Accumulate data chunks:
            table.insert(data_chunks, data)
        else
            -- No more data, concatenate all chunks and parse the JSON:
            local data_str = table.concat(data_chunks)
            vim.schedule(function()
                local parsed_data = vim.fn.json_decode(data_str)
                local extracted_data = {}

                for _, issue in ipairs(parsed_data.issues or {}) do
                    local issue_data = {
                        key = issue.key,
                        summary = issue.fields.summary,
                        description = issue.fields.description,
                        status = issue.fields.status.name,
                    }

                    table.insert(extracted_data, issue_data)
                end

                -- Save the extracted data:
                json.save(extracted_data)
            end)
        end
    end)
end

return M
