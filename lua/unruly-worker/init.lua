--                       __                         __
--   __ _____  ______ __/ /_ _______    _____  ____/ /_____ ____
--  / // / _ \/ __/ // / / // /___/ |/|/ / _ \/ __/  '_/ -_) __/
--  \_,_/_//_/_/  \_,_/_/\_, /    |__,__/\___/_/ /_/\_\\__/_/
--                      /___/
--
--  Name: unruly-worker
--  License: Unlicense
--  Maintainer: Duncan Marsh (slugbyte@slugbyte.com)
--  Repository: https://github.com/slugbyte/unruly-worker
--
-- TODO: add and document tmux config
-- TODO: !! put marks in gutter https://github.com/chentoast/marks.nvim/blob/74e8d01b2a2131b6e46354cffc553aa7f81bcf5b/lua/marks/utils.lua#L9C1-L19C1
-- TODO: figure out how to chage from quick list 0 - 9, is this necessary?
--
-- Idea: ?? make some helper unruly user commands
--
-- Idea: do magic with keytrans to make it so you can edit macros with insert mode
--       ?maby? user cmommand to paste keytrans macro
--       ?maby? user command YANK keytrans macro
--
-- Idea: create a healthcheck report
--
-- Idea: create a UnrulyTutor
local state = {
	is_setup = false,
	config = nil,
}

local util = require("unruly-worker.util")
local action = require("unruly-worker.action")

-- remap keys will map to current mapping (so kinda dangerous b/c who knows what peeps maps are)
-- no_remap keys will be whatever the vim EX cmd defaults are
local no_remap = false
local remap = true

local silent = true
local no_silent = false

local function cfg_custom(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		s_silent = is_silent,
		is_expr = false,
		desc = desc,
	}
end

local function cfg_custom_expr(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		is_silent = is_silent,
		is_expr = true,
		desc = desc,
	}
end

local function cfg_basic(cmd, desc)
	return cfg_custom(cmd, no_remap, no_silent, desc)
end

local function cfg_basic_expr(cmd, desc)
	return cfg_custom_expr(cmd, no_remap, no_silent, desc)
end

local function cfg_noop()
	return cfg_basic("\\", "")
end

local function cfg_cmd(cmd, desc, msg)
	return cfg_basic(function()
		vim.cmd("silent! normal!" .. cmd)
		if msg ~= nil then
			util.notify(msg)
		end
	end, desc)
end

