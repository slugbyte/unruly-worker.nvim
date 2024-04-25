local log = require "unruly-worker.log"
local M = {}

---@class UnrulyHudStateSeekLoclist
---@field len number count of items in loclist
---@field index number current item in loclist

---@return UnrulyHudStateSeekLoclist
function M.get_hud_state()
	local current_state = vim.fn.getloclist(0, { idx = 0, size = 0 })
	return {
		len = current_state.size,
		index = current_state.idx,
	}
end

local function is_empty()
	local hud_state = M.get_hud_state()
	if hud_state.len < 1 then
		return true
	end
	return false
end

--- goto next item in loclist
function M.seek_next()
	if is_empty() then
		return log.error("LOCLIST EMPTY")
	end
	vim.cmd("lnext")
end

--- goto prev item in loclist
function M.seek_prev()
	if is_empty() then
		return log.error("LOCLIST EMPTY")
	end
	vim.cmd("lprev")
end

--- goto first item in loclist
function M.seek_start()
	if is_empty() then
		return log.error("LOCLIST EMPTY")
	end
	vim.cmd("lfirst")
end

--- goto last item in loclist
function M.seek_end()
	if is_empty() then
		return log.error("LOCLIST EMPTY")
	end
	vim.cmd("llast")
end

return M
