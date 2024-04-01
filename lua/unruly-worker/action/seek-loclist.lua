local M = {}

function M.get_state()
	local current_state = vim.fn.getloclist(0, { idx = 0, size = 0 })
	return {
		loclist_len = current_state.size,
		index = current_state.idx,
	}
end

function M.get_status_text()
	local state = M.get_state()
	return string.format("[L %d/%d]", state.index, state.loclist_len)
end

function M.seek_forward()
	vim.cmd("lnext")
end

function M.seek_reverse()
	vim.cmd("lprev")
end

function M.seek_first()
	vim.cmd("lfirst")
end

function M.seek_last()
	vim.cmd("llast")
end

return M
