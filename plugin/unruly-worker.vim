"                      __                         __
"  __ _____  ______ __/ /_ _______    _____  ____/ /_____ ____
" / // / _ \/ __/ // / / // /___/ |/|/ / _ \/ __/  '_/ -_) __/
" \_,_/_//_/_/  \_,_/_/\_, /    |__,__/\___/_/ /_/\_\\__/_/
"                     /___/
"
" Name: unruly-worker
" License: Unlicense
" Maintainer: Duncan Marsh (slugbyte@slugbyte.com)
" Repository: https://github.com/slugbyte/unruly-worker

if exists("unruly_worker")
  finish
endif

let g:unruly_worker=1

" b for brace match
noremap b %

" disable B
noremap B \

" c is comment line
nmap c gcc

" C is for comment paragraph
nmap C gcip

" c and C are comment visual
vmap c gc
vmap C gc<esc>

" d is for delete
"noremap d d
" D is for delete to EOL
"noremap D D


" e is for up
noremap e k

" E is for end of word
noremap E e

" f is for find next search
noremap f n
" F is for find next search reverse
noremap F N

" g is for extra g cmds
"noremap g g


" G is go to top of file
"noremap G g

" h is for hop to next t/T
noremap h ;
" H is for hop to next t/T reverse
noremap H ,

" i is for insert
"noremap i i

" I is for insert to BOL
"noremap I I

" j is for select register (sorry couldn't think of a semantic name)
noremap j "

" disable J
noremap J \

" k is for kopy (yank)
noremap k y

" k is for kopy line (yank line)
noremap K Y

" l is for line below insert
noremap l o
" L is for line above insert
noremap L O

" M is for register mark
noremap M m

" m is for go to mark
noremap m '
"

" n is for down
noremap n j

" N is for nudge line (join lines)
noremap N J

" o is for right
noremap o l

" o is for goto EOL
noremap O $

" p is for paste below
"noremap p p

" P is for paste above
"noremap P P

" q is for macro record
"noremap q q

" Q is for macro play
noremap Q @

" r is for replace char
"noremap r r

" R is for replace mode
"noremap R R

" s is for select word
noremap s viw

" S is for select line
noremap S ^v$

" t is go to next pressed char
noremap t f

" t is go to next pressed char reverse
noremap T F

" u is for undo
"noremap u u

" U is for redo
noremap U <c-r>

" C-r is disabled
noremap <c-r> \

" v is for visual mode
"noremap v v

" V is for visual line mode
"noremap V V

" w is for next word
"noremap w w

" W is for prev word
noremap W b

" x is for delete char forward
"noremap x x

" x is for delete char backward
"noremap X X


" y is for left
noremap y h

" Y is for BOL
noremap Y ^

" z is for extra z cmds
"noremap z z

" z is for extra z cmds
"noremap Z Z

" repeat cmd
noremap , .

" repeat search
noremap . &

" < is for shift left
"noremap < <

" > is for shift right
"noremap > >

" / is for search down
"noremap / /

" ? is for search up
" noremap ? ?

" ' is for command mode
noremap ' :

" ! is for command mode
noremap ! <cmd>lua vim.lsp.buf.rename()<cr>

" disable "
noremap " \

" disable *
noremap * \

" [ is jump paragraph up
noremap [ [

" [ is jump paragraph down
noremap ] ]

" [ is jump prev indent
"noremap { #

" [ is jump next indent
"noremap } *

" disable |
"noremap | \


" disable `
"noremap ` \

" ; is command mode
"noremap : :

" @ is go to top of screen
noremap @ zt

" $ is goto middle of screen
noremap $ zz

" # is goto top of screen
noremap # zb

" % is disabled
noremap % \ disabled

" ^ is ex mode
noremap ^ @

" & is disabled
noremap & <cmd>lua vim.lsp.buf.formatting()<cr>

" ; is split window and goto definition
noremap ; <cmd>split<cr><cmd>lua vim.lsp.buf.definition()<cr>

" ( is goto begening of sentance
"noremap ( (

" ) is goto end of sentance
"noremap ) )

" is goto next diagnostic
noremap _ <cmd>lua vim.diagnostic.goto_next()<CR>

" - is goto previous diagnostic
noremap - <cmd>lua vim.diagnostic.goto_prev()<CR>

" + is disabled
"noremap + \

" = is run lsp code_action
noremap = <cmd>lua vim.lsp.buf.code_action()<CR>

" C-motion remap
map <C-y> <C-h>
map <C-n> <C-j>
map <C-e> <C-k>
map <C-o> <C-l>

" remap g movement commands
noremap gn gj
noremap ge gk
" gj is disabled
map gj \
" gk is disabled
map gk \

" up and down are visual not line based
map n gn
map e ge

" C-Arrow will swap lines
nnoremap <C-Down> :m .+1<CR>==
nnoremap <C-Up> :m .-2<CR>==
inoremap <C-Down> <Esc>:m .+1<CR>==gi
inoremap <C-Up> <Esc>:m .-2<CR>==gi
vnoremap <C-Down> :m '>+1<CR>gv=gv
vnoremap <C-Up> :m '<-2<CR>gv=gv

" command map
cmap <c-a> <home>
cmap <c-e> <end>