local mapping = {
	general = {
		m = {
			-- alphabet
			a = cfg_custom("a", remap, no_silent, "append cursor"),
			A = cfg_basic("A", "append line"),
			["<c-a>"] = cfg_basic_expr(action.mark.expr_goto_a, "GOTO MARK: a"),
			["<leader>a"] = cfg_basic_expr(action.mark.expr_set_a, "MARK SET: a"),
			["<c-b>"] = cfg_basic_expr(action.mark.expr_goto_b, "GOTO MARK: b"),
			["<leader>b"] = cfg_basic_expr(action.mark.expr_set_b, "MARK SET: b"),
			b = cfg_basic("%", "brace match"),
			B = cfg_basic("g;", "back to last change"),
			c = cfg_basic(action.kopy.create_delete_cmd("c"), "change content, store old in reg 0"),
			cc = cfg_basic(action.kopy.create_delete_cmd("cc"), "changle lines, store old in reg 0"),
			C = cfg_basic(action.kopy.create_delete_cmd("C"), "change to EOL, store old in reg 0"),
			d = cfg_basic(action.kopy.create_delete_cmd("d"), "delete motion into reg 0"),
			dd = cfg_basic(action.kopy.create_delete_cmd("dd"), "delete motion into reg 0"),
			D = cfg_basic(action.kopy.create_delete_cmd("D"), "delete motion into reg 0"),
			e = cfg_basic("gk", "up"),
			E = cfg_cmd("vip", "envelope paraghaph"),
			f = cfg_basic("n", "find next"),
			F = cfg_basic("N", "find prev"),
			["<leader>f"] = cfg_basic("g*", "[F]ind Word Under Cursor"),
			["<leader>F"] = cfg_basic("g#", "[F]ind Word Under Cursor Reverse"),
			g = cfg_basic("g", "g command"),
			G = cfg_basic("G", "goto line"),
			h = cfg_basic(";", "hop t repeat"),
			H = cfg_basic(",", "hop t reverse"),
			i = cfg_basic("i", "insert"),
			I = cfg_basic("I", "insert BOL"),
			j = cfg_noop(),
			J = cfg_noop(),
			["<c-j>"] = cfg_basic(action.telescope.jump_list_safe, "jump list"),
			k = cfg_basic_expr(action.kopy.expr_yank, "kopy"),
			K = cfg_basic_expr(action.kopy.expr_yank_line, "kopy line"),
			l = cfg_basic("o", "line insert below"),
			L = cfg_basic("O", "line insert above"),
			["<leader>ll"] = cfg_basic("o<esc>^d$<Up>", "[L]ine Below"),
			["<leader>lL"] = cfg_basic("O<esc>^d$<Down>", "[L]ine Above"),
			m = cfg_basic(action.mark.toggle_mode, "mark mode toggle"),
			M = cfg_basic(action.mark.delete_mode, "mark delete mode"),
			n = cfg_basic("gj", "down"),
			N = cfg_basic("J", "join lines"),
			o = cfg_basic("l", "right"),
			O = cfg_basic("$", "right to EOL"),
			p = cfg_basic_expr(action.kopy.expr_paste_below, "paste after"),
			P = cfg_basic_expr(action.kopy.expr_paste_above, "paste before"),
			q = cfg_noop(),
			Q = cfg_noop(),
			r = cfg_basic("r", "replace"),
			R = cfg_basic("R", "replace mode"),
			s = cfg_noop(),
			S = cfg_noop(),
			["<leader>sc"] = cfg_basic(action.telescope.spell_suggest_safe, "[S]pell [C]heck"),
			t = cfg_basic("f", "to char"),
			T = cfg_basic("F", "to char reverse"),
			u = cfg_basic("u", "undo"),
			U = cfg_basic("<C-r>", "redo"),
			v = cfg_basic("v", "visual mode"),
			V = cfg_basic("V", "visual line mode"),
			w = cfg_basic("w", "word forward"),
			W = cfg_basic("b", "word backward"),
			x = cfg_basic(action.kopy.create_delete_cmd("x"), "delete char into reg 0"),
			X = cfg_basic(action.kopy.create_delete_cmd("X"), "delete previous char into reg 0"),
			y = cfg_basic("h", "left"),
			Y = cfg_basic("^", "left to BOL"),

			-- macro
			z = cfg_basic(action.macro.record, "macro record"),
			Z = cfg_basic(action.macro.play, "macro play"),
			["<c-z>"] = cfg_basic(action.macro.select_register, "select macro register"),
			["<leader>zl"] = cfg_basic(action.macro.lock_toggle, "Macro [L]ock Toggle"),
			['<leader>zp'] = cfg_basic(action.macro.peek_register, "Macro [P]eek"),

			-- parens
			[")"] = cfg_basic(")", "next sentence"),
			["("] = cfg_basic("(", "prev sentence"),

			["}"] = cfg_basic("}", "next paragraph"),
			["{"] = cfg_basic("{", "prev paragraph"),

			["["] = cfg_basic("<C-o>", "jumplist back"),
			["]"] = cfg_basic("<C-i>", "jumplist forward"),

			["<"] = cfg_basic("<", "nudge left"),
			[">"] = cfg_basic(">", "nudge right"),

			-- case swap
			["~"] = cfg_basic("~", "case swap"),

			-- command
			[":"] = cfg_basic(":", "command mode"),
			["'"] = cfg_basic(":", "command mode"),
			["/"] = cfg_basic("/", "search down"),
			["?"] = cfg_basic("?", "search up"),

			-- paste delete
			[","] = cfg_basic('"0P', "paste register x above"),
			["."] = cfg_basic('"0p', "paste register x below"),

			-- register
			['"'] = cfg_basic(action.kopy.register_select, "register select"),

			-- window nav
			["<C-w>k"] = cfg_noop(),
			["<C-w>l"] = cfg_noop(),
			["<C-w>y"] = cfg_basic("<C-w>h", "focus left"),
			["<C-w>n"] = cfg_basic("<C-w>j", "focus down"),
			["<C-w>e"] = cfg_basic("<C-w>k", "focus up"),
			["<C-w>o"] = cfg_basic("<C-w>l", "focus right"),
			["<C-w>x"] = cfg_basic(":close<CR>", "close pane"),
			["<C-w>f"] = cfg_basic(":on<CR>", "full screen"),
			["<C-w>h"] = cfg_basic(":sp<CR>", "split horizontal"),
			["<C-w>s"] = cfg_basic(":vs<CR>", "split verticle"),
			["<C-y>"] = cfg_basic("<C-w>h", "focus left"),
			["<C-n>"] = cfg_basic("<C-w>j", "focus down"),
			["<C-e>"] = cfg_basic("<C-w>k", "focus up"),
			["<C-o>"] = cfg_basic("<C-w>l", "focus right"),
			["<C-x>"] = cfg_basic(":close<CR>", "close pane"),
			["<C-f>"] = cfg_basic(":on<CR>", "full screen"),
			["<C-h>"] = cfg_basic(":sp<CR>", "split horizontal"),
			["<C-s>"] = cfg_basic(":vs<CR>", "split verticle"),

			-- cursor align
			["@"] = cfg_basic("zt", "align top"),
			["$"] = cfg_basic("zz", "align middle"),
			["#"] = cfg_basic("zb", "align bottom"),

			-- noop
			["%"] = cfg_noop(),
			["^"] = cfg_noop(),
			["="] = cfg_noop(),
			["&"] = cfg_basic("&", "repeat subsitute"),
			["*"] = cfg_noop(),
			["-"] = cfg_noop(),
			["_"] = cfg_noop(),
			["+"] = cfg_noop(),

			["!"] = cfg_basic(".", "repeat change"),
			["|"] = cfg_noop(),
			[";"] = cfg_noop(),
		},
		n = {
			-- swap lines normal
			["%"] = cfg_custom(function()
				local current_file = vim.fn.expandcmd("%")
				if current_file == "%" then
					util.error("cannot source noname buffer, try to save file beforce sourcing")
					return
				end
				local keys = vim.api.nvim_replace_termcodes(":source %<cr>", true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end, no_remap, no_silent, "source current buffer"),
		},
		c = {
			["<C-a>"] = cfg_basic("<home>", "goto BOL"),
			["<C-e>"] = cfg_basic("<end>", "goto EOL"),
		},
	},
	experimental_seek = {
		m = {
			["<leader>n"] = cfg_basic(action.seek.seek_forward, "[N]ext Seek"),
			["<leader>p"] = cfg_basic(action.seek.seek_reverse, "[P]rev Seek"),
			["<leader>sf"] = cfg_basic(action.seek.seek_first, "[S]eek [F]irst"),
			["<leader>sl"] = cfg_basic(action.seek.seek_last, "[S]eek [L]ast"),
			["<leader>sQ"] = cfg_basic(action.seek.mode_set_quickfix, "[S]eek mode [Q]uickfix"),
			["<leader>sL"] = cfg_basic(action.seek.mode_set_loclist, "[S]eek mode [L]oclist"),
			["<leader>sB"] = cfg_basic(action.seek.mode_set_buffer, "[S]eek mode [B]uffer"),
		},
	},
	quit_easy = {
		m = {
			q = cfg_basic(action.save.write_all, "write all"),
			Q = cfg_basic(":qall<cr>", "quit all"),
			["<C-q>"] = cfg_basic(":qall!<cr>", "quit all force"),
		},
	},
	scroll_easy = {
		m = {
			["<End>"] = cfg_basic("9<C-E>", "scroll down fast"),
			["<PageDown>"] = cfg_basic("3<C-E>", "scroll down"),
			["<PageUp>"] = cfg_basic("3<C-Y>", "scroll up"),
			["<Home>"] = cfg_basic("9<C-Y>", "scroll down fast"),
		},
	},
	swap_easy = {
		n = {
			["<C-Down>"] = cfg_basic(":m .+1<CR>==", "swap down"),
			["<C-Up>"] = cfg_basic(":m .-2<CR>==", "swap up"),
		},
		v = {
			["<C-Down>"] = cfg_basic(":m '>+1<CR>gv=gv", "swap down"),
			["<C-Up>"] = cfg_basic(":m '<-2<CR>gv=gv", "swap up"),
		},
	},
	incrament_easy = {
		v = {
			["<leader>i"] = cfg_basic("g<C-a>", "[I]ncrament Number Column"),
		},
	},
	hlsearch_easy = {
		n = {
			["<esc>"] = cfg_basic("<cmd>nohlsearch<CR>", "disable hl search"),
		},
	},
	lsp_easy = {
		m = {
			[";"] = cfg_basic(vim.lsp.buf.hover, "lsp hover"),
			["="] = cfg_basic(vim.lsp.buf.code_action, "lsp code action"),
			["<C-r>"] = cfg_basic(vim.lsp.buf.rename, "lsp rename"),
			["<C-d>"] = cfg_basic(action.telescope.lsp_definiton_safe, "lsp definition"),
		},
	},
	lsp_leader = {
		m = {
			["<leader>la"] = cfg_basic(vim.lsp.buf.code_action, "[L]sp Code [A]ction"),
			["<leader>lh"] = cfg_basic(vim.lsp.buf.hover, "[L]sp [H]over"),
			["<leader>ld"] = cfg_basic(action.telescope.lsp_definiton_safe, "[L]sp goto [D]efinition"),
			["<leader>lD"] = cfg_basic(vim.lsp.buf.declaration, "[L]sp goto [D]eclaration"),
			["<leader>lf"] = cfg_basic(vim.lsp.buf.format, "[L]sp [F]ormat"),
			["<leader>lR"] = cfg_basic(vim.lsp.buf.rename, "[L]sp [R]ename"),
		},
	},
	diagnostic_easy = {
		m = {
			["_"] = cfg_basic(vim.diagnostic.goto_next, "diagnostic next"),
			["-"] = cfg_basic(vim.diagnostic.goto_prev, "diagnostic prev"),
		},
	},
	diagnostic_leader = {
		m = {
			["<leader>dn"] = cfg_basic(vim.diagnostic.goto_next, "diagnostic next"),
			["<leader>dp"] = cfg_basic(vim.diagnostic.goto_prev, "diagnostic prev"),
		},
	},
	plugin_comment = {
		n = {
			["<C-c>"] = cfg_custom("gcc", remap, no_silent, "comment"),
		},
		v = {
			["<C-c>"] = cfg_custom("gc", remap, no_silent, "comment"),
		},
	},
	plugin_navigator = {
		m = {
			["<C-y>"] = cfg_custom(action.tmux.focus_left, no_remap, silent, "focus left (vim/tmux)"),
			["<C-n>"] = cfg_custom(action.tmux.focus_down, no_remap, silent, "focus down (vim/tmux)"),
			["<C-e>"] = cfg_custom(action.tmux.focus_up, no_remap, silent, "focus up (vim/tmux)"),
			["<C-o>"] = cfg_custom(action.tmux.focus_right, no_remap, silent, "focus right (vim/tmux)"),
		},
	},
	plugin_textobject = {
		n = {
			s = cfg_basic(action.text_object.seek_forward, "seek textobject forward"),
			S = cfg_basic(action.text_object.seek_reverse, "seek textobject reverse")
		},
		x = {
			s = cfg_basic(action.text_object.seek_forward, "seek textobject forward"),
			S = cfg_basic(action.text_object.seek_reverse, "seek textobject reverse")
		},
		o = {
			s = cfg_basic(action.text_object.seek_forward, "seek textobject forward"),
			S = cfg_basic(action.text_object.seek_reverse, "seek textobject reverse")
		},
	},
	plugin_luasnip = {
		i = {
			["<C-Right>"] = cfg_basic(action.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = cfg_basic(action.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = cfg_basic(action.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = cfg_basic(action.luasnip.jump_reverse, "luasnip jump prev"),
		},
		s = {
			["<C-Right>"] = cfg_basic(action.luasnip.jump_forward, "luasnip jump next"),
			["<C-Left>"] = cfg_basic(action.luasnip.jump_reverse, "luasnip jump prev"),
			["<C-l>"] = cfg_basic(action.luasnip.jump_forward, "luasnip jump next"),
			["<C-k>"] = cfg_basic(action.luasnip.jump_reverse, "luasnip jump prev"),
		},
	},
	plugin_telescope_lsp_leader = {
		m = {
			-- telescope lsp
			["<leader>l?"] = cfg_basic(action.telescope.diagnostics, "[L]sp Diagnostics"),
			["<leader>lc"] = cfg_basic(action.telescope.lsp_incoming_calls, "[L]sp Incoming [C]alls"),
			["<leader>lC"] = cfg_basic(action.telescope.lsp_outgoing_calls, "[L]sp Outgoing [C]alls"),
			["<leader>li"] = cfg_basic(action.telescope.lsp_implementations, "[L]sp Goto [I]mplementation"),
			["<leader>lR"] = cfg_basic(action.telescope.lsp_references, "[L]sp [R]eferences"),
			["<leader>ls"] = cfg_basic(action.telescope.lsp_document_symbols, "[L]sp Document [S]ymbols"),
			["<leader>lS"] = cfg_basic(action.telescope.lsp_workspace_symbols, "[L]sp Workspace [S]ymbols"),
			["<leader>l$"] = cfg_basic(action.telescope.lsp_dynamic_workspace_symbols, "[L]sp Dynamic Workspace [S]ymbols"),
			["<leader>lt"] = cfg_basic(action.telescope.lsp_type_definitions, "[L]sp [T]ypes"),
		}
	},
	plugin_telescope_jump_easy = {
		m = {
			j = cfg_basic(action.telescope.find_files, "jump files"),
			J = cfg_basic(action.telescope.live_grep, "jump files"),
		}
	},
	plugin_telescope_paste_easy = {
		m = {
			["<C-p>"] = cfg_basic(action.telescope.registers, "Telescope Registers [P]aste"),
		}
	},
	plugin_telescope_leader = {
		m = {
			["<leader>/"] = cfg_basic(action.telescope.buffer_fuzzy_search, "buffer fuzzy find"),
			["<leader>tb"] = cfg_basic(action.telescope.buffers, "[T]elescope [B]uffers"),
			["<leader>to"] = cfg_basic(action.telescope.oldfiles, "[T]elescope [O]ldfiles"),
			["<leader>tq"] = cfg_basic(action.telescope.quickfix, "[T]elescope [Q]uickfix"),
			["<leader>tl"] = cfg_basic(action.telescope.loclist, "[T]elescope [L]oclist"),
			["<leader>tj"] = cfg_basic(action.telescope.loclist, "[T]elescope [J]umplist"),
			["<leader>tm"] = cfg_basic(action.telescope.man_pages, "[T]elescope [M]an pages"),
			["<leader>th"] = cfg_basic(action.telescope.help_tags, "[T]elescope [H]elp Tags"),
			["<leader>tt"] = cfg_basic(action.telescope.man_pages, "[T]elescope [T]ags"),
			["<leader>tc"] = cfg_basic(action.telescope.commands, "[T]elescope [C]ommands"),
			["<leader>tk"] = cfg_basic(action.telescope.keymaps, "[T]elescope [K]eymaps"),
			["<leader>tp"] = cfg_basic(action.telescope.registers, "[T]elescope [P]aste"),
			["<leader>tr"] = cfg_basic(action.telescope.resume, "[T]elescope [R]epeat"),
		}
	},
}

local map_config = function(config, skip_list)
	for mode, mode_cfg in pairs(config) do
		if mode == "m" then
			mode = ""
		end
		for key, key_cfg in pairs(mode_cfg) do
			if util.should_map(key, skip_list) then
				vim.keymap.set(mode, key, key_cfg.value, {
					desc = key_cfg.desc,
					silent = key_cfg.is_silent,
					remap = key_cfg.is_remap,
					noremap = not key_cfg.is_remap,
					expr = key_cfg.is_expr,
				})
			end
		end
	end
end

local setup_force = function(config)
	if config == nil then
		config = {}
	end

	local context = {
		booster   = {
			quit_easy                   = true,
			scroll_easy                 = true,
			swap_easy                   = true,
			incrament_easy              = true,
			hlsearch_easy               = true,
			lsp_easy                    = true,
			lsp_leader                  = true,
			diagnostic_easy             = true,
			diagnostic_leader           = true,
			plugin_navigator            = false,
			plugin_comment              = false,
			plugin_luasnip              = false,
			plugin_textobject           = false,
			plugin_telescope_leader     = false,
			plugin_telescope_lsp_leader = false,
			plugin_telescope_jump_easy  = false,
			plugin_telescope_paste_easy = false,
			experimental_seek           = false,
		},
		skip_list = {},
	}

	if config then
		context = vim.tbl_extend("force", context, config)
	end

	state.config = context

	if config.easy_source then
		-- disable neovim from auto loading matchit
		vim.g.loaded_matchit = true
	end

	map_config(mapping.general, context.skip_list)

	for booster, is_enabled in pairs(context.booster) do
		if is_enabled then
			map_config(mapping[booster], context.skip_list)
		end
	end
end

---  configure and map unruly worker keymap
--- @param config table
local function setup(config)
	-- dont reload if  loaded
	if vim.g.unruly_worker then
		return
	end
	vim.g.unruly_worker = true
	setup_force(config)

	-- TODO create a nice way to create autocmds
	-- add the TextYankPost autocmd

	-- TODO create a better config for creating userc comands
	-- UnrulyKopyRegisterReset
	-- UnrulyKopyRegisterSelect
	-- UnrulyKopyHistoryPaste
	-- UnrulyRegisterTransformPaste
	-- UnrulyRegisterTransformYank
	-- UnrulyMacroRegisterSelect
	-- UnrulyMacroLock
	-- UnrulyMacroUnlock
	-- UnrulyMarkClear
	vim.api.nvim_create_user_command("UnrulyMacroLock", action.macro.lock, {})
	vim.api.nvim_create_user_command("UnrulyMacroUnlock", action.macro.unlock, {})

	util.notify("UNRULY")
end


local function get_status_text()
	local seek_status_text = ""
	if state.config ~= nil then
		if state.config.booster.experimental_seek then
			seek_status_text = " " .. action.seek.get_status_text()
		end
	end
	return action.mark.get_status_text()
			.. " " .. action.macro.get_status_text()
			.. " " .. action.kopy.get_status_text()
			.. seek_status_text
end

return {
	setup = setup,
	action = action,
	get_status_text = get_status_text,
}
