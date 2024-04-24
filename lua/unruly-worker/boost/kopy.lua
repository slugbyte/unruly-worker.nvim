local ascii = require("unruly-worker.ascii")
local log = require("unruly-worker.log")
local health = require("unruly-worker.health")

local M = {}

-- NOTE: register 0 is reseverd for delete
-- registers 1-9 server as kopy and delete history
-- expr_prompt_kopy does not update history

---@class UnrulyHudStateKopy
---@field register string
local state = {
	register = "+",
}

--- @return UnrulyHudStateKopy
function M.get_hud_state()
	return state
end

local function log_error_invald_kopy_reg(kopy_reg)
	if kopy_reg == "" then
		kopy_reg = "(empty)"
	end
	log.error("INVALID KOPY_REG: %s, valid registers are [a-z] [A-Z] 0 + (KOPY_REG STILL: %s)",
		vim.fn.keytrans(kopy_reg), state.register)
end

-- valid kopy registers: [a-z] [A-Z] 0 +
local function is_valid_kopy_reg(ch_int)
	if ch_int == ascii.zero or ch_int == ascii.plus then
		-- return true for 0 or +
		return true
	end
	return ascii.is_int_alpha(ch_int)
end

-- shift registers 2-9
local function shift_history()
	local i = 9
	while i > 2 do
		vim.fn.setreg(i, vim.fn.getreg(i - 1))
		i = i - 1
	end
end

--- kopy into kopy_reg and ensure kopy history stored
function M.expr_kopy()
	shift_history()
	vim.defer_fn(function()
		vim.fn.setreg("1", vim.fn.getreg(state.register))
	end, 0)
	return string.format('"%sy', state.register)
end

--- kopy line into kopy_reg and ensure kopy history stored
function M.expr_kopy_line()
	shift_history()
	vim.defer_fn(function()
		vim.fn.setreg("1", vim.fn.getreg(state.register))
	end, 0)
	return string.format('"%sY', state.register)
end

---create a ex_cmd string that has register 0 selected
--- 'dd' -> '"0dd'
---@param ex_del_cmd string
function M.create_delete_ex_cmd(ex_del_cmd)
	return string.format('"0%s', ex_del_cmd)
end

--- paste kopy_reg below
function M.expr_paste_below()
	return string.format('"%sp', state.register)
end

--- paste kopy_reg above
function M.expr_paste_above()
	return string.format('"%sP', state.register)
end

--- prompt the user to select a new kopy_reg
--- valid kopy_regs are limited to [a-z] [A-Z] 0 +
--- <enter> or <space> will reset to default register "+"
function M.prompt_kopy_reg_select()
	log.info("SELECT KOPY_REG: ")
	local ch_int = vim.fn.getchar()
	local ch_str = string.char(ch_int)
	if ch_int == ascii.escape then
		log.info("ABORTED KOPY_REG SELECT: (KOPY_REG still %s)", state.register)
		return
	end
	if is_valid_kopy_reg(ch_int) then
		state.register = ch_str
		log.info("KOPY_REG: %s", state.register)
		return
	end
	if ch_int == ascii.enter or ascii.space then
		local default_reg = health.get_health_state().kopy_reg
		if default_reg == nil then
			default_reg = "+"
		end
		state.register = default_reg
		log.info("KOPY_REG: %s", state.register)
		return
	end
	log_error_invald_kopy_reg(ch_str)
end

---set the kopy_reg
---@param kopy_reg string valid kopy_regs are limited to [a-z] [A-Z] 0 +
function M.set_kopy_reg(kopy_reg)
	if (string.len(kopy_reg) ~= 1) or (not is_valid_kopy_reg(string.byte(kopy_reg))) then
		return log_error_invald_kopy_reg(kopy_reg)
	end
	state.register = kopy_reg
end

-- prompt to paste from any register
-- reg seletion is not limited by is_valid_kopy_reg()
function M.expr_prompt_paste()
	log.info("PASTE FROM: (tap reg)")
	local ch_int = vim.fn.getchar()
	local ch = string.char(ch_int)
	return string.format('"%sp', ch)
end

-- prompt to kopy into any register
-- reg seletion is not limited by is_valid_kopy_reg()
-- this will not update the history registers 1-9 (like expr_kopy)
function M.expr_prompt_kopy()
	log.info("KOPY TO: (tap reg)")
	local ch_int = vim.fn.getchar()
	local ch = string.char(ch_int)
	return string.format('"%sy', ch)
end

return M
