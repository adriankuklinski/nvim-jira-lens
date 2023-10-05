local M = {}

local api = require'issue-me-daddy.api'

local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values

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
                local issue = entry.value
                local description = issue.description
                self.displayed = true
                local bufnr = self.state.bufnr
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(description, "\n"))
            end,
        }),
        attach_mappings = function(prompt_bufnr)
            actions.goto_file_selection_edit:replace(function()
                local entry = actions.get_selected_entry()
                actions.close(prompt_bufnr)
                -- Do something with the selected entry if necessary
            end)
            return true
        end,
    }):find()
end

return M

