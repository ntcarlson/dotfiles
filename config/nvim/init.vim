set shell=/bin/bash

" ============================= Plugins =======================================
" Plugins are minimal because Oni handles most of the heavy-weight tasks that
" plugins like YouCompleteMe or NERDTree do
filetype off    " Required for Vundle
set runtimepath+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'               " Plugin manager
    Plugin 'airblade/vim-gitgutter'             " Show lines changed or added
    Plugin 'tommcdo/vim-lion'                   " Align text with gl and gL
    Plugin 'tpope/vim-repeat'                   " Improves repeat support
call vundle#end()

" ============================= Appearance ====================================
syntax enable		            " Enable syntax highlighting 
set t_Co=256		            " Terminal colors
set number 		                " Enable line numbers
set rnu 		                " Relative line numbers"
set hlsearch                    " Highlight search results
set gcr=a:blinkon0              " Disable cursor blink
set visualbell                  " No bell sound
set t_vb=                       " No horrible visual flash on bell
set showcmd                     " Show incomplete commands
set encoding=utf-8              " Special characters for plugins
hi EndOfBuffer ctermfg=black    " Disable tilde on blank line


" ============================= Behavior ======================================
set nocompatible                " Disable legacy VI mode
filetype plugin on              " Load different plugins based on file type
filetype indent on              " Use different identation based on file type
set backspace=indent,eol,start  " Make backspace always work in insert mode
set history=1000                " Store lots of :cmdline history
set autoread                    " Reload files changed outside vim
set mouse=a                     " Enable mouse
set hidden                      " Don't close buffers when they are hidden
set clipboard=unnamedplus       " Use system clipboard as default register
let mapleader=","               " Prefix key for custom commands
let maplocalleader=","          " Also use , for the Vimtex leader
set updatetime=500              " Refresh rate in ms (mainly for plugins)
set scrolloff=4                 " Scroll up/down 4 lines away from the margins
set wildmenu                    " Tab completion menu (for :e, etc)
set wildmode=longest,list,full  " Nicer tab completion behavior
" Behavior of long lines
set nowrap 		                " Don't visually wrap lines
set linebreak 		            " Break lines at word boundaries
set sidescroll=0                " Disable horizontal scroll
set sidescrolloff=2             " Scroll left/right 2 chars away from margin
" Indentation
set tabstop=4                   " Display tabs as 4 spaces
set expandtab                   " Tab key inserts spaces instead of a tab
set softtabstop=4               " Tab key inserts 4 spaces
set shiftwidth=4                " < and > shift by 4 spaces for consistency
" Folding hides functions/sections until they are expanded
set foldenable 		            " Fold by default
set foldmethod=syntax 	        " Fold based on indent
set foldnestmax=3 	            " Deepest fold is 3 levels
" Turn off swap files
set noswapfile
set nobackup
set nowb
" Store undo history in a file for persistent undo
if has('persistent_undo')
    silent !mkdir ~/.vim/backups > /dev/null 2>&1
    set undodir=~/.vim/backups
    set undofile
endif


" ============================= Controls ======================================

"Window navigation
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k

"Tab navigation
nnoremap <S-h> :bprev<CR>
nnoremap <S-l> :bnext<CR>

"Go back to previous cursor position
nnoremap <Tab> <C-O> 
"Go forward
nnoremap <S-Tab> <C-I> 

"Open/close folds"
nnoremap <Space> zA
