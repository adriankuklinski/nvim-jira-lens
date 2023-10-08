local M = {}

--- Encodes a string for URL transmission.
-- Replaces special characters with percent-encoded equivalents,
-- spaces with '+', and newlines with CRLF sequences.
-- @param str The string to be URL-encoded.
-- @return The URL-encoded version of the input string.
M.url_encode = function(str)
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

return M
