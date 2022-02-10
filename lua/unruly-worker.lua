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

--- create a key mapper that does nothing when trying
--- to map something to itself
--- @param mode string
--- @param noremap boolean 
local create_map = function(mode, noremap)
  --- a mapper that (mode, noremap)
  -- @param lhs string
  -- @param rhs string
  return function(lhs, rhs)
    if lhs == rhs then
     return
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap = noremap})
  end
end

-- noremap
local map = create_map('', true)
local nmap = create_map('n', true)
local imap = create_map('i', true)
local cmap = create_map('c', true)
local vmap = create_map('v', true)

-- remap
local remap_vmap = create_map('v', false)
local remap_map = create_map('', false)

local map_undisputed = function()
  map('a', 'a')
  map('A', 'A')
  map('b', '%')
  map('B', '"')
  map('c', 'c')
  map('C', 'C')
  map('d', 'd')
  map('D', 'D')
  map('e', 'k')
  map('E', 'e')
  map('<C-w>e', '<C-w>k')
  map('f', 'n')
  map('F', 'N')
  map('g', 'g')
  map('G', 'G')
  map('h', ';')
  map('H', ',')
  map('i', 'i')
  map('I', 'I')
  map('j', '\\')
  map('J', '\\')
  map('k', 'y')
  map('K', 'Y')
  map('l', 'o')
  map('L', 'O')
  map('m', "'")
  map('M', 'm')
  map('n', 'j')
  map('N', 'J')
  map('o', 'l')
  map('O', '$')
  map('<C-w>o', '<C-w>l')
  map('<C-w>n', '<C-w>j')
  map('p', 'p')
  map('P', 'P')
  map('q', 'q')
  map('Q', '@')
  map('r', 'r')
  map('R', 'R')
  map('s', 's')
  map('S', 'S')
  map('t', 'f')
  map('T', 'F')
  map('u', 'u')
  map('U', '<c-r>')
  map('v', 'v')
  map('V', 'V')
  map('w', 'w')
  map('W', 'b')
  map('x', 'x')
  map('X', 'X')
  map('y', 'h')
  map('Y', '^')
  map('<C-w>y', '<C-w>h')
  map('z', 'z')
  map('Z', 'Z')
  map(':', ':')
  map("'", '\\')
  map('"', '\\')
  map('`', '\\')
  map(',', '.')
  map('.', '&')
  map('/', '/')
  map('?', '?')
  map('@', 'zt')
  map('#', 'zz')
  map('$', 'zb')
  map('~', '~')
  map('%', '\\')
  map('^', '\\')
  map('&', '\\')
  map('*', '\\')
  map('-', '\\')
  map('_', '\\')
  map('+', '\\')
  map('=', '\\')
  map('|', '\\')
  map(';', '\\')
  map('(', '(')
  map(')', ')')
  map('[', '[')
  map(']', ']')
  map('>', '>')
  map('<', '<')
  nmap('<C-Down>', ':m .+1<CR>==')
  nmap('<C-Up>', ':m .-2<CR>==')
  imap('<C-Down>', ':m .+1<CR>==gi')
  imap('<C-Up>', ':m .-2<CR>==gi')
  vmap('<C-Down>', ":m '>+1<CR>gv=gv")
  vmap('<C-Up>', ":m '<-2<CR>gv=gv")
  cmap('<C-a>', '<home>')
  cmap('<C-e>', '<end>')
  map('ge', 'gk')
  map('gn', 'gj')
end

--- add lsp specific mappings if enable is true
--- @param enable boolean
local map_lsp = function(enable)
  if enable then
    map('-', ':lua vim.diagnostic.goto_prev()<CR>')
    map('_', ':lua vim.diagnostic.goto_next()<CR>')
    map(';', ':lua vim.lsp.buf.hover()<CR>')

    map('<c-f>', ':lua vim.lsp.buf.formatting()<CR>')
    map('<c-a>', ':lua vim.lsp.buf.code_action()<CR>')
    map('<c-r>', ':lua vim.lsp.buf.rename()<CR>')
    map('<c-d>', ':split<CR>:lua vim.lsp.buf.definition()<CR>')
  end
end

--- c will toggle comment if enable is true
--- @param enable boolean
local map_comment = function(enable)
  if enable then
    remap_map('c', 'gcc')
    remap_map('C', 'gcip')
    remap_vmap('c', 'gc')
    remap_vmap('C', 'gc')
  end
end

--- s will visual select if enable is true
--- @param enable boolean
local map_select = function(enable)
  if enable then
    map('s', 'viw')
    map('S', 'vip')
  end
end

--- e and n will navigate visualy if enable is true
--- @param enable boolean
local map_visual_navigate = function(enable)
  if enable then
    map('e', 'gk')
    map('n', 'gj')
  end
end

--- y and o will wrap lines if enable is true
--- @param enable boolean
local map_wrap_navigate = function(enable)
  if enable then
    vim.cmd('set ww+=<,>')
    map('y', '<left>')
    map('o', '<right>')
  end
end

--- ' is equivalent to : if enable is true
--- @param enable boolean
local map_quote_command = function(enable)
  if enable then
    map("'", ':')
  end
end

--- (@,$,#) -> (top, middle, bottom) if enable is true
--- @param enable boolean
local map_alt_jump_scroll = function(enable)
  if enable then
    map("@", 'zt')
    map("$", 'zz')
    map("#", 'zb')
  end
end

--- <C-(y,n,e,o)> nave windows if enable is true
--- @param enable boolean
local map_easy_window_navigate = function(enable)
  if enable then
    map('<c-n>', '<c-w>j')
    map('<c-e>', '<c-w>k')
    map('<c-y>', '<c-w>h')
    map('<c-o>', '<c-w>l')
  end
end

--- configure and map unruly worker keymap
--- @param config table
local function setup(config)
  if vim.g.unruly_worker then
    return
  end
  vim.g.unruly_worker = true

  local context = {
    enable_lsp_map = true,
    enable_select_map = true,
    enable_quote_command = true,
    enable_easy_window_navigate = true,
    enable_comment_map = false,
    enable_wrap_navigate = false,
    enable_visual_navigate = false,
    enable_alt_jump_scroll = false,
  }

  if config then
    context = vim.tbl_extend("force", context, config)
  end

  vim.g.unruly_worker_context = context

  map_undisputed()
  map_lsp(context.enable_lsp_map)
  map_select(context.enable_select_map)
  map_comment(context.enable_comment_map)
  map_wrap_navigate(context.enable_wrap_navigate)
  map_quote_command(context.enable_quote_command)
  map_alt_jump_scroll(context.enable_alt_jump_scroll)
  map_visual_navigate(context.enable_visual_navigate)
  map_easy_window_navigate(context.enable_easy_window_navigate)
end

return {
  setup = setup,
}
