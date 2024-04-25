local log = require("unruly-worker.log")
local textobject_staus, textobject = pcall(require, "nvim-treesitter.textobjects.repeatable_move")

local M = {}

--- goto the next treesitter textobject
function M.goto_next()
	if textobject_staus and (textobject ~= nil) then
		if textobject.last_move == nil then
			print("no textobject selected")
			return
		end
		local value = textobject.repeat_last_move_next({ start = true })
		print(value)
		return
	end
	log.error("treesitter textobject not found")
end

--- goto the prev treesitter textobject
function M.goto_prev()
	if textobject_staus and (textobject ~= nil) then
		if textobject.last_move == nil then
			print("no textobject selected")
			return
		end
		local result = textobject.repeat_last_move_previous({ start = true })
		print(result)
		return
	end
	log.error("treesitter textobject not found")
end

return M
