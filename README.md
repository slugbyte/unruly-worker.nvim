# unruly worker
> a semantic key map for vim designed for the workman keyboard layout

![unruly worker vim layout](/asset/layout.png)

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

## Features
* I tried to arrange the most frequently used commands according to the workman
  heat map
* I tried to arrange the commands on keys in a semantic way so layout is easy to
  learn and remember. There Are some exceptions:
    1. `yneo` are used as navigation key
    2. `j` is for registers
    3. `,` and `.` are swapped because of frequency of use
    4. `@,$,#` are used for screen (top,middle,bottom), due to my 40% keyboard
       layout
    5. `'` is an alternative way to start command mode
* `C-ArrowUp` and `C-ArrowDown` will swap lines in normal, visual, and insert
* Easy comment toggling
* LSP key maps
  * code action
  * split window and goto definition
  * prev/next diagnostic
  * rename
* Up (n) and down (e) are visual, instead of line based
* Some behaviors are disable
  * removed `Q` behavior - ex mode
  * removed `!` behavior - external filter
  * removed `*` behavior - next indent
  * removed `-` behavior - prev line
  * removed `+` behavior - next line
  * removed `_` behavior - soft BOL
  * removed `#` behavior - prev indent
  * removed `|` behavior - BOL
  * removed `t and T`  behavior - till (`t and T` now have `f and F`'s behavior)

# Dependencies
* nvim > 0.5 (for lsp key maps)
* a comment plugin that supports `gcc` and `gcip` 
  * [Comment.nvim](https://github.com/numToStr/Comment.nvim)
  * [commentary.vim](https://github.com/tpope/vim-commentary)
