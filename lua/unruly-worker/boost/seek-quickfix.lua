local log = require("unruly-worker.log")
local M = {}

---@class UnrulyHudStateSeekQuickfix
---@field len number count of items in quickfix list
---@field index number current item in quickfix list

---@return UnrulyHudStateSeekQuickfix
function M.get_hud_state()
	local current_state = vim.fn.getqflist({ idx = 0, size = 0 })
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

--- goto next item in quickfix
function M.seek_next()
	if is_empty() then
		return log.error("QUICKFIX LIST EMPTY")
	end
	vim.cmd("cnext")
end

--- goto next item in quickfix
function M.seek_prev()
	if is_empty() then
		return log.error("QUICKFIX LIST EMPTY")
	end
	vim.cmd("cprev")
end

--- goto first item in quickfix
function M.seek_start()
	if is_empty() then
		return log.error("QUICKFIX LIST EMPTY")
	end
	vim.cmd("cfirst")
end

--- goto last item in quickfix
function M.seek_end()
	if is_empty() then
		return log.error("QUICKFIX LIST EMPTY")
	end
	vim.cmd("clast")
end

return M
