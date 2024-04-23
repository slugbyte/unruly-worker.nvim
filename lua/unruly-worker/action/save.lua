local log = require("unruly-worker.log")

local M = {}

-- save all buffers and print a random emoticon
function M.write_all()
	vim.cmd("wall")
	log.info(log.emoticon())
end

return M
