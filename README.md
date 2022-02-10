# unruly worker
> a semantic key map for nvim designed for the workman keyboard layout

![unruly worker vim layout](/asset/keymap.png)
![unruly worker vim ctrl key action legend](/asset/action.png)

## DEPENDENCIES
* [nvim](https://neovim.io/) version > 0.5
* (optional) a comment plugin that supports `gcc` and `gcip` 
  * [comment.nvim](https://github.com/numToStr/Comment.nvim)
  * [commentary.vim](https://github.com/tpope/vim-commentary)

## INSTALL AND SETUP
1. Install with your favorite [package manager](https://github.com/savq/paq-nvim)
2. Add the following **lua** code to your vim config

``` lua
-- Use this setup config if you want to follow the keymap above
local unruly_worker = require('unruly-worker')
unruly_worker.setup({
  -- default true
  enable_lsp_map = true,
  enable_select_map = true,
  enable_quote_command = true,
  enable_easy_window_navigate = true,
  -- default false
  enable_comment_map = true, -- requires a comment plugin (see DEPENDENCIES above)
  enable_wrap_navigate = true,
  enable_visual_navigate = true,
})
```

## HELP
Type `:help unruly-worker` for documentation that includes mnemonics for each
remap, as well as descriptions about the optional configurations.

Type `help uw_(some key)` for documentation about the default for a specific key.  
For example `uw_S` will go to documentation for the `S` keymap.  
For example `uw_c-a` will go to documentation for the `<C-a>` keymap.  

## PRO TIPS
* Map `j` to Find by filename with [fzf](https://github.com/junegunn/fzf.vim) or [telescope](https://github.com/nvim-telescope/telescope.nvim)
* Map `J` to Find text in file with [fzf](https://github.com/junegunn/fzf.vim) or [telescope](https://github.com/nvim-telescope/telescope.nvim)
* Visual Map `s` to `<Plug>SurroundAddVisual` with [surround.nvim](https://github.com/blackCauldron7/surround.nvim)
  * a game changer when coupled with `enable_select_map = true`, hit `s` to select then `s` again to surround

## LAYOUT PHILOSOPHY
1. When possible, commands are positioned according to the workman layout heatmap. So frequent use will not strain your hands.
2. When possible, commands are arranged onto a semantic key. This makes it possible for the keymap to be remembered with mnemonic phrases.
3. When possible, keys behavior, or behavior substitute, should stay in the same position as the original-keymap, so that there is no need for experienced vim users to unlearn there years of muscle memory.

## FEATURES
* visual up and down
* wrap left and right
* easy split window navigation
* easy shifting line(s) up and down
* a visual keymap cheat sheet (above)
* 1 key word and paragraph select
* 1 key toggle comment line and toggle comment paragraph
* easy to shift the current line  to the top, middle, or bottom of the view
* the ability to customize features using lua
* nvim LSP key bindings
  * prev/next diagnostic
  * go to definition
  * code-action
  * format
  * rename
  * hover

## ABOUT
Being dyslexic has taught me its often easier for me to build a system for
myself than it is to learn a system that works well for everyone else. This
usually isn't my first approach when trying to learn something new, but when
the struggle is real, I usually decide why not just reinvent the wheel. I
think the process that lead me to create this keymap is a good example of 
how this learning style tends to unfold in my life.

After using vim as my only editor for more than 7 years I continued to have
trouble remembering commands. I was proficient enough for my needs, but my
skills plateaued far short of where I wanted them to be. No matter how many
times I played vim golf or studied the cheat sheet, I never quite felt happy
with my progress.

Unrelated to vim, I decided to learn the [workman layout](https://workmanlayout.org/) 
This decision forced me to consider how to remap a few keys, but one thing lead
to another and eventually I had created an entirely new layout, the
unruly-worker layout. The process of creating this keymap lead to me spending about
a year reading `:help` and scouring the internet for vim config gems. Which
probably seems ridiculous for many people, but for me its just how I've had to
do most things in life. The time feels well spent, because I spent the last decade
writing code and I don't plan to stop for many decades to come. I've been using
this layout for more than A year at the time of writing this plugin. Unlike
my first 7 years I can now remember the keymap well enough to experience the
sensation of manipulating the text without noticing that my hands, or
keyboard keys, or even that vim itself has anything to do with it. For me vim
was all ways the right tool for the job, unruly-worker is just a
[jig](https://en.wikipedia.org/wiki/Jig_%28tool%29) that helps the tool work perfectly for my needs.


Dyslexia may or may not have been what made it so hard for me to learn vim, but
it has normalized the process of reinventing wheels to learn for me. The
unruly-worker layout, is a classic example of the type of outcomes that my
somewhat accidental process produces. A tool that may not be useful for anyone
else, but makes a tool that is useful to many other people accessible to me.

## HELP WANTED
Suggestions, Critique, and Spellcheck are all ways appreciated :)

See the [Contributing Guite](./CONTRIBUTING.md)

## SELF-PROMO
If you like this project star the GitHub repository :)

## LICENSE
[Unlicense](https://unlicense.org/)
