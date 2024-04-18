# unruly worker
> a ridiculously fun workman keyboard layout plugin for neovim

![unruly worker vim layout cheatsheet](./asset/img/cheatsheet.png)

## LAYOUT PHILOSOPHY
1. When possible, commands are positioned according to the workman layout heatmap. So frequent use will not strain your hands.
2. When possible, commands are arranged onto a semantic key. This makes it possible for the keymap to be remembered with mnemonic phrases.
3. When possible, keys behavior, or behavior substitute, should stay in the same position as the original-keymap, so that there is no need for experienced vim users to unlearn there years of muscle memory.

## FEATURES
* Navigate vim like normal
* Register Preselection (Yank, Delete, Macro)
* Yank and Delete History
* A nice way to work with macros
* A nice way to work with marks
* A nice way to work with LSP and Diagnostics
* Quickly save and quit
* Quickly navigate jump list
* Quickly step through quicklist, loclist, arg list, buffers
* Easy Spellcheck
* Status bar text generator functions that reveal unruly state
* Easily Opt-Out of specific unruly mappings
* Plugin Support
  * [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - auto completion
  * [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) -
    fuzzy search with preview
  * [Comment.nvim](https://github.com/numToStr/Comment.nvim) - comment
    toggling
  * [Navigator.nvim](https://github.com/numToStr/Navigator.nvim) -
    tmux/wez-term navigation
  * [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) +
    [nvim-treesitter-textobject](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - syntax navigation
  * [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - powerful snipits

## REGISTER PRESELECTION
With Unruly when you select a register, it stays selected until you change it.
This means you don't select a register for a specific motion, instead you set
the yank or macro register, and then all future yank/paste or record/play
actions will use the selected register until you select a new register. 

## INSTALL AND SETUP
1. Install with your favorite [package manager](https://github.com/folke/lazy.nvim)
2. Add the following **lua** code to your vim config

``` lua
-- Use this setup config if you want to follow the keymap above
local unruly_worker = require('unruly-worker')
unruly_worker.setup({
  -- TODO: show setup
})
```

## HELP
Type `:help unruly-worker` for documentation that includes mnemonics for each
remap, as well as descriptions about the optional configurations.

Type `help uw_(some key)` for documentation about the default for a specific key.  
For example `uw_S` will go to documentation for the `S` keymap.  
For example `uw_c-a` will go to documentation for the `<C-a>` keymap.  

## Auto Completion with `nvim-cmp`

## Telescope Setup `nvim-cmp`
### insert mode
* `<CR>` - select default
* `<C-h>` - select into horizontal split
* `<C-s>` - select into vertical split
* `<Down> or <C-n>` - move selection down
* `<Up> or <C-e>` - move selection up
* `<Tab>` - toggle selection
* `<C-a>` - select all
* `<C-d>` - deselect all
* `<C-q>` - add selected to quickfix list
* `<C-l>` - add selected to quickfix list
* `<C-k>` - telescope which key
* `<PageUp>` - scroll preview up
* `<PageDown>` - scroll preview down

### insert mode
> includes everything in insert mode ^
* `e` move selection up
* `n` move selection down
* `N` move to top of selection list
* `E` move to bottom of selection list
* `a` select all
* `d` deselect all
* `q` add to quickfix list and open
* `q` add to loclist and open


## NAVIGATION
### Buffer Navigation
* `yneo` - are mapped to left, down, up, right
* `Y` - goes to beginning of line
* `O` - goes to end of line
* `gg` - top of file
* `G` - end of file
* `PageUp` - scroll up
* `PageDown` - scroll down
* `Home` - scroll up fast
* `End` - scroll down fast

### Window Navigation
* `<ctrl>` + `yneo` - are mapped to focus pane left, down, up, right
  * if Navigator.nvim is installed this will also work with your terminal
    multiplexer
* `<c-x>` close vim split
* `<c-f>` fullscreen vim split
* `<c-s>` split verticle
* `<c-h>` split horizontal

## Kopy Kut Paste
* Kopy/Paste uses a preselected register. `+` is the default
* Unruly always deletes into register `0`.
* Yank and Delete have separate key maps for pasting
* Yank and Delete use registers 1-9 to track history

### yank and paste from the kopy register
* `k` - yank
* `K` - yank line
* `p` - paste yank below
* `P` - paste yank above
* `"` - select kopy register, `[a-z][A-X] and 0 +`
  * press `<enter>` or `<space>` reset to `+`

#### delete and paste from register 0
* `d` - delete
* `dd` - delete line
* `D` - delete to end of line
* `x` - delete under cursor
* `X` - delete before cursor
* `c` - delete then enter insert mode
* `cc` - delete line then enter insert mode
* `C` - delete to end of line then enter insert mode
* `.` - paste delete below
* `,` - paste delete above

### paste history
* `<C-p>` - paste from any register using telescope
  * registers 1-9 are used to track history of yanks/delete

#### Kopy/Delete Tip
* if you want yank and delete to share the same register set the kopy register
  to `0`

## Macro
Macros use preselected registers, similar to kopy/paste. By default the macro register
is `'z'`.

* `z` - record a macro into the preselected register (default: `'z'`)
* `Z` - play a macro from the preselected register
* `<C-z>` - select the macro register
* `<leader>z` - toggle macro recording lock
  * this is useful if you want to make sure you don't accidentally overwrite
  the current macro register
*  <code>&#96;</code> - pretty print the contents of the macro register
It will display special keys like `<enter>`, `<esc>` or `<c-q>`

Regsiters [0-9] are reserved for the delete register and yank history. [(See Kopy Below)](#Kopy)

## MARKS
The unruly idea behind marks is that you only need two marks, for everything
else just use [telescope](https://github.com/nvim-telescope/telescope.nvim). Unruly marks can be in local buffer mode or global
mode. When in local mode unruly uses marks `a` and `b` to hop within a buffer.
When in global mode unruly uses marks `A` and `B` to hop to marks in any buffer.

* `<leader>a` - set mark a
* `<leader>b` - set mark b
* `<C-a>` - goto mark a
* `<C-b>` - goto mark b
* `m` - toggle between local and global mark mode
* `M` - clear current mark mode marks

## Seek Lists (next, prev, first, last)
Unruly allows you to quickly navigate through currently the quickfix list,
loclist, arg list, and currently open buffers. Seek keymaps only target one
type of list at a time, by default seek target mode will be open buffers.

* `<leader>sr` - seek target  mode rotate (buffer, quickfix, loclist, arg list)
* `<leader>sl` - goto first item in seek list
* `<leader>sf` - goto last item in seek list
* `<leader>n` - goto next seek item
* `<leader>p` - goto prev seek item

## ABOUT
Being dyslexic has taught me its often easier for me to build a system for
myself than it is to learn a system that works well for everyone else. This
usually isn't my first approach when trying to learn something new, but when
the struggle is real, I inevitably decide its time to reinvent the wheel. I
think the creation of this keymap is a good example of how my learning style tends to unfold in my life.

After using vim as my only editor for more than 7 years I continued to have
trouble remembering commands. I was proficient enough for my needs, but my
skills plateaued far short of where I wanted them to be. I tried to improve using numerous different tips I found online, but I never quite felt happy with my progress.

Unrelated to vim, I decided to learn the [workman layout](https://workmanlayout.org/).
This decision forced me to consider how to remap a few keys, but one thing lead
to another and eventually I had created an entirely new layout, the
unruly-worker layout. The process of creating this keymap lead to me spending about
a year reading `:help` and scouring the internet for vim config gems. Which
probably seems ridiculous for many people, but for me its just how I've had to
do most things in life. The time feels well used, because I spent the last decade
writing code and I don't plan to stop for many decades to come. Now I've been using
this layout for more than A year at the time of writing this plugin. Unlike
my first 7 years with vim, I can now remember the keymap well enough to experience the
sensation of manipulating the text without noticing that my hands, or
keyboard keys, or even that vim itself has anything to do with it. For me vim
was always the right tool for the job, unruly-worker is just a
[jig](https://en.wikipedia.org/wiki/Jig_%28tool%29) that makes the tool fit perfectly into my workflow.

Dyslexia may or may not have been what made it so hard for me to learn vim, but
it has normalized the process of reinventing wheels to learn for me. The
unruly-worker layout, is a classic example of the type of outcomes that my
somewhat accidental process produces. A tool that may not be useful for anyone
else, but makes a tool that is useful to many other people accessible to me.

## HELP WANTED
Suggestions, Critique, and Spellcheck are always appreciated :)

See the [Contributing Guite](./CONTRIBUTING.md)

## SELF-PROMO
If you like this project star the GitHub repository :)

## TODO
* create a `:UnrulySchool` command that has an interactive tutorial

## LICENSE
[Unlicense](https://unlicense.org/)
