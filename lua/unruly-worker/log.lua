local M = {}

--- log error, input works like string.format
---@param fmt string|number
---@param ... any
function M.error(fmt, ...)
	vim.notify(string.format(fmt, ...), vim.log.levels.ERROR)
end

--- log info, input works like string.format
---@param fmt string|number
---@param ... any
function M.info(fmt, ...)
	vim.notify(string.format(fmt, ...), vim.log.levels.INFO)
end

return M
