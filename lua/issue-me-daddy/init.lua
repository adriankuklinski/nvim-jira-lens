local M = {}

M.setup = function()
    local username = vim.fn.input("Jira Username: ")
    local password = vim.fn.inputsecret("Jira Password: ")
    local base_url = vim.fn.input("Jira Base URL: ")

    require'issue-me-daddy.config'.set_credentials(username, password, base_url)
end

vim.cmd [[ command! IssueMeSetup lua require'issue-me-daddy'.setup() ]]

return M

