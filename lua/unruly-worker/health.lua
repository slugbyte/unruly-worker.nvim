local M = {}

local function check_setup()
	return false
end

M.check = function()
	vim.health.report_start("TODO")
	-- vim.health.report_ok("no implamentation")
	vim.health.report_error("no implamentation")
end

return M
