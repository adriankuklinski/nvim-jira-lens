local M = {}

M.setup = function()
    local utils = require'issue-me-daddy.utils'

    local file_path = vim.fn.expand("~/.issue_me_daddy_credentials")
    local username, password, base_url = utils.load_credentials_from_file(file_path)

    if username and username ~= "" and password and password ~= "" and base_url and base_url ~= "" then
        require'issue-me-daddy.config'.set_credentials(username, password, base_url)
    end
end

vim.cmd [[
augroup issue_me_daddy_auto_setup
    autocmd!
    autocmd VimEnter * lua require'issue-me-daddy'.setup()
augroup END
]]

return M

