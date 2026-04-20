"Charlie J. vimrc
:set ignorecase
:set smartcase
:set shiftwidth=4
:set tabstop=4
:set expandtab
:set diffopt=iwhite
set nowrap

"do netrw in a tree style
let g:netrw_liststyle=3
"bind TAB to / so we can search in netrw to emulate an autocomplete
autocmd filetype netrw noremap <buffer> <TAB> /
let g:netrw_banner = 0
let g:netrew_winsize = -28

set filetype=on
:syntax enable
set termguicolors
let g:tokyonight_style = 'night'
let g:tokyonight_transparent_background = 0
let g:tokyonight_enable_italic = 1
:colorscheme tokyonight

set hlsearch
set incsearch

set showmatch
"show filename all the time
set laststatus=2
"just show the file name, nothing in the path
set statusline+=%t

"load other ctag files here if needed
set tags+=./stdtags

"relative line numbers
set number
set relativenumber

"system clipboard enable
set clipboard=unnamedplus

"set grep to git grep, need to get plugins doing rest of search
set greprpg=git\ grep\ --no-color\ -n
set grepformat=%f:%l:%m

"end of .vimrx

inoremap jk <Esc>
inoremap kj <Esc>

