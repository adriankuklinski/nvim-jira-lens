local M = {}
local api = require'issue-me-daddy.api'
local telescope = require'telescope'

M.show_issues = function(config)
    -- Fetch issues using the API
    local issues = api.get_my_issues(config)

    -- Convert the issues into a format suitable for Telescope
    local issue_entries = {}
    for _, issue in ipairs(issues) do
        table.insert(issue_entries, {
            value = issue.id,
            display = issue.summary,
            ordinal = issue.summary,
        })
    end

    -- Use Telescope to display the issues
    telescope.pickers.new({}, {
        prompt_title = "My Jira Issues",
        finder = telescope.finders.new_table({
            results = issue_entries,
        }),
        sorter = telescope.config.values.generic_sorter({}),
    }):find()
end

return M
