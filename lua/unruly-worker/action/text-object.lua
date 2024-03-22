local util = require("unruly-worker.util")
local textobject_staus, textobject = pcall(require, "nvim-treesitter.textobjects.repeatable_move")

local M = {}

function M.seek_forward()
	if textobject_staus and (textobject ~= nil) then
		textobject.repeat_last_move_next()
	end
	util.notify_error("treesitter textobject not found")
end

function M.seek_reverse()
	if textobject_staus and (textobject ~= nil) then
		textobject.repeat_last_move_previous()
	end
	util.notify_error("treesitter textobject not found")
end

return M
