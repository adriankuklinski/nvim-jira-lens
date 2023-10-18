local M = {}

local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')

--- Displays a list of Jira issues in a Telescope picker.
-- This function fetches the user's Jira issues, loads them from a local file,
-- and displays them in a Telescope picker. The user can browse through the issues,
-- and view a preview of each issue's description.
-- The displayed issues can be interacted with using predefined key mappings.
M.show_issues = function()
    local config = require("nvim-jira-lens").config
    require'nvim-jira-lens.api'.get_my_issues(config)

    local issues = require("nvim-jira-lens.json").load()

    if not issues or #issues == 0 then
        print("No issues found!")
        return
    end

    local issue_entries = {}
    for _, issue in ipairs(issues) do
        table.insert(issue_entries, {
            value = issue.key,
            display = issue.key .. ": " .. issue.summary,
            ordinal = issue.summary .. " " .. issue.description,
            description = issue.description
        })
    end

    pickers.new({}, {
        prompt_title = 'Jira Issues',
        finder = finders.new_table({
            results = issue_entries,
            entry_maker = function(entry)
                return entry
            end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, _)
                local description = entry.description
                local bufnr = self.state.bufnr
                if not bufnr then return end

                vim.api.nvim_buf_set_option(bufnr, 'wrap', true)
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(description or '', "\n"))
            end,
        }),
        attach_mappings = function(_, map)
            map('i', '<CR>', actions.select_default)
            map('n', '<CR>', actions.select_default)
            return true
        end,
    }):find()
end

return M
