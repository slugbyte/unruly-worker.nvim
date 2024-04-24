local M = {}

-- NOTE: remap keys will execute the current mapping, this is kinda dangerous
-- b/c who knows what peeps maps are going to be, and no_remap keys will retain
-- whatever the vim EX cmd default behavior is
-- example no remap:
-- `noremap gcc` will execute default vim EX cmd `gcc`
-- example that uses remap:
-- `map gcc` will execute whatever gcc has been remaped to, for example
--	`gcc` is used to toggle comment by several comment plugins like Comment.nvim

---@enum UnrulySilentMode
M.silent_mode = {
	silent = true,
	no_silent = false,
}

---@alias silent boolean

---@class UnrulySpecKey
---@field value string|function
---@field is_remap boolean
---@field is_silent boolean
---@field is_expr boolean
---@field desc string

---@class UnrulySpecBooster
---@field m {[string]:UnrulySpecKey}
---@field n {[string]:UnrulySpecKey}
---@field i {[string]:UnrulySpecKey}
---@field v {[string]:UnrulySpecKey}
---@field s {[string]:UnrulySpecKey}
---@field x {[string]:UnrulySpecKey}
---@field o {[string]:UnrulySpecKey}

---@alias UnrulySpecKeymap {[string]:UnrulySpecBooster}

---create a noremap keymap
---@param value string|function
---@param desc string
---@param is_silent UnrulySilentMode? defaults to spec.silent__mode.no_silent
---@return UnrulySpecKey
function M.map(value, desc, is_silent)
	is_silent = is_silent or M.silent_mode.no_silent
	return {
		desc = desc,
		value = value,
		is_silent = is_silent,
		is_remap = false,
		is_expr = false,
	}
end

---create a remap keymap
---@param value string|function
---@param desc string
---@param is_silent UnrulySilentMode? defaults to spec.silent_mode.no_silent
---@return UnrulySpecKey
function M.remap(value, desc, is_silent)
	is_silent = is_silent or M.silent_mode.no_silent
	return {
		desc = desc,
		value = value,
		is_silent = is_silent,
		is_remap = true,
		is_expr = false,
	}
end

---create an noremap expr keymap
---@param value function function should return string with EX command
---@param desc string
---@param is_silent UnrulySilentMode? defaults to spec.silent_mode.no_silent
---@return UnrulySpecKey
function M.expr(value, desc, is_silent)
	is_silent = is_silent or M.silent_mode.no_silent
	return {
		desc = desc,
		value = value,
		is_silent = is_silent,
		is_remap = false,
		is_expr = true,
	}
end

---create a keymap with no behavior
---@return UnrulySpecKey
function M.noop()
	return M.map("\\", "")
end

return M
