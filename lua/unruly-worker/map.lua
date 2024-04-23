local log = require("unruly-worker.log")

local M = {}


-- remap keys will map to current mapping (so kinda dangerous b/c who knows what peeps maps are)
-- no_remap keys will be whatever the vim EX cmd defaults are
M.no_remap = false
M.remap = true

M.silent = true
M.no_silent = false

function M.spec_custom(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		s_silent = is_silent,
		is_expr = false,
		desc = desc,
	}
end

function M.spec_custom_expr(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		is_silent = is_silent,
		is_expr = true,
		desc = desc,
	}
end

function M.spec_basic(cmd, desc)
	return M.spec_custom(cmd, M.no_remap, M.no_silent, desc)
end

function M.basic_expr(cmd, desc)
	return M.spec_custom_expr(cmd, M.no_remap, M.no_silent, desc)
end

function M.spec_noop()
	return M.spec_basic("\\", "")
end

function M.spec_cmd(cmd, desc, msg)
	return M.spec_basic(function()
		vim.cmd("silent! normal!" .. cmd)
		if msg ~= nil then
			log.info(msg)
		end
	end, desc)
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

local create_keymaps_for_map_spec_section = function(map_spec_section, skip_list)
	if map_spec_section == nil then
		return
	end
	for mode, mode_map in pairs(map_spec_section) do
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

function M.create_keymaps(map_spec, config)
	create_keymaps_for_map_spec_section(map_spec.default, config.skip_list)
	for booster, is_enabled in pairs(config.booster) do
		local is_boster_valid = map_spec[booster] ~= nil
		if is_boster_valid then
			if is_enabled then
				create_keymaps_for_map_spec_section(map_spec[booster], config.skip_list)
			end
		else
			log.error("UNRULY SETUP ERROR: unknown booster (%s)", booster)
		end
	end
end

return M
