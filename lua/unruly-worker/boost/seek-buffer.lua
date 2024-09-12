local log = require("unruly-worker.log")

local M = {}

local S = {
	buf_num = -1,
	index = -1,
	len = -1,
	is_loaded = false,
	buf_list = {},
}

--- git the buffer info for a bufnum
---@param buf_num number
local function get_buf_info(buf_num)
	---@diagnostic disable-next-line: param-type-mismatch
	local buf_info = vim.fn.getbufinfo(buf_num)
	if buf_info ~= nil then
		buf_info = buf_info[1]
	end
	return buf_info
end

--- check if a buffer is netrb
local function has_netrw(buf_info)
	if buf_info ~= nil then
		return buf_info.variables.netrw_browser_active ~= nil
	end
end

---count all the buffers and find the current index
local function count_buffers()
	---WARN: this fn impl seems hacky and could probs use a cleanup
	if S.is_loaded then
		if S.buf_num ~= vim.fn.bufnr() then
			S.is_loaded = false
			count_buffers()
		end
		return
	end
	S.buf_num = vim.fn.bufnr()
	---@diagnostic disable-next-line: param-type-mismatch
	local last_buf_num = vim.fn.bufnr("$")
	local current = -1
	local total = 0
	local i = 1
	S.buf_list = {}
	while i < last_buf_num do
		local buf_info = get_buf_info(i)
		if buf_info ~= nil then
			vim.fn.bufload(i)
			if not has_netrw(buf_info) and buf_info.listed == 1 then
				total = total + 1
				table.insert(S.buf_list, i)
				if S.buf_num == i then
					current = total
				end
			end
		end
		i = i + 1
	end

	S.index = current
	S.len = total
	S.is_loaded = true
end

---@class UnrulyHudStateSeekBuffer
---@field len number current buffer count
---@field index number current buffer index

---@return UnrulyHudStateSeekBuffer
function M.get_hud_state()
	count_buffers()
	return {
		len = S.len,
		index = S.index,
	}
end

--- goto the next buffer, loop back to first if at end of list
function M.seek_next()
	-- HACK: seems a bit sketch
	count_buffers()
	if #S.buf_list <= 1 then
		S.index = 1
		log.info("no more buffers")
		return
	end

	if S.index == -1 then
		S.index = 0
	end

	local next_buffer = S.buf_list[S.index + 1]
	if next_buffer == nil then
		S.index = 1
		vim.cmd(string.format("buf %s", S.buf_list[S.index]))
		return
	end

	vim.cmd(string.format("buf %s", next_buffer))
end

--- goto the prev buffer, loop back to last if at start of list
function M.seek_prev()
	count_buffers()
	if #S.buf_list <= 1 then
		S.index = 1
		log.info("no more buffers")
		return
	end

	if S.index == -1 then
		S.index = 1
	end

	local next_buffer = S.buf_list[S.index - 1]
	if next_buffer == nil then
		S.index = #S.buf_list
		vim.cmd(string.format("buf %s", S.buf_list[S.index]))
		return
	end

	vim.cmd(string.format("buf %s", next_buffer))
end

--- goto the first buffer in list
function M.seek_start()
	count_buffers()
	S.index = 1
	vim.cmd(string.format("buf %s", S.buf_list[S.index]))
end

--- goto the last buffer in list
function M.seek_end()
	vim.cmd("blast")
	count_buffers()
	S.index = #S.buf_list
	vim.cmd(string.format("buf %s", S.buf_list[S.index]))
end

return M
