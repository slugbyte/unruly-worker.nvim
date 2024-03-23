-- TODO: write docs
-- TODO: setup luasnip
-- TODO: create a way to create a skip list?
-- TODO: create a way to merge additional mappings?
-- TODO: find a way not to directly depend on cmp?
local util = require("unruly-worker.util")

local function create_module(config)
	if config == nil then
		config = {}
	end

	local cmp = config.cmp
	if (cmp == nil) then
		util.notify_error("cmp not found")
		return nil
	end

	local luasnip = require("luasnip")
	vim.print("luasnip", luasnip)
	--
	--
	-- local select_behavior_insert = "insert"
	-- local select_behavior_continue = "select"

	local action_abort = cmp.mapping.abort()
	local action_confirm_select = cmp.mapping.confirm({ select = true })
	local action_confirm_continue = cmp.mapping.confirm({ select = false })
	local action_insert_next = cmp.mapping.select_next_item({ behavior = "select" })
	local action_insert_prev = cmp.mapping.select_prev_item({ behavior = "select" })

	local action_luasnip_next = cmp.mapping(function()
		if luasnip.expand_or_locally_jumpable() then
			luasnip.jump(1)
		end
	end)

	local action_luasnip_prev = cmp.mapping(function()
		if luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
		end
	end)
	--
	--

	local default_insert_mapping = {
		["<C-f>"] = { i = action_confirm_continue },
		["<C-j>"] = { i = action_confirm_select },

		["<CR>"] = { i = action_confirm_select },
		["<Right>"] = { i = action_confirm_select },

		["<Tab>"] = { i = action_insert_next },
		["<Down>"] = { i = action_insert_next },

		["<S-Tab>"] = { i = action_insert_prev },
		["<Up>"] = { i = action_insert_prev },

		["<C-BS>"] = { i = action_abort },
		["<c-l>"] = {
			i = action_luasnip_next,
			v = action_luasnip_next,
		},
		["<c-k"] = {
			i = action_luasnip_prev,
			v = action_luasnip_next,
		},
	}

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
		["<C-BS>"] = { c = action_abort },
		["<C-f>"] = { c = action_confirm_select },
		["<C-j>"] = { c = action_confirm_continue },
		["<Right>"] = { c = action_confirm_continue },
		["<Tab>"] = { c = action_cmdline_next },
		["<S-Tab>"] = { c = action_cmdline_prev },
	}

	return {
		insert_mapping = default_insert_mapping,
		cmdline_mapping = default_cmdline_mapping,
	}
end

return create_module
