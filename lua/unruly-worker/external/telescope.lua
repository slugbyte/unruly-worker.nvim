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
	local mappings = {
		n = {

			["<Tab>"] = actions.toggle_selection,
			["<c-a>"] = actions.select_all,
			["<c-d>"] = actions.drop_all,
			["<c-q>"] = actions.add_selected_to_qflist + actions.open_qflist,
			["<c-l>"] = actions.add_selected_to_loclist + actions.open_loclist,

			["a"] = actions.select_all,
			["d"] = actions.drop_all,
			["q"] = actions.add_selected_to_qflist + actions.open_qflist,
			["l"] = actions.add_selected_to_loclist + actions.open_loclist,

			E = actions.move_to_top,
			N = actions.move_to_bottom,
			n = actions.move_selection_next,
			e = actions.move_selection_previous,
			["<C-e>"] = actions.move_selection_previous,
			["<C-n>"] = actions.move_selection_next,
			["<Down>"] = actions.move_selection_next,
			["<Up>"] = actions.move_selection_previous,

			["<c-x>"] = actions.close,
			["<esc>"] = actions.close,
			["<CR>"] = actions.select_default,
			["<C-h>"] = actions.select_horizontal,
			["<C-s>"] = actions.select_vertical,

			["<PageUp>"] = actions.preview_scrolling_up,
			["<PageDown>"] = actions.preview_scrolling_down,
			["<c-k>"] = actions.which_key,
		},
		i = {
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
		},
	}
	return vim.tbl_deep_extend("force", default_noop, mappings)
end

return M
