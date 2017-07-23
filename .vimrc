" Stop trying to be compatible with vi
set nocompatible              " required

" Turn off file type?
filetype off                  " required

" Make 256 colors available
if !has('gui_running')
	  set t_Co=256
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"
" " Add all your plugins here (note older versions of Vundle used Bundle
" instead of Plugin)

"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
Plugin 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ }

"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Turn on status line all the time
set laststatus=2

" Prevent status from line wrapping
set ambiwidth=double

" Let airline use powerline symbols
let g:airline_powerline_fonts = 1

" Turn on syntax highlighting
syntax on

" Make splits appear below and to the right
set splitbelow
set splitright

" Avoid prefix when switching between panes
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>
noremap <C-H> <C-W><C-H>

" Set folding conventions
set foldmethod=indent
set foldlevel=99
noremap <space> za

" Set encoding and newline behavior
scriptencoding utf-8
set encoding=utf-8
set fileformat=unix

" Highlight a bunch of things
set cursorcolumn
set cursorline
set hlsearch!
set matchpairs+=<:>
set showmatch
hi Visual ctermfg=Blue ctermbg=LightGray
hi CursorColumn ctermbg=DarkBlue

" Use visual instead audible bells for errors
set visualbell

" Use hybrid line numbering
set relativenumber
set number

" Always show the cursor position
set ruler

" Show command characters
set showcmd

" Always display the current mode for the open buffer
set showmode

" Enable return to NORMAL mode with jk
inoremap jk <Esc>

" Enable incremental searching (while typing)
set incsearch

" Set explorer view
let g:netrw_liststyle=3     " Use tree-mode as default view

" tab completion settings
set wildmenu                " enable menu at the bottom
set wildmode=longest:full,full " wildcard matches show a list, matching the longest first, try list:longest
set wildignore+=.git	    " ignore version control repos
set wildignore+=*.pyc       " ignore Python compiled files
set wildignore+=*.swp       " ignore vim backups
set wildignore+=*.so,*.swp,*.zip,*.gz,*.min.js,*.o " ignore some more filetypes

" ignore some files when using TAB key with :e
set suffixes=~,.bak,.dvi,.hi,.o,.pdf,.gz,.idx,.log,.ps,.swp,.tar,.toc,.ind

" editor settings for file types and syntax highlighting specials
autocmd FileType make setlocal tabstop=4 noexpandtab
autocmd FileType markdown setlocal shiftwidth=4 tabstop=4
autocmd FileType python set expandtab shiftwidth=4 tabstop=4 softtabstop=4 smartindent autoindent
autocmd FileType text setlocal textwidth=78
autocmd FileType vim setlocal shiftwidth=2 tabstop=2

autocmd BufRead,BufNewFile {*.csv,*.dat,*.tsv} setfiletype csv
autocmd BufRead,BufNewFile {*.md,*.markdown,*.mdown,*.mkd} set filetype=markdown autoindent formatoptions=tcroqn2 comments=n:&gt;
autocmd BufRead,BufNewFile *.txt setfiletype text

" enable all Python syntax highlighting features
let python_highlight_all = 1 
