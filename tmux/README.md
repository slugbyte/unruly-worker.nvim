# Unruly TMUX Config
> this is a somewhat minimal tmux config, you may want to tweek it or just use it as
> a reference and make your own

## INSTALL
1. copy the tmux.conf int `~/.config/tmux/tmux.conf`
2. set the env vars `EDITOR`, `COPYIER`, and `SCRATCHPAD_PATH` in your shell config
```sh
# EXAMPLE .zshrc|.bashrc env var setup
export SCRATCHPAD_PATH=~/scatchpad.md
export EDITOR=$(which nvim)
if [[ $(uname) == "Darwin" ]];then
   export COPYER=$(which pbcopy)
else
   # this is for X11 (not wayland)
   export COPYER="$(which xclip) -in -selection clipboard > /dev/null'"
fi
```
3. reload the tmux config
  * if tmux is allready running run `$ tmux source ~/.config/tmux/tmux.conf`
  * if tmux isn't running just run `$ tmux`

## KEYMAP OVERVIEW
#### TMUX NAVIGATTION
* `(C-y)` _______ focus pane left
* `(C-n)` _______ focus pane down
* `(C-e)` _______ focus pane up
* `(C-r)` _______ focus pane up
* `(C-t Space)` _ next window
* `(C-t o)` _____ next window
* `(C-t y)` _____ previous-window
* `(C-t g)` _____ goto window (select menu)
* `(C-t j)` _____ join pane into a goto window (select menu)

#### TMUX WINDOW & PANE MANAGEMENT
* `(C-t n)` _____ new window
* `(C-t x)` _____ close pane
* `(C-t s)` _____ split vertical
* `(C-t h)` _____ split horizontal
* `(C-t f)` _____ full screen current pane
* `(C-t r)` _____ rename pane

#### TMUX LAYOUT
* `(C-t l)` _____ next layout
* `(C-t Y)` _____ resize grow left
* `(C-t N)` _____ resize grow down
* `(C-t E)` _____ resize grow up
* `(C-t O)` _____ resize grow right
* `(C-t ,)` _____ swap pane prev
* `(C-t .)` _____ swap pane next

#### TMUX OTHER
* `(C-t S)` _____ popup scratchpad :)
* `(C-t c)` _____ clear screen
* `(C-t v)` _____ enter visual mode (called copy mode in tmux)
* `(C-t p)` _____ paste

#### TMUX VISUAL MODE
* `(copy mode | v)` begin selection
* `(copy mode | v)` copy selection
* `(copy mode | y)` left
* `(copy mode | n)` down
* `(copy mode | e)` up
* `(copy mode | e)` right
* `(copy mode | f)` repeat last search
* `(copy mode | F)` repeat last search backwards
* `(copy mode | Y)` goto beginning of line
* `(copy mode | O)` goto end of line
* `(copy mode | N)` go down half a page
* `(copy mode | E)` go up half a page
* `(copy mode | w)` go to next word
* `(copy mode | w)` go to prev word

#### TMUX CHOICE MODE
* `(choice mode | n)` next choice (down)
* `(choice mode | e)` prev choice (up)

