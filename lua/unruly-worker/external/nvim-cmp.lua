local map = require("unruly-worker.map")

local M = {}

local function create_normalized_user_config(user_config)
	local default_config = {
		mapping = {},
		skip_list = {},
	}
	if user_config == nil then
		return default_config
	end
	return vim.tbl_deep_extend("force", default_config, user_config)
end

local function apply_skip_list(default_mapping, skip_list)
	for _, skip_key in ipairs(skip_list) do
		for key, _ in pairs(default_mapping) do
			if map.is_key_equal(key, skip_key) then
				default_mapping[key] = nil
			end
		end
	end
end

local function create_normalized_user_mapping(mode, user_config)
	local normalized_mapping = {}
	for key, value in pairs(user_config.mapping) do
		normalized_mapping[key] = { [mode] = value }
	end
	return normalized_mapping
end

--- create a config for nvim-cmp cmdline mapping
function M.create_cmdline_mapping(user_config)
	user_config = create_normalized_user_config(user_config)

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
	apply_skip_list(default_cmdline_mapping, user_config.skip_list)

	local user_cmdline_mapping = create_normalized_user_mapping("c", user_config)
	return vim.tbl_deep_extend("force", default_cmdline_mapping, user_cmdline_mapping)
end

--- create a config for nvim-cmp insert mode mapping
function M.create_insert_mapping(user_config)
	user_config = create_normalized_user_config(user_config)

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
	apply_skip_list(default_insert_mapping, user_config.skip_list)

	local user_insert_mapping = create_normalized_user_mapping("i", user_config)
	return vim.tbl_deep_extend("force", default_insert_mapping, user_insert_mapping)
end

return M
