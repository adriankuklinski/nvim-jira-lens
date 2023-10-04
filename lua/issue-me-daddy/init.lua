local M = {}
M.config = {}

-- Setup function to initialize and configure the plugin
M.setup = function(opts)
    -- Use provided options or default to an empty table
    opts = opts or {}

    -- Default configuration values
    local default_opts = {
        username = "",
        password = "",
        base_url = "",
    }

    -- Overwrite defaults with user provided options where available
    for k, v in pairs(default_opts) do
        if opts[k] == nil then
            opts[k] = v
        end
    end

    local required_opts = {"base_url", "username", "password"}
    for _, opt in ipairs(required_opts) do
        if not opts[opt] or opts[opt] == "" then
            error(string.format("You must provide a valid %s for issue-me-daddy!", opt))
        end
    end

    M.config = opts
end

return M
