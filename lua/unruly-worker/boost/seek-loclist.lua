local M = {}

function M.get_hud_state()
	local current_state = vim.fn.getloclist(0, { idx = 0, size = 0 })
	return {
		len = current_state.size,
		index = current_state.idx,
	}
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
