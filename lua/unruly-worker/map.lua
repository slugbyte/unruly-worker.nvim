local log = require("unruly-worker.log")

local M = {}

---normalize termcodes
---@param key string
local function normalize_termcodes(key)
	return vim.fn.keytrans(vim.api.nvim_replace_termcodes(key, true, false, true))
end

---check if two keys are the same
---@param a string
---@param b string
---@return boolean
local function is_key_equal(a, b)
	local len_a = #a
	local len_b = #b
	if len_a ~= len_b then
		return false
	end

	if len_a == 1 then
		return a == b
	end

	a = normalize_termcodes(a)
	b = normalize_termcodes(b)
	return a == b
end

---return false if key is in the skip_list
---@param key string
---@param skip_list string[]
---@return boolean
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
	--- TODO: force booster order, possibly through restructing keymap.lua into a list of boosters
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
