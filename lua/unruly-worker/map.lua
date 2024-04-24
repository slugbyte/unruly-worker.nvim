local log = require("unruly-worker.log")

local M = {}


-- remap keys will map to current mapping (so kinda dangerous b/c who knows what peeps maps are)
-- no_remap keys will be whatever the vim EX cmd defaults are
M.no_remap = false
M.remap = true

M.silent = true
M.no_silent = false

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

---@param value string|function
---@param desc string
---@param is_remap boolean?
---@param is_silent boolean?
function M.spec_key(value, desc, is_remap, is_silent)
	is_remap = is_remap or M.no_remap
	is_silent = is_silent or M.no_silent
	return {
		desc = desc,
		value = value,
		is_silent = is_silent,
		is_remap = is_remap,
		is_expr = false,
	}
end

---@param value string|function
---@param is_remap boolean
---@param is_silent boolean
---@param desc string
---@return UnrulySpecKey
function M.spec_custom(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		is_silent = is_silent,
		is_expr = false,
		desc = desc,
	}
end

---@param value string|function
---@param is_remap boolean
---@param is_silent boolean
---@param desc string
---@return UnrulySpecKey
function M.spec_custom_expr(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		is_silent = is_silent,
		is_expr = true,
		desc = desc,
	}
end

---@param cmd string|function
---@param desc string
---@return UnrulySpecKey
function M.spec_basic(cmd, desc)
	return M.spec_custom(cmd, M.no_remap, M.no_silent, desc)
end

---@param cmd function
---@param desc string
---@return UnrulySpecKey
function M.spec_basic_expr(cmd, desc)
	return M.spec_custom_expr(cmd, M.no_remap, M.no_silent, desc)
end

---@return UnrulySpecKey
function M.spec_noop()
	return M.spec_basic("\\", "")
end

local function is_key_equal(a, b)
	local len_a = #a
	local len_b = #b
	if len_a ~= len_b then
		return false
	end

	if len_a == 1 then
		return a == b
	end

	if (string.find(a, "leader") ~= nil) then
		-- BUG: need to remove leader then compare
		return a == b
	end

	return string.lower(a) == string.lower(b)
end

local function should_map(key, skip_list)
	local skip = false
	for _, skip_key in ipairs(skip_list) do
		skip = skip or is_key_equal(key, skip_key)
	end

	return not skip
end

---@param spec_booster UnrulySpecBooster
---@param skip_list string[]
local create_keymaps_for_spec_booster = function(spec_booster, skip_list)
	if spec_booster == nil then
		return
	end
	for mode, mode_map in pairs(spec_booster) do
		if mode == "m" then
			mode = ""
		end
		for key, key_map in pairs(mode_map) do
			if should_map(key, skip_list) then
				vim.keymap.set(mode, key, key_map.value, {
					desc = key_map.desc,
					silent = key_map.is_silent,
					remap = key_map.is_remap,
					noremap = not key_map.is_remap,
					expr = key_map.is_expr,
				})
			end
		end
	end
end

---@param spec_keymap UnrulySpecKeymap
---@param config UnrulyConfig
function M.create_keymaps(spec_keymap, config)
	create_keymaps_for_spec_booster(spec_keymap.default, config.skip_list)
	for booster, is_enabled in pairs(config.booster) do
		local is_boster_valid = spec_keymap[booster] ~= nil
		if is_boster_valid then
			if is_enabled then
				create_keymaps_for_spec_booster(spec_keymap[booster], config.skip_list)
			end
		else
			log.error("UNRULY SETUP ERROR: unknown booster (%s)", booster)
		end
	end
end

return M
