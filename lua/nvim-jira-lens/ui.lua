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

                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(description or '', "\n"))
                if self.state.winid then
                    vim.api.nvim_win_set_option(self.state.winid, 'wrap', true)
                end
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            local create_and_populate_file = function()
                local entry = actions.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)

                local filename = "~/workspace/jira/" .. entry.value .. ".txt"
                vim.cmd('e ' .. filename)
                vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(entry.description or '', "\n"))
            end

            map('i', '<CR>', create_and_populate_file)
            map('n', '<CR>', create_and_populate_file)
            return true
        end,
    }):find()
end

return M
