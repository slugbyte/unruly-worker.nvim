local util = require("unruly-worker.util")

local M = {}

function M.write_all()
	vim.cmd("wall")
	util.notify_info(util.emoticon())
end

function M.register_peek()
	util.notify_info("REGISTER_PEEK tap to peek")
	local ch_num = vim.fn.getchar()
	local ch = string.char(ch_num)
	if ch_num == 27 then
		util.notify_warn("REGISTER_PEEK abort")
		return
	end

	if ch_num < 21 or ch_num > 126 then
		util.notify_error("REGISTER_PEEK invalid key")
		return
	end

	local reg_content = vim.fn.getreg(ch)
	reg_content = reg_content:gsub("\n", "\\n")
	reg_content = reg_content:gsub("\t", "\\t")
	reg_content = reg_content:gsub("\t", "\\t")
	reg_content = reg_content:gsub(string.char(27), "<esc>")
	reg_content = reg_content:gsub(string.char(8), "<bs>")
	reg_content = reg_content:gsub(string.char(9), "<tab>")
	reg_content = reg_content:gsub(string.char(13), "<enter>")

	if #reg_content > 0 then
		util.notify_info(string.format("REGISTER_PEEK %s (%s)", ch, reg_content))
	else
		util.notify_info(string.format("REGISTER_PEEK %s (empty)", ch))
	end
end

return M
