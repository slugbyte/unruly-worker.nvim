local log = require("unruly-worker.log")

local M = {}

local S = {
	current_buf_num = -1,
	current_buf_index = -1,
	total_buf_count = -1,
	is_loaded = false,
	buf_list = {},
}

local function get_one_buf_info(buf_num)
	local buf_info = vim.fn.getbufinfo(buf_num)
	if (buf_info ~= nil) then
		buf_info = buf_info[1]
	end
	return buf_info
end

local function has_netrw(buf_info)
	if buf_info ~= nil then
		return buf_info.variables.netrw_browser_active ~= nil
	end
end


local function count_buffers()
	if S.is_loaded then
		if S.current_buf_num ~= vim.fn.bufnr() then
			S.is_loaded = false
			count_buffers()
		end
		return
	end
	S.current_buf_num = vim.fn.bufnr()
	local last_buf_num = vim.fn.bufnr("$")
	local current = -1
	local total = 0
	local i = 1
	S.buf_list = {}
	while i < last_buf_num do
		local buf_info = get_one_buf_info(i)
		if buf_info ~= nil then
			vim.fn.bufload(i)
			if not has_netrw(buf_info) and buf_info.listed == 1 then
				total = total + 1
				table.insert(S.buf_list, i)
				if S.current_buf_num == i then
					current = total
				end
			end
		end
		i = i + 1
	end

	S.current_buf_index = current
	S.total_buf_count = total
	S.is_loaded = true
end

function M.get_hud_state()
	count_buffers()
	return {
		len = S.total_buf_count,
		index = S.total_buf_index,
	}
end

function M.get_status_text()
	count_buffers()
	if S.current_buf_index == -1 then
		return string.format("[B ?/%d]", S.total_buf_count)
	end
	return string.format("[B %d/%d]", S.current_buf_index, S.total_buf_count)
end

function M.seek_forward()
	count_buffers()
	if #S.buf_list <= 1 then
		S.current_buf_index = 1
		log.info("no more buffers")
		return
	end

	if S.current_buf_index == -1 then
		S.current_buf_index = 0
	end

	local next_buffer = S.buf_list[S.current_buf_index + 1]
	if next_buffer == nil then
		S.current_buf_index = 1
		vim.cmd(string.format("buf %s", S.buf_list[S.current_buf_index]))
		return
	end

	vim.cmd(string.format("buf %s", next_buffer))
end

function M.seek_reverse()
	count_buffers()
	if #S.buf_list <= 1 then
		S.current_buf_index = 1
		log.info("no more buffers")
		return
	end

	if S.current_buf_index == -1 then
		S.current_buf_index = 1
	end

	local next_buffer = S.buf_list[S.current_buf_index - 1]
	if next_buffer == nil then
		S.current_buf_index = #S.buf_list
		vim.cmd(string.format("buf %s", S.buf_list[S.current_buf_index]))
		return
	end

	vim.cmd(string.format("buf %s", next_buffer))
end

function M.seek_first()
	count_buffers()
	S.current_buf_index = 1
	vim.cmd(string.format("buf %s", S.buf_list[S.current_buf_index]))
end

function M.seek_last()
	vim.cmd("blast")
	count_buffers()
	S.current_buf_index = #S.buf_list
	vim.cmd(string.format("buf %s", S.buf_list[S.current_buf_index]))
end

return M
