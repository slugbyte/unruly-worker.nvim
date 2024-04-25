local rand = require("unruly-worker.rand")
local log = require("unruly-worker.log")
local ascii = require("unruly-worker.ascii")

local M = {}

--- write file for the buffer in focus
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
	log.info("QUIT? y for yes, f for force ")
	local byte = vim.fn.getchar()

	if byte == ascii.letter_y then
		return ":silent qall<cr>"
	end

	if byte == ascii.letter_f then
		return ":silent qall!<cr>"
	end

	vim.schedule(function()
		log.info("QUIT ABORTED")
	end)
	return "\\"
end

return M
