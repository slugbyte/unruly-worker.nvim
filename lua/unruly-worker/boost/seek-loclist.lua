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

--- goto next item in loclist
function M.seek_forward()
	vim.cmd("lnext")
end

--- goto prev item in loclist
function M.seek_reverse()
	vim.cmd("lprev")
end

--- goto first item in loclist
function M.seek_first()
	vim.cmd("lfirst")
end

--- goto last item in loclist
function M.seek_last()
	vim.cmd("llast")
end

return M
