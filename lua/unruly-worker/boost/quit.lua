local log = require("unruly-worker.log")

local M = {}

-- save all buffers and print a random emoticon
function M.write_all()
	vim.cmd("wall")
	log.info(log.emoticon())
end

-- quit all buffers
function M.quit_all()
	log.info("bye bye!")
	vim.cmd("qall")
end

-- prompt for force quit, 'y' for yes, any other key for no
function M.quit_force()
	log.info("FORCE QUIT? y for yes")
	local ch_int = vim.fn.getchar()

	if ch_int == 121 then
		log.info("bye bye!")
		vim.cmd("qall!")
		return
	end

	log.info("FORCE QUIT ABORTED")
end

return M
