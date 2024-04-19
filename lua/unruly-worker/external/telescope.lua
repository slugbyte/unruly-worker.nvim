local M = {}

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
		["<C-h>"] = actions.select_horizontal,
		["<C-s>"] = actions.select_vertical,

		["<Down>"] = actions.move_selection_next,
		["<Up>"] = actions.move_selection_previous,
		["<C-e>"] = actions.move_selection_previous,
		["<C-n>"] = actions.move_selection_next,

		["<PageUp>"] = actions.preview_scrolling_up,
		["<PageDown>"] = actions.preview_scrolling_down,
		["<c-k>"] = actions.which_key,
		["<c-x>"] = actions.close,
	}

	local mappings = {
		i = default_mappings,
		n = vim.tbl_deep_extend("force", default_mappings, {
			["<Esc>"] = actions.close,
			E = actions.move_to_top,
			N = actions.move_to_bottom,
			n = actions.move_selection_next,
			e = actions.move_selection_previous,
		})
	}
	return vim.tbl_deep_extend("force", default_noop, mappings)
end

return M
