local M = {}

function M.create_cmdline_mapping()
	local cmp = require("cmp")
	local action_confirm_continue = cmp.mapping.confirm({ select = false })

	local function action_cmdline_next()
		if cmp.visible() then
			cmp.select_next_item()
		else
			cmp.complete()
		end
	end
	local function action_cmdline_prev()
		if cmp.visible() then
			cmp.select_prev_item()
		else
			cmp.complete()
		end
	end

	local default_cmdline_mapping = {
		["<C-g>"] = { c = action_confirm_continue },

		["<Right>"] = { c = action_confirm_continue },
		["<Tab>"] = { c = action_cmdline_next },
		["<S-Tab>"] = { c = action_cmdline_prev },
		["<C-x>"] = { c = cmp.mapping.abort() },
	}

	return default_cmdline_mapping
end

function M.create_insert_mapping()
	local cmp = require("cmp")
	local action_abort = cmp.mapping.abort()
	local action_confirm_select = cmp.mapping.confirm({ select = true })
	local action_confirm_continue = cmp.mapping.confirm({ select = false })
	local action_insert_next = cmp.mapping.select_next_item({ behavior = "select" })
	local action_insert_prev = cmp.mapping.select_prev_item({ behavior = "select" })

	local default_insert_mapping = {
		["<Right>"] = { i = action_confirm_continue },
		["<C-g>"] = { i = action_confirm_continue },

		["<CR>"] = { i = action_confirm_select },

		["<Tab>"] = { i = action_insert_next },
		["<Down>"] = { i = action_insert_next },

		["<S-Tab>"] = { i = action_insert_prev },
		["<Up>"] = { i = action_insert_prev },

		["<C-x>"] = { i = action_abort },
	}

	return default_insert_mapping
end

return M
