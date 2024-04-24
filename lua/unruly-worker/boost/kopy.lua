local ascii = require("unruly-worker.ascii")
local log = require("unruly-worker.log")
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
	log.error("INVALID KOPY_REG: %s, valid registers are [a-z] [A-Z] 0 + (KOPY_REG STILL: %s)",
		vim.fn.keytrans(kopy_reg), state.register)
end

-- valid kopy registers: [a-z] [A-Z] 0 +
local function is_valid_kopy_reg(ch_int)
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

function M.expr_kopy()
	shift_history()
	vim.defer_fn(function()
		vim.fn.setreg("1", vim.fn.getreg(state.register))
	end, 0)
	return string.format('"%sy', state.register)
end

function M.expr_kopy_line()
	shift_history()
	vim.defer_fn(function()
		vim.fn.setreg("1", vim.fn.getreg(state.register))
	end, 0)
	return string.format('"%sY', state.register)
end

function M.create_delete_ex_cmd(key)
	return string.format('"0%s', key)
end

function M.expr_paste_below()
	return string.format('"%sp', state.register)
end

function M.expr_paste_above()
	return string.format('"%sP', state.register)
end

--- TODO: reset default reg in prompt_kopy_reg_select should default to
--- config.unruly_kopy_register

--- prompt the user to select a new kopy_reg
--- valid kopy_regs are limited to [a-z] [A-Z] 0 +
--- <enter> or <space> will reset to default register "+"
function M.prompt_kopy_reg_select()
	log.info("SELECT KOPY_REG: ")
	local ch_int = vim.fn.getchar()
	print("int", ch_int)
	local ch_str = string.char(ch_int)
	if is_valid_kopy_reg(ch_int) then
		state.register = ch_str
		log.info("KOPY_REG: %s", state.register)

		return
	end
	if ch_int == 13 or ch_int == 32 then
		state.register = "+"
		log.info("KOPY_REG: %s", state.register)
		return
	end
	if ch_int == 27 then
		log.info("ABORTED KOPY_REG SELECT")
		return
	end
	log_error_invald_kopy_reg(ch_str)
end

--- set a new kopy reg
--- valid kopy_regs are limited to [a-z] [A-Z] 0 +
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
