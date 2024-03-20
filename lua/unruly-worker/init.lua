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

--- create a key mapper that does nothing when trying
--- to map something to itself
--- @param mode string
--- @param noremap boolean
local create_map = function(mode, noremap)
	-- @param lhs string
	-- @param rhs string
	-- @param desc sring
	return function(lhs, rhs, desc, silent)
		if silent == nil then
			silent = false
		end

		if lhs == rhs then
			vim.keymap.set(mode, lhs, "\\")
			vim.keymap.set(mode, lhs, rhs, { noremap = noremap, desc = desc, silent = silent })
			return
		end
		vim.keymap.set(mode, lhs, rhs, { noremap = noremap, desc = desc, silent = silent })
	end
end

-- noremap
local map = create_map("", true)
local nmap = create_map("n", true)
local imap = create_map("i", true)
local cmap = create_map("c", true)
local vmap = create_map("v", true)

-- remap
local remap_vmap = create_map("v", true)
local remap_map = create_map("", true)

-- actions

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
			e = cfg_basic("gk", "up"),
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
			n = cfg_basic("gj", "down"),
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
			s = cfg_basic("s", "substitue"),
			S = cfg_basic("S", "substitue line"),
			t = cfg_basic("f", "to char"),
			T = cfg_basic("F", "to char reverse"),
			u = cfg_basic("u", "undo"),
			U = cfg_basic("<C-r>", "redo"),
			v = cfg_basic("v", "visual mode"),
			V = cfg_basic("V", "visual line mode"),
			w = cfg_basic("w", "word forward"),
			W = cfg_basic("b", "word backward"),
			x = cfg_basic("x", "delete char"),
			X = cfg_basic("X", "delete previous char"),
			y = cfg_basic("h", "left"),
			Y = cfg_basic("^", "left to BOL"),
			z = cfg_basic("'azt", "zip to mark a"),
			Z = cfg_basic("'bzt", "zip to mark b"),

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
			["<C-m>"] = cfg_basic("qq", "macro record"),
			["<C-p>"] = cfg_basic("@q", "macro play"),

			-- comment
			["<C-c>"] = cfg_basic("gcc", "comment"),
			["<C-/>"] = cfg_basic("gcc", "comment"),

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
}

local map_undisputed = function()
	for mode, mode_cfg in pairs(mapping.general) do
		if mode == "m" then
			mode = ""
		end
		for key, key_cfg in pairs(mode_cfg) do
			vim.print("unruly mapping:", mode, key, key_cfg.value, key_cfg.desc)
			vim.keymap.set(mode, key, key_cfg.value, {
				desc = key_cfg.desc,
				silent = key_cfg.is_silent,
				remap = key_cfg.is_remap,
			})
		end
	end
end

--- add lsp specific mappings if enable is true
--- @param enable boolean
local map_lsp = function(enable)
	if enable then
		map("-", ":lua vim.diagnostic.goto_prev()<CR>", "prev diagnostic")
		map("_", ":lua vim.diagnostic.goto_next()<CR>", "next diagnostic")
		map(";", ":lua vim.lsp.buf.hover()<CR>", "lsp hover")
		map("<c-r>", ":lua vim.lsp.buf.rename()<CR>", "lsp rename")
		map("<c-d>", ":split<CR>:lua vim.lsp.buf.definition()<CR>", "lsp definition")
	end
end

--- c will toggle comment if enable is true
--- @param enable boolean
local map_comment = function(enable)
	if enable then
		vim.cmd(":map c gcc")
		vim.cmd(":map C gcip")
		vim.cmd(":vmap c gc")
		vim.cmd(":vmap C gc")

		-- remap_map("<c-h>", "gcc", "comment")
		-- vim.keymap.set("", "c", "", { desc = "comment toggle line", noremap = false })
		-- vim.keymap.set("v", "<c-h>", "gc", { desc = "comment toggle visual" })
		-- vim.keymap.set("", "C", "gcip", { desc = "comment toggle paragraph" }) vim.keymap.set("v", "C", "gc", { desc = "comment toggle visual" })
	end
end

--- s will visual select if enable is true
--- @param enable boolean
local map_select = function(enable)
	if enable then
		map("s", "viw", "select word")
		map("S", "vip", "select paragraph")
	end
end

