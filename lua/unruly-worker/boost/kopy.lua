local ascii = require("unruly-worker.ascii")
local log = require("unruly-worker.log")
-- register 9 is reseverd for delete
-- if register 1 is selected then
--     registers 1-8 act like a history

---@class UnrulyHudStateKopy
---@field register string
local state = {
	register = "+",
}

-- valid kopy registers: [a-z] [A-Z] 0 +
local function is_valid_kopy_register(ch_int)
	if ch_int == 48 or ch_int == 43 then
		-- return true for 0 or +
		return true
	end
	return ascii.is_int_alpha(ch_int)
end

local function shift_history()
	local i = 9
	while i > 2 do
		vim.fn.setreg(i, vim.fn.getreg(i - 1))
		i = i - 1
	end
end

local M = {}

--- @return UnrulyHudStateKopy
function M.get_hud_state()
	return state
end

function M.get_status_text()
	return string.format("[K %s]", state.register)
end

function M.expr_yank()
	shift_history()
	vim.defer_fn(function()
		vim.fn.setreg("1", vim.fn.getreg(state.register))
	end, 0)
	return string.format('"%sy', state.register)
end

function M.expr_yank_line()
	shift_history()
	vim.defer_fn(function()
		vim.fn.setreg("1", vim.fn.getreg(state.register))
	end, 0)
	return string.format('"%sY', state.register)
end

function M.create_delete_cmd(key)
	return string.format('"0%s', key)
end

function M.expr_paste_below()
	return string.format('"%sp', state.register)
end

function M.expr_paste_above()
	return string.format('"%sP', state.register)
end

function M.expr_paste_transform_below()
	vim.fn.setreg("9", vim.fn.keytrans(vim.fn.getreg(state.register)))
	return '"9p'
end

function M.register_select()
	log.info("YANK REGISTER SELECT> ")
	local ch_int = vim.fn.getchar()
	print("int", ch_int)
	local ch_str = string.char(ch_int)
	if is_valid_kopy_register(ch_int) then
		state.register = ch_str
		log.info("YANK REGISTER: %s", state.register)

		return
	end
	if ch_int == 13 or ch_int == 32 then
		state.register = "+"
		log.info("YANK REGISTER: %s", state.register)
		return
	end
	if ch_int == 27 then
		log.info("ABORTED SELECT")
		return
	end
	log.error("invalid register: %s, valid registers are [a-z] [A-Z] 0 + (Yank Register Still: %s)",
		vim.fn.keytrans(ch_str), state.register)
end

function M.register_dupe()
end

function M.register_clear()
end

function M.set_register_silent(register)
	if string.len(register) ~= 1 then
		log.error("invalid register: register must be a single character [a-z][A-X] + 0")
	end
	if is_valid_kopy_register(string.byte(register)) then
		state.register = register
		return
	end

	log.error("invalid register (%s): must be [a-z][A-Z] + 0", register)
end

-- function M.register_peek()
-- 	log.info("REGISTER PEEK SELECT> ")
-- 	local ch_int = vim.fn.getchar()
-- 	local ch = string.char(ch_int)
-- 	if ch_int == 27 then
-- 		util.warn("ABORTED PEEK")
-- 		return
-- 	end
--
-- 	if not is_valid_register(ch_int) then
-- 		log.error("INVALID REGISTER")
-- 		return
-- 	end
--
-- 	local reg_content = vim.fn.getreg(ch)
--
-- 	if #reg_content > 0 then
-- 		reg_content = vim.fn.keytrans(reg_content)
-- 		log.info("REGISTER PEEK %s (%s)", ch, reg_content)
-- 	else
-- 		log.info("REGISTER PEEK %s (empty)", ch)
-- 	end
-- end

return M
