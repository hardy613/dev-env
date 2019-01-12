" Start the list of vim plugins
call plug#begin("~/.config/nvim/plugged")

" Adds the ability to close all except the current buffer
Plug 'vim-scripts/BufOnly.vim'

" Download a better colorscheme
Plug 'crusoexia/vim-monokai'
Plug 'jacoborus/tender.vim'

" Better file system browser
Plug 'scrooloose/nerdtree'

" Nerdtree git support!
Plug 'Xuyuanp/nerdtree-git-plugin'

" Allows you to run git commands from vim
Plug 'tpope/vim-fugitive'

" Github integration
Plug 'tpope/vim-rhubarb'

" Fuzzy file name searcher
Plug 'kien/ctrlp.vim'

" plugin for the tab and status bar
Plug 'vim-airline/vim-airline'

" Download powerline theme for the statusbar.
Plug 'vim-airline/vim-airline-themes'

" Git commit browser
Plug 'junegunn/gv.vim'

" AutoComplete (YouCompleteMe)
Plug 'Valloric/YouCompleteMe'

" Dims code.
Plug 'junegunn/limelight.vim'

" Minimalist mode.
Plug 'junegunn/goyo.vim'

" Better javascript indentation
Plug 'pangloss/vim-javascript'

" Add HTML5 support, also enables web components support.
Plug 'othree/html5.vim'

" Syntax support for editing markdown files.
Plug 'tpope/vim-markdown'

" Graphql support
Plug 'jparise/vim-graphql'

" ALE
Plug 'w0rp/ale'
" End the list of vim plugins
call plug#end()

" Tab shizzle
set tabstop=2
set shiftwidth=2
set smartindent
" don't convert tabs to spaces!
set noexpandtab

" Search as you type the query
set incsearch

" show row numbers
set relativenumber

" by default '0' is the current line number in the margin
set number

" Enable mouse control
set mouse=a

" Enable custom color theme
set background=dark

" Enable true colour mode
set termguicolors
silent! colorscheme monokai

" Make it highlight red when I go beyond 80 lines.
"match Error /\%91v.\+/
" Add a bar which marks the 80th character
set colorcolumn=80

" Add a alias for NERDTree
command T NERDTree

" Close the current buffer without closing the window.
command Bd bp|bd #

" Buffer delete all others (delete all except current one)
command Bdo BufOnly

" Send to system clipboard by default
set clipboard=unnamedplus

" CtrlP ignore node_modules by default to make searching faster
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](node_modules|\.git)$'
	\ }

let g:airline_powerline_fonts = 1

let g:NERDTreeMouseMode = 3

" Show the buffers at the top
let g:airline#extensions#tabline#enabled = 1

" Show the buffer numbers so I can `:b 1`, etc
let g:airline#extensions#tabline#buffer_nr_show = 1

" Aside from the buffer number, I literally just need the file name, so
" strip out extraneous info.
let g:airline#extensions#tabline#fnamemod = ':t'

" Set the theme for vim-airline
autocmd VimEnter * AirlineTheme powerlineish

" Use spaces instead just for yaml
autocmd Filetype yaml setl expandtab

" Enable marker based folding
set foldmethod=marker

set nofoldenable

" netrw file browser customizations
let g:netrw_banner=0 " disable banner
let g:netrw_browse_split=4 " Open in prior window
let g:netrw_altv=1 " open splits to the right
let g:netrw_liststyle=3 " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()

" When using `gd`, this will jump to either the definition
" or declaration (depending on what the cursor is on).
au FileType javascript nmap gd :YcmCompleter GoTo<CR>

" nice git messages
autocmd Filetype gitcommit setl colorcolumn=72
