local map = require("unruly-worker.map")

local M = {}

local function create_normalized_user_config(user_config)
	local default_config = {
		insert_mappings = {},
		normal_mappings = {},
		skip_list = {},
	}
	if user_config == nil then
		return default_config
	end
	return vim.tbl_deep_extend("force", default_config, user_config)
end

local function apply_skip_list(default_mappings, skip_list)
	for _, skip_key in ipairs(skip_list) do
		for key, _ in pairs(default_mappings) do
			if map.is_key_equal(key, skip_key) then
				default_mappings[key] = nil
			end
		end
	end
end

--- create mapings for telescope.nvim
function M.create_mappings(user_config)
	user_config = create_normalized_user_config(user_config)

	local actions = require("telescope.actions")
	local default_noop = require("telescope.mappings").default_mappings
	for key in pairs(default_noop.i) do
		default_noop.i[key] = actions.nop
	end
	for key in pairs(default_noop.n) do
		default_noop.n[key] = actions.nop
	end

	local insert_mappings = {
		["<Tab>"] = actions.toggle_selection,
		["<c-a>"] = actions.select_all,
		["<c-d>"] = actions.drop_all,
		["<c-q>"] = actions.add_selected_to_qflist + actions.open_qflist,
		["<c-l>"] = actions.add_selected_to_loclist + actions.open_loclist,

		["<CR>"] = actions.select_default,
		["<c-h>"] = actions.select_horizontal,
		["<c-s>"] = actions.select_vertical,

		["<Down>"] = actions.move_selection_next,
		["<Up>"] = actions.move_selection_previous,
		["<c-e>"] = actions.move_selection_previous,
		["<c-n>"] = actions.move_selection_next,

		["<PageUp>"] = actions.preview_scrolling_up,
		["<PageDown>"] = actions.preview_scrolling_down,
		["<c-k>"] = actions.which_key,
		["<c-x>"] = actions.close,
	}

	local normal_mappings = vim.tbl_deep_extend("keep", {
		["<esc>"] = actions.close,
		-- for some reason <c-x> gets nilled by tbl_deep_extend unless i put it here, ?wtf?
		["<c-x>"] = actions.close,
		x = actions.close,
		E = actions.move_to_top,
		N = actions.move_to_bottom,
		n = actions.move_selection_next,
		e = actions.move_selection_previous,
	}, insert_mappings)

	apply_skip_list(insert_mappings, user_config.skip_list)
	apply_skip_list(normal_mappings, user_config.skip_list)

	insert_mappings = vim.tbl_deep_extend("force", insert_mappings, user_config.insert_mappings)
	normal_mappings = vim.tbl_deep_extend("force", normal_mappings, user_config.normal_mappings)

	local mappings = {
		i = insert_mappings,
		n = normal_mappings,
	}

	return vim.tbl_deep_extend("keep", mappings, default_noop)
end

return M
