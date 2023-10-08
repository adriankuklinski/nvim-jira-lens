local M = {}

M.config = {}

--- Setup configuration with user provided values or defaults.
-- This function initializes the plugin with user provided configuration
-- values or defaults when not provided. It also validates mandatory
-- configuration fields to ensure they are correctly set.
-- @param user_config The configuration provided by the user.
M.setup = function(user_config)
    local default_config = {
        username = "",
        password = "",
        base_url = "",
    }
    M.config = vim.tbl_extend('force', default_config, user_config)

    -- Validate required options
    for _, opt in ipairs({"base_url", "username", "password"}) do
        assert(M.config[opt] and M.config[opt] ~= "", string.format("You must provide a valid %s for nvim-jira-lens!", opt))
    end
end

return M
