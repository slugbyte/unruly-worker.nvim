local util = require("unruly-worker.util")
local navigator_status, navigator = pcall(require, "Navigator")
local M = {}

-- focus left with navigator.nvim, has vim only fallback
function M.focus_left_safe()
	if navigator_status and (navigator ~= nil) then
		navigator.left()
		return
	end
	vim.cmd("wincmd h")
	util.error("Navigator.nvim not found")
end

-- focus down with navigator.nvim, has vim only fallback
function M.focus_down_safe()
	if navigator_status and (navigator ~= nil) then
		navigator.down()
		return
	end
	vim.cmd("wincmd j")
	util.error("Navigator.nvim not found")
end

-- focus up with navigator.nvim, has vim only fallback
function M.focus_up_safe()
	if navigator_status and (navigator ~= nil) then
		navigator.up()
		return
	end
	vim.cmd("wincmd k")
	util.error("Navigator.nvim not found")
end

-- focus right with navigator.nvim, has vim only fallback
function M.focus_right_safe()
	if navigator_status and (navigator ~= nil) then
		navigator.right()
		return
	end
	vim.cmd("wincmd l")
	util.error("Navigator.nvim not found")
end

return M
