local util = require("unruly-worker.util")

local M = {}

function M.write_all()
	vim.cmd("wall")
	util.notify_info(util.emoticon())
end

return M
