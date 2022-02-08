# unruly worker
> a semantic key map for vim designed for the workman keyboard layout

![unruly worker vim layout](/asset/keymap.png)
![unruly worker vim ctrl key action legend](/asset/action.png)

## Dependencies
* nvim > 0.5 (for LSP key maps)
* (optional) a comment plugin that supports `gcc` and `gcip` 
  * [Comment.nvim](https://github.com/numToStr/Comment.nvim)
  * [commentary.vim](https://github.com/tpope/vim-commentary)

## INSTALL AND SETUP
1. Install with your favorite [nvim](https://neovim.io/) [package manager](https://github.com/savq/paq-nvim)
2. Add the following **lua** code to your vim config

``` lua
-- Use this setup config if you want to follow the keymap above
local unruly_worker = require('unruly-worker')
unruly_worker.setup({
  enable_lsp_map = true,
  enable_select_map = true,
  enable_comment_map = true,
  enable_wrap_navigate = true,
  enable_visual_navigate = true,
  enable_easy_window_navigate = true,
  enable_quote_command = true,
})
```

## HELP
Type `:help unruly-worker` for documentation that includes mnemonics for each
remap, as well as descriptions about the optional configurations. 

## Features
* Workman Layout philosophy
  * I tried to arrange the most frequently used commands according to the workman
  heat map
  * I tried to arrange the commands on keys in a semantic way so layout is easy to
* Easy to remember using mnemonics
* NVIM builtin LSP support
* Shifting line(s) up and down
* The option for visual Up and Down, and wrapping Left and Right
* 1 Key comment line and comment paragraph
* 1 Key select word and select paragraph

## About
Being dyslexic has taught me its often easier for me to build a system for
myself than it is to learn a system that works well for everyone else. This often
means I end up spending a lot of time reinventing the wheel, but the process of
learning though reinventing has been an invaluable teacher. This plugin is
probably boarder line vim blasphemy, but it has completely revolutionized my 
workflow and relationship with vim.

After using vim as my only editor for more than 5 years I still had trouble 
remembering commands. I was proficient enough for my needs, but my skills plateaued
far short of where I wanted them to be. No matter how many times I played vim golf 
or studied the cheat sheet, I continued to be annoyingly inefficient.

To make matters more complicated, I decided to learn the [workman
layout](https://workmanlayout.org/). This decision forced me to consider how 
to remap a few keys, but one thing lead to another and soon I had created an 
entirely new layout. One that I can remember well enough to experiencing the 
sensation of my mind manipulating text without noticing that my hands, or 
keyboard keys, or even that vim itself has anything to do with it.

Dyslexia may or may not have been what made it so hard for me to learn vim, but
by forcing me to reinvent many wheels throughout my life It has normalized this
process for me. The unruly-worker layout, is a classic example of the type of
outcomes that my somewhat accidental process produces. Something that may not 
be useful for anyone else, but makes something that s useful to many others 
accessible to me.
