local M = {}

function M.error(...)
	vim.notify(string.format(...), vim.log.levels.ERROR)
end

function M.info(...)
	vim.notify(string.format(...), vim.log.levels.INFO)
end

return M
