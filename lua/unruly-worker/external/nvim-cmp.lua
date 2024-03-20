-- if cmp is installed this function will return a table
-- with cmp_insert and cmp_cmdline props that can be assind
--
-- local ok, unruly_cmp = get_cmp_unruly()
-- if not ok then
--   return
-- end
--
-- cmp.setup({
--  ...,
--  mapping = unruly_cmp.cmp_insert
--
-- })
--
-- @return bool, table (status, result)
local function get_cmp_unruly()
	local status, cmp = pcall(require, "cmp")
	if (not status) or (cmp == nil) then
		return nil
	end
	local types = require("cmp.types")

	local action_abort = cmp.mapping.abort()
	local action_confirm_select = cmp.mapping.confirm({ select = true })
	local action_confirm_continue = cmp.mapping.confirm({ select = false })
	local action_insert_next = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select })
	local action_insert_prev = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select })

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

	local cmp_insert = {
		["<C-f>"] = { i = action_confirm_select },
		["<C-j>"] = { i = action_confirm_continue },
		["<CR>"] = { i = action_confirm_select },

		["<Tab>"] = { i = action_insert_next },
		["<Down>"] = { i = action_insert_next },

		["<S-Tab>"] = { i = action_insert_prev },
		["<Up>"] = { i = action_insert_prev },

		["<C-BS>"] = { c = action_abort },
	}

	local cmp_cmdline = {
		["<C-BS>"] = { c = action_abort },
		["<C-f>"] = { c = action_confirm_select },
		["<C-j>"] = { c = action_confirm_continue },
		["<Tab>"] = { c = action_cmdline_next },
		["<S-Tab>"] = { c = action_cmdline_prev },
	}

	return {
		-- TODO: create a way to deep merge and blacklist
		cmp_insert = cmp_insert,
		cmp_cmdline = cmp_cmdline,
	}
end

return get_cmp_unruly()
