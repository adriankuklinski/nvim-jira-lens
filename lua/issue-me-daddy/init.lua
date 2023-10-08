local M = {}

M.config = {}

M.setup = function(user_config)
    local default_config = {
        username = "",
        password = "",
        base_url = "",
    }
    M.config = vim.tbl_extend('force', default_config, user_config)

    -- Validate required options
    for _, opt in ipairs({"base_url", "username", "password"}) do
        assert(M.config[opt] and M.config[opt] ~= "", string.format("You must provide a valid %s for issue-me-daddy!", opt))
    end
end

return M
