local M = {}

-- TODO: impl a skip_list for telescope

--- create mapings for telescope.nvim
function M.create_mappings()
	local actions = require("telescope.actions")
	local default_noop = require("telescope.mappings").default_mappings
	for key in pairs(default_noop.i) do
		default_noop.i[key] = actions.nop
	end
	for key in pairs(default_noop.n) do
		default_noop.n[key] = actions.nop
	end

	local default_mappings = {
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

	local mappings = {
		i = default_mappings,
		n = vim.tbl_deep_extend("keep", {
			["<esc>"] = actions.close,
			-- for some reason <c-x> gets nilled by tbl_deep_extend unless i put it here, ?wtf?
			["<c-x>"] = actions.close,
			x = actions.close,
			E = actions.move_to_top,
			N = actions.move_to_bottom,
			n = actions.move_selection_next,
			e = actions.move_selection_previous,
		}, default_mappings)
	}
	return vim.tbl_deep_extend("keep", mappings, default_noop)
end

return M
