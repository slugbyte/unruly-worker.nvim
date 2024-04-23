-- NOTE: in vim lower case marks are single buffer
-- where uppercase marks are multi buffer

local S = {
	is_local_mode = true,
	is_gutter_setup = false,
}

local id = 4444

local M = {}

local SIGN_GROUP = "UNRULY_GUTTER_MARK"

local SIGN_SPEC = {
	A = {
		name = "UNRULY_GUTTER_MARK_A",
		text = "A",
	},
	B = {
		name = "UNRULY_GUTTER_MARK_B",
		text = "B",
	},
	a = {
		name = "UNRULY_GUTTER_MARK_a",
		text = "a",
	},
	b = {
		name = "UNRULY_GUTTER_MARK_b",
		text = "b",
	},
}

-- local function gutter_mark(name, buf, line)
-- 	if not S.is_gutter_setup then
-- 		local default_opts = {
-- 			texthl = "MarkSignHL",
-- 			numhl = "MarkSignNumHL",
-- 		}
-- 		vim.fn.sign_define(SIGN_SPEC.A.name, vim.tbl_extend("force", default_opts, { text = SIGN_SPEC.A.text }))
-- 		vim.fn.sign_define(SIGN_SPEC.B.name, vim.tbl_extend("force", default_opts, { text = SIGN_SPEC.B.text }))
-- 		vim.fn.sign_define(SIGN_SPEC.a.name, vim.tbl_extend("force", default_opts, { text = SIGN_SPEC.a.text }))
-- 		vim.fn.sign_define(SIGN_SPEC.b.name, vim.tbl_extend("force", default_opts, { text = SIGN_SPEC.b.text }))
-- 	end
-- 	id = id + 1
-- 	if type == SIGN_SPEC.A.name then
-- 		vim.fn.sign_place(id, SIGN_GROUP, name, buf, dict?)
-- 		e
-- 	end
-- end

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
				result.is_b_set = true
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
			result.is_b_set = true
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
	if S.is_local_mode then
		log.info("MARK MODE LOCAL " .. M.get_status_text())
	else
		log.info("MARK MODE GLOBAL " .. M.get_status_text())
	end
end

function M.set_is_local_mode_silent(is_local_mode)
	S.is_local_mode = is_local_mode
end

function M.delete_a()
	if S.is_local_mode then
		log.info("MARK CLEAR: a")
		vim.cmd("silent! delmarks a")
		return
	end
	log.info("MARK CLEAR: A")
	vim.cmd("silent! delmarks A")
end

function M.delete_b()
	if S.is_local_mode then
		log.info("MARK CLEAR: b")
		vim.cmd("silent! delmarks b")
		return
	end
	log.info("MARK CLEAR: B")
	vim.cmd("silent! delmarks B")
end

function M.delete_mode()
	if S.is_local_mode then
		log.info("MARK CLEAR: local")
		vim.cmd("silent! delmarks ab")
		return
	end
	log.info("MARK CLEAR: global")
	vim.cmd("silent! delmarks AB")
end

function M.delete_all()
	log.info("MARK CLEAR ALL")
	vim.cmd("silent! delmarks abAB")
end

function M.expr_goto_a()
	if S.is_local_mode then
		return "'azz"
	else
		return "'Azz"
	end
end

function M.expr_goto_b()
	if S.is_local_mode then
		return "'bzz"
	else
		return "'Bzz"
	end
end

function M.expr_set_a()
	if S.is_local_mode then
		log.info("MARK SET: a")
		return 'ma'
	else
		log.info("MARK SET: A")
		return 'mA'
	end
end

function M.expr_set_b()
	if S.is_local_mode then
		log.info("MARK SET: b")
		return 'mb'
	else
		log.info("MARK SET: B")
		return 'mB'
	end
end

return M