--- e and n will navigate visualy if enable is true
--- @param enable boolean
local map_visual_navigate = function(enable)
	if enable then
		map("e", "gk", "up column")
		map("n", "gj", "down column")
	end
end

--- y and o will wrap lines if enable is true
--- @param enable boolean
local map_wrap_navigate = function(enable)
	if enable then
		vim.cmd("set ww+=<,>")
		map("y", "<left>", "y wrap left")
		map("o", "<right>", "o wrap right")
	end
end

--- ' is equivalent to : if enable is true
--- @param enable boolean
local map_quote_command = function(enable)
	if enable then
		map("'", ":", "command mode")
	end
end

--- <C-(y,n,e,o)> nave windows if enable is true
--- @param enable boolean
local map_easy_window = function(enable)
	if enable then
		map("<c-n>", "<c-w>j", "focus down")
		map("<c-e>", "<c-w>k", "focus up")
		map("<c-y>", "<c-w>h", "focus left")
		map("<c-o>", "<c-w>l", "focus right")
	end
end

local map_easy_tmux = function(enable)
	if (enable) then
		vim.keymap.set('n', '<C-n>', ":TmuxNavigateDown<CR>", { silent = true, desc = "focus down (vim/tmux)" })
		vim.keymap.set('n', '<C-e>', ":TmuxNavigateUp<CR>", { silent = true, desc = "focus up (vim/tmux)" })
		vim.keymap.set('n', '<C-o>', ":TmuxNavigateRight<CR>", { silent = true, desc = "focus right (vim/tmux)" })
		vim.keymap.set('n', '<C-y>', ":TmuxNavigateLeft<CR>", { silent = true, desc = "focus left (vim/tmux)" })
	end
end

local map_easy_mark = function(enable)
	if enable then
		map("m", "ma", "mark a")
		map("M", "mb", "mark b")
		map("z", "'azt", "jump a")
		map("Z", "'bzt", "jump b")
	end
end

local map_easy_macro = function(enable)
	if enable then
		map("<c-m>", "qz", "record macro")
		map("<c-z>", "@z", "play macro")
		vim.keymap.del("n", "<c-z>")
	end
end

local map_easy_source = function(enable)
	if enable then
		-- vim.keymap.del("n", "%")
		map("%", ":source %<cr>", "source % file", true)
	end
end

local map_easy_jump = function(enable)
	if enable then
		local status, telescope = pcall(require, "telescope")
		if (status and telescope ~= nil) then
			vim.keymap.set('', 'j', ":Telescope find_files<CR>", { noremap = true, desc = "jump file" })
			vim.keymap.set('', 'J', ":Telescope live_grep<CR>", { noremap = true, desc = "jump grep" })
		end
	end
end

local load_unruly = function(config)
	local context = {
		enable_lsp_map = true,
		enable_select_map = true,
		enable_quote_command = true,
		enable_easy_window_navigate = false,
		enable_easy_window_navigate_tmux = true,
		enable_comment_map = true,
		enable_wrap_navigate = true,
		enable_visual_navigate = true,
		enable_double_jump = true,
		enable_easy_macro = true,
		enable_easy_source = true,
		enable_easy_jump = true,
	}

	if config then
		context = vim.tbl_extend("force", context, config)
	end

	map_undisputed()
	map_lsp(context.enable_lsp_map)
	map_select(context.enable_select_map)
	map_comment(context.enable_comment_map)
	map_wrap_navigate(context.enable_wrap_navigate)
	map_quote_command(context.enable_quote_command)
	map_visual_navigate(context.enable_visual_navigate)
	map_easy_window(context.enable_easy_window_navigate)
	map_easy_tmux(context.enable_easy_window_navigate_tmux)
	map_easy_mark(context.enable_double_jump)
	map_easy_macro(context.enable_easy_macro)
	map_easy_source(context.enable_easy_source)
	map_easy_jump(context.enable_easy_jump)
end

---  configure and map unruly worker keymap
--- @param config table
local function setup(config)
	-- dont reload if  loaded
	if vim.g.unruly_worker then
		return
	end
	vim.g.unruly_worker = true

	load_unruly(config)
end

return {
	-- TODO: HOW TO BLACKLIST MAPS IN SETUP
	setup = setup,
	external = external,
	setup_force = load_unruly,
	util = util,
}
