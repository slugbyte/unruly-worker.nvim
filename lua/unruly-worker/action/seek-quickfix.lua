local M = {}

function M.get_state()
	local current_state = vim.fn.getqflist({ idx = 0, size = 0 })
	return {
		quickfix_len = current_state.size,
		index = current_state.idx,
	}
end

function M.get_status_text()
	local state = M.get_state()
	return string.format("[Q %d/%d]", state.index, state.quickfix_len)
end

function M.seek_forward()
	vim.cmd("cnext")
end

function M.seek_reverse()
	vim.cmd("cprev")
end

function M.seek_first()
	vim.cmd("cfirst")
end

function M.seek_last()
	vim.cmd("clast")
end

return M
