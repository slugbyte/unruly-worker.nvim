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

-- NOTE: for some reason vim.api.nvim_set_keymap keeps creating keymap recursion
-- errors and switching to vim.cmd('<mapper> ...') fixed this issue

local nmap = function(lhs, rhs)
  vim.cmd('nnoremap ' .. lhs .. ' ' .. rhs)
end

local imap = function(lhs, rhs)
  vim.cmd('inoremap ' .. lhs .. ' ' .. rhs)
end

local cmap = function(lhs, rhs)
  vim.cmd('cnoremap ' .. lhs .. ' ' .. rhs)
end

local vmap = function(lhs, rhs)
  vim.cmd('vnoremap ' .. lhs .. ' ' .. rhs)
end

local map = function(lhs, rhs)
  vim.cmd('noremap ' .. lhs .. ' ' .. rhs)
end

local disable = function(lhs)
  vim.api.nvim_set_keymap('', lhs, '\\', {noremap = true})
end

local disable_keyboard = function()
  for i = 33,126,1 do
    pcall(disable, string.char(i))
  end
end

local map_undisputed = function()
  map('a', 'a')
  map('A', 'A')
  map('b', '%')
  map('c', 'c')
  map('C', 'C')
  map('d', 'd')
  map('D', 'D')
  map('e', 'k')
  map('E', 'e')
  map('f', 'n')
  map('F', 'N')
  map('g', 'g')
  map('G', 'G')
  map('h', ';')
  map('H', ',')
  map('i', 'i')
  map('I', 'I')
  map('j', '"')
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
  map('z', 'z')
  map('Z', 'Z')
  map(':', ':')
  map(',', '.')
  map('.', '&')
  map('@', 'zt')
  map('$', 'zz')
  map('#', 'zb')
  nmap('<C-Down>', '<cmd>m .+1<CR>==')
  nmap('<C-Up>', '<cmd>m .-2<CR>==')
  imap('<C-Down>', '<cmd>m .+1<CR>==gi')
  imap('<C-Up>', '<cmd>m .-2<CR>==gi')
  vmap('<C-Up>', "<cmd>m '>+1<CR>gv=gv")
  vmap('<C-Down>', "<cmd>m '>-2<CR>gv=gv")
  cmap('<C-a>', '<home>')
  cmap('<C-e>', '<end>')
end

local map_lsp = function(enable)
  if enable then
    map('-', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    map('_', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    map('&', '<cmd>lua vim.lsp.buf.formatting()<cr>')
    map(';', '<cmd>split<cr><cmd>lua vim.lsp.buf.definition()<cr>')
    map('=', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('!', '<cmd>lua vim.lsp.buf.rename()<cr>')
  end
end

local map_comment = function(enable)
  if enable then
    map('c', 'gcc')
    map('C', 'gcip')
    vmap('c', 'gc')
    vmap('C', 'gc')
  end
end

local map_select = function(enable)
  if enable then
    map('s', 'viw')
    map('S', 'vip')
  end
end

local map_visual_navigate = function(enable)
  if enable then
    map('e', 'gk')
    map('n', 'gj')
  else
    map('ge', 'gk')
    map('gn', 'gj')
  end
end

local map_wrap_navigate = function(enable)
  if enable then
    vim.cmd('set ww+=<,>')
    map('y', '<left>')
    map('o', '<right>')
  end
end

local map_quote_command = function(enable)
  if enable then
    map("'", ':')
  end
end

local function setup(config)
  local context = {
    enable_select_map = false,
    enable_comment_map = false,
    enable_lsp_map = false,
    enable_visual_navigate = false,
    enable_wrap_navigate = false,
    enable_quote_command = false,
  }

  if (config)then
    context = vim.tbl_extend("force", context, config)
  end

  disable_keyboard()
  map_undisputed()
  map_lsp(context.enable_lsp_map)
  map_select(context.enable_select_map)
  map_comment(context.enable_comment_map)
  map_wrap_navigate(context.enable_wrap_navigate)
  map_visual_navigate(context.enable_visual_navigate)
  map_quote_command(context.enable_quote_command)
end

return {
  setup = setup,
}
