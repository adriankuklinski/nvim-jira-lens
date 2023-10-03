local M = {}

M.setup = function()
    local username = vim.fn.input("Jira Username: ")
    local password = vim.fn.inputsecret("Jira Password: ")
    local base_url = vim.fn.input("Jira Base URL: ")

    require'nvim-jira.config'.set_credentials(username, password, base_url)
end

vim.cmd [[ command! JiraSetup lua require'nvim-jira'.setup() ]]

return M

