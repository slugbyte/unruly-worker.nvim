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
--  TODO: add cmp.insert and cmd presets
--  TODO: add lsp leader commands
--  TODO: add treesitter search commands

local util = require("unruly-worker.util")
local external = require("unruly-worker.external")
local telescope_status, telescope_builtin = pcall(require, "telescope.builtin")

local no_remap = false
local remap = true

local silent = true
local no_silent = false

local function cfg_custom(value, is_remap, is_silent, desc)
	return {
		value = value,
		is_remap = is_remap,
		is_silent = is_silent,
		desc = desc,
	}
end

local function cfg_basic(cmd, desc)
	return cfg_custom(cmd, no_remap, no_silent, desc)
end

local function cfg_noop()
	return cfg_basic("\\", "")
end

local mapping = {
	general = {
		m = {
			-- alphabet
			a = cfg_basic("a", "append cursor"),
			A = cfg_basic("A", "append line"),
			b = cfg_basic("%", "brace match"),
			B = cfg_basic('"', "select register"),
			c = cfg_basic("c", "delete and insert"),
			C = cfg_basic("C", "delete and insert to EOL"),
			d = cfg_basic("d", "delete motion"),
			D = cfg_basic("D", "delete to EOL"),
			e = cfg_basic("k", "up"),
			E = cfg_basic("e", "end of word"),
			f = cfg_basic("n", "find next"),
			F = cfg_basic("N", "find prev"),
			g = cfg_basic("g", "g command"),
			G = cfg_basic("G", "goto line"),
			h = cfg_basic(";", "hop to repeat"),
			H = cfg_basic(",", "hop to reverse"),
			i = cfg_basic("i", "insert"),
			I = cfg_basic("I", "insert BOL"),
			j = cfg_noop(),
			J = cfg_noop(),
			k = cfg_basic("y", "kopy"),
			K = cfg_basic("Y", "kopy line"),
			l = cfg_basic("o", "line insert below"),
			L = cfg_basic("O", "line insert above"),
			m = cfg_basic("ma", "mark a"),
			M = cfg_basic("mb", "mark b"),
			n = cfg_basic("j", "down"),
			N = cfg_basic("J", "join lines"),
			o = cfg_basic("l", "right"),
			O = cfg_basic("$", "right to EOL"),
			p = cfg_basic("p", "paste after"),
			P = cfg_basic("P", "paste before"),
			q = cfg_basic(util.write_all, "write all"),
			Q = cfg_basic(":qall<cr>", "quit all"),
			["<C-q>"] = cfg_basic(":qall!<cr>", "quit all force"),
			r = cfg_basic("r", "replace"),
			R = cfg_basic("R", "replace mode"),
			s = cfg_noop(),
			S = cfg_noop(),
			["<C-s>"] = cfg_basic("vip", "select paragraph"),
			t = cfg_basic("f", "to char"),
			T = cfg_basic("F", "to char reverse"),
			u = cfg_basic("u", "undo"),
			U = cfg_basic("<C-r>", "redo"),
			v = cfg_basic("v", "visual mode"),
			V = cfg_basic("V", "visual line mode"),
			w = cfg_basic("w", "word forward"),
			W = cfg_basic("b", "word backward"),
			x = cfg_basic("s", "delete char"),
			X = cfg_basic("S", "delete previous char"),
			y = cfg_basic("h", "left"),
			Y = cfg_basic("^", "left to BOL"),
			z = cfg_basic("'azz", "zip to mark a"),
			Z = cfg_basic("'bzz", "zip to mark b"),

			-- parens
			[")"] = cfg_basic(")", "next sentence"),
			["("] = cfg_basic("(", "prev sentence"),

			["}"] = cfg_basic("}", "next paragraph"),
			["{"] = cfg_basic("{", "prev paragraph"),

			["]"] = cfg_basic("]", "square bracket command"),
			["["] = cfg_basic("[", "square bracket command"),

			["<"] = cfg_basic("<", "nudge left"),
			[">"] = cfg_basic(">", "nudge right"),

			-- case swap
			["~"] = cfg_basic("~", "case swap"),

			-- command
			[":"] = cfg_basic(":", "command mode"),
			["'"] = cfg_basic(":", "command mode"),
			["/"] = cfg_basic("/", "search down"),
			["?"] = cfg_basic("?", "search up"),

			-- repeat
			-- TODO: should "." just be repeat text object move?
			["."] = cfg_basic('&', "repeat substitue"),
			[","] = cfg_basic(',', "repeat search t/f"),

			-- register
			['"'] = cfg_basic('"', "register select"),
			["`"] = cfg_basic(util.register_peek, "register_peek"),

			-- window nav
			["<C-w>y"] = cfg_basic("<C-w>h", "focus left"),
			["<C-w>n"] = cfg_basic("<C-w>j", "focus down"),
			["<C-w>e"] = cfg_basic("<C-w>k", "focus up"),
			["<C-w>o"] = cfg_basic("<C-w>l", "focus right"),
			["<C-w>h"] = cfg_noop(),
			["<C-w>j"] = cfg_noop(),
			["<C-w>k"] = cfg_noop(),
			["<C-w>l"] = cfg_noop(),

			-- cursor align
			["@"] = cfg_basic("zt", "align top"),
			["$"] = cfg_basic("zz", "align middle"),
			["#"] = cfg_basic("zb", "align bottom"),

			-- macro
			["<C-m>"] = cfg_basic("q0", "macro record"),
			["<C-p>"] = cfg_basic("@0", "macro play"),

			-- noop
			["%"] = cfg_noop(),
			["^"] = cfg_noop(),
			["&"] = cfg_noop(),
			["*"] = cfg_noop(),
			["-"] = cfg_noop(),
			["_"] = cfg_noop(),
			["+"] = cfg_noop(),
			["="] = cfg_noop(),
			["|"] = cfg_noop(),
			[";"] = cfg_noop(),
		},
		n = {
			-- swap lines normal
			["<C-Down>"] = cfg_basic(":m .+1<CR>==", "swap down"),
			["<C-Up>"] = cfg_basic(":m .-2<CR>==", "swap up"),
		},
		i = {
			-- swap lines insert
			["<C-Down>"] = cfg_basic(":m .+1<CR>==gi", "swap down"),
			["<C-Up>"] = cfg_basic(":m .-2<CR>==gi", "swap up"),
		},
		v = {
			-- swap lines visual
			["<C-Down>"] = cfg_basic(":m '>+1<CR>gv=gv", "swap down"),
			["<C-Up>"] = cfg_basic(":m '<-2<CR>gv=gv", "swap up"),
		},
		c = {
			["<C-a>"] = cfg_basic("<home>", "goto BOL"),
			["<C-e>"] = cfg_basic("<end>", "goto EOL"),
		},
	},
	easy_comment = {
		n = {
			["<C-c>"] = cfg_custom("gcc", remap, no_silent, "comment"),
			["<C-/>"] = cfg_custom("gcc", remap, no_silent, "comment"),
		},
		v = {
			["<C-c>"] = cfg_custom("gc", remap, no_silent, "comment"),
			["<C-/>"] = cfg_custom("gc", remap, no_silent, "comment"),
		},
		i = {
			["<C-c>"] = cfg_custom("gcc", remap, no_silent, "comment"),
			["<C-/>"] = cfg_custom("gcc", remap, no_silent, "comment"),
		},
	},
	easy_lsp = {
		m = {
			["_"] = cfg_basic(vim.diagnostic.goto_next, "diagnostic next"),
			["-"] = cfg_basic(vim.diagnostic.goto_prev, "diagnostic prev"),
			[";"] = cfg_basic(vim.lsp.buf.hover, "lsp hover"),
			["<C-r>"] = cfg_basic(vim.lsp.buf.rename, "lsp rename"),
			["<C-d>"] = cfg_basic(function()
				if telescope_status and (telescope_builtin ~= nil) then
					telescope_builtin.lsp_definitions()
				else
					vim.lsp.buf.definition()
				end
			end, "lsp rename"),
		},
	},
	easy_move = {
		m = {
			e = cfg_basic("gk", "up"),
			n = cfg_basic("gj", "down"),
		},
	},
	easy_tmux = {
		m = {
			["<C-y>"] = cfg_custom(":TmuxNavigateLeft<CR>", no_remap, silent, "focus left (vim/tmux)"),
			["<C-n>"] = cfg_custom(":TmuxNavigateDown<CR>", no_remap, silent, "focus down (vim/tmux)"),
			["<C-e>"] = cfg_custom(":TmuxNavigateUp<CR>", no_remap, silent, "focus up (vim/tmux)"),
			["<C-o>"] = cfg_custom(":TmuxNavigateRight<CR>", no_remap, silent, "focus right (vim/tmux)"),
		},
	},
	easy_source = {
		m = {
			["%"] = cfg_custom(":source %<CR>", no_remap, silent, "source current buffer"),
		},
	},
	easy_jump = {
		m = {
			j = cfg_basic(function()
				if telescope_status and (telescope_builtin ~= nil) then
					telescope_builtin.find_files()
					return
				end
				print("UNRULY ERROR: telescope not found")
			end, "jump files"),
			J = cfg_basic(function()
				if telescope_status and (telescope_builtin ~= nil) then
					telescope_builtin.live_grep()
					return
				end
				print("UNRULY ERROR: telescope not found")
			end, "jump files"),
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
			easy_lsp     = true,
			easy_move    = true,
			easy_tmux    = true,
			easy_comment = true,
			easy_source  = true,
			easy_jump    = true,
		},
		skip_list = {},
	}

	if config then
		context = vim.tbl_extend("force", context, config)
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
end

return {
	setup = setup,
	external = external,
	setup_force = setup_force,
	util = util,
}
