local M = {}

local telescope = require'telescope'
local api = require'issue-me-daddy.api'

M.show_issues = function(config)
    local issues = api.get_my_issues(config)

    local issue_entries = {}
    for _, issue in ipairs(issues) do
        table.insert(issue_entries, {
            value = issue.key,
            display = issue.key .. ": " .. issue.summary,
            ordinal = issue.summary .. " " .. issue.description,
            description = issue.description
        })
    end

    -- Use Telescope to display the issues
    telescope.pickers.new({}, {
        prompt_title = "My Jira Issues",
        finder = telescope.finders.new_table({
            results = issue_entries,
        }),
        sorter = telescope.config.values.generic_sorter({}),
        previewer = telescope.previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                return entry.description
            end
        }),
    }):find()
end

return M

