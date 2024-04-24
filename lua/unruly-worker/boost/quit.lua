local rand = require("unruly-worker.rand")
local log = require("unruly-worker.log")

local M = {}

function M.write_file()
	local status, filename = pcall(vim.fn.expand, "%")
	if status and (#filename > 0) then
		vim.cmd("w")
		log.info("%s write %s", rand.emoticon(), filename)
		return
	end
	log.error("WRITE FAILED: no filename")
end

--- save all buffers and print a random emoticon
function M.write_all()
	log.info(rand.emoticon() .. rand.feedback())
	vim.cmd("wall")
end

--- quit all prompt "y" for yes "f" for force
function M.expr_prompt_quit_all()
	log.error("QUIT? y for yes, f for force ")

	local ch_int = vim.fn.getchar()

	-- y for quit all
	if ch_int == 121 then
		return ":silent qall<cr>"
	end

	-- f for force quit all
	if ch_int == 102 then
		return ":silent qall!<cr>"
	end

	vim.schedule(function()
		log.info("QUIT ABORTED")
	end)
	return "\\"
end

return M
