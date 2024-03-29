-- in vim lower case marks are single buffer
-- where uppercase marks are multi buffer
local S = {
	is_local_mode = true,
}

local M = {}


function M.get_state()
	local result = {
		is_a_set = false,
		is_b_set = false,
		is_local_mode = S.is_local_mode
	}
	if S.is_local_mode then
		local local_mark_list = vim.fn.getmarklist(vim.fn.bufnr())
		for _, item in ipairs(local_mark_list) do
			if item.mark == "'a" then
				result.is_a_set = true
			end
			if item.mark == "'b" then
				result.is_a_set = true
			end
		end
		return result
	end
	local global_mark_list = vim.fn.getmarklist()
	for _, item in ipairs(global_mark_list) do
		if item.mark == "'A" then
			result.is_a_set = true
		end
		if item.mark == "'B" then
			result.is_a_set = true
		end
	end
	return result
end

function M.get_status_text()
	local a = "x"
	local b = "x"
	local mark_status = M.get_state()

	if mark_status.is_a_set then
		a = "a"
	end
	if mark_status.is_b_set then
		b = "b"
	end

	if not S.is_local_mode then
		a = string.upper(a)
		b = string.upper(b)
	end

	return string.format("[%s%s]", a, b)
end

function M.toggle_mode()
	S.is_local_mode = not S.is_local_mode
end

function M.delete_mark_a()
	vim.cmd("silent! delmarks! a")
end

function M.delete_mark_b()
	vim.cmd("silent! delmarks! a")
end

function M.expr_goto_mark_a()
	if S.is_local_mode then
		return "'azz"
	else
		return "'Azz"
	end
end

function M.expr_goto_mark_b()
	if S.is_local_mode then
		return "'bzz"
	else
		return "'Bzz"
	end
end

function M.expr_set_mark_a()
	if S.is_local_mode then
		return 'ma'
	else
		return 'mA'
	end
end

function M.expr_set_mark_b()
	if S.is_local_mode then
		return 'mb'
	else
		return 'mB'
	end
end

return M
