-- NOTE: in vim lower case marks are single buffer
-- where uppercase marks are multi buffer

local log = require("unruly-worker.log")

local M = {}

local state = {
	is_local_mode = true,
	is_gutter_setup = false,
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

---@class UnrulyHudStateMark
---@field is_b_set boolean
---@field is_a_set boolean
---@field is_local_mode boolean

--- get unruly_mark hud state
--- @return UnrulyHudStateMark
function M.get_hud_state()
	local result = {
		is_a_set = false,
		is_b_set = false,
		is_local_mode = state.is_local_mode,
	}
	if state.is_local_mode then
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
	local mark_a = nil
	local mark_b = nil

	if state.is_local_mode then
		mark_a = "x"
		mark_b = "x"
		if state.is_a_set then
			mark_a = "a"
		end
		if state.is_b_set then
			mark_b = "b"
		end
	else
		mark_a = "X"
		mark_b = "X"
		if state.is_a_set then
			mark_a = "A"
		end
		if state.is_b_set then
			mark_b = "B"
		end
	end
	return string.format("[%s%s]", mark_a, mark_b)
end

--- toggle between local and global mode
function M.toggle_mode()
	state.is_local_mode = not state.is_local_mode
	if state.is_local_mode then
		log.info("MARK MODE LOCAL " .. M.get_status_text())
	else
		log.info("MARK MODE GLOBAL " .. M.get_status_text())
	end
end

--- set is_local_mode
---@param is_local_mode boolean
function M.set_is_local_mode(is_local_mode)
	state.is_local_mode = is_local_mode
end

--- delete the a mark for the currently selected mode
function M.delete_a()
	if state.is_local_mode then
		log.info("MARK CLEAR: a")
		vim.cmd("silent! delmarks a")
		return
	end
	log.info("MARK CLEAR: A")
	vim.cmd("silent! delmarks A")
end

--- delete the b mark for the currently selected mode
function M.delete_b()
	if state.is_local_mode then
		log.info("MARK CLEAR: b")
		vim.cmd("silent! delmarks b")
		return
	end
	log.info("MARK CLEAR: B")
	vim.cmd("silent! delmarks B")
end

--- delete a and b marks for the currently selected mode
function M.delete_mode()
	if state.is_local_mode then
		log.info("MARK CLEAR: local")
		vim.cmd("silent! delmarks ab")
		return
	end
	log.info("MARK CLEAR: global")
	vim.cmd("silent! delmarks AB")
end

--- delete marks a and b for for both local and global modes
function M.delete_all()
	log.info("MARK CLEAR ALL")
	vim.cmd("silent! delmarks abAB")
end

--- jump to mark a for the current mode
function M.expr_goto_a()
	if state.is_local_mode then
		return "'azz"
	else
		return "'Azz"
	end
end

--- jump to mark b for the current mode
function M.expr_goto_b()
	if state.is_local_mode then
		return "'bzz"
	else
		return "'Bzz"
	end
end

--- set mark a for the current mode
function M.expr_set_a()
	if state.is_local_mode then
		log.info("MARK SET: a")
		return "ma"
	else
		log.info("MARK SET: A")
		return "mA"
	end
end

--- set mark b for the current mode
function M.expr_set_b()
	if state.is_local_mode then
		log.info("MARK SET: b")
		return "mb"
	else
		log.info("MARK SET: B")
		return "mB"
	end
end

return M
