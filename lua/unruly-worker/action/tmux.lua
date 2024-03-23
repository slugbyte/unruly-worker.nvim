-- TODO: impl own tmux pane switcher with auto save as possiblity
local util = require("unruly-worker.util")
local navigator_status, navigator = pcall(require, "Navigator")
local M = {}

function M.focus_left()
	if navigator_status and (navigator ~= nil) then
		navigator.left()
		return
	end
	vim.cmd("wincmd h")
	util.notify_error("Navigator.nvim not found")
end

function M.focus_down()
	if navigator_status and (navigator ~= nil) then
		navigator.down()
		return
	end
	vim.cmd("wincmd j")
	util.notify_error("Navigator.nvim not found")
end

function M.focus_up()
	if navigator_status and (navigator ~= nil) then
		navigator.up()
		return
	end
	vim.cmd("wincmd k")
	util.notify_error("Navigator.nvim not found")
end

function M.focus_right()
	if navigator_status and (navigator ~= nil) then
		navigator.right()
		return
	end
	vim.cmd("wincmd l")
	util.notify_error("Navigator.nvim not found")
end

return M
