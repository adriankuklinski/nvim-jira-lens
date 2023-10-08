local M = {}

local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')

M.show_issues = function()
    local issues = require("issue-me-daddy.json").load()

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
        finder    = finders.new_table({
            results = issue_entries,
            entry_maker = function(entry)
                return entry
            end,
        }),
        sorter    = conf.generic_sorter({}),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                local description = entry.description
                local bufnr = self.state.bufnr
                if not bufnr then return end
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
