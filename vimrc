set shell=/bin/bash

" ============================= Plugins =======================================
" Manage plugins with Vundle
filetype off    " Required for Vundle
set runtimepath+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'               " Plugin manager
    Plugin 'altercation/vim-colors-solarized'   " Color scheme
    Plugin 'vim-airline/vim-airline'            " Fancy status bar
    Plugin 'vim-airline/vim-airline-themes'     " Themes for the status bar
    Plugin 'scrooloose/nerdtree'                " File tree browser
    Plugin 'Xuyuanp/nerdtree-git-plugin'        " Show git status in NERDtree
    Plugin 'airblade/vim-gitgutter'             " Show lines changed or added
    Plugin 'majutsushi/tagbar'                  " File outline viewer
    Plugin 'tpope/vim-fugitive'                 " Git utilities inside Vim
    Plugin 'Valloric/YouCompleteMe'             " Autocompleter and linter
    Plugin 'SirVer/ultisnips'                   " Insert code snippets
    Plugin 'moll/vim-bbye'                      " Better buffer close behavior
    Plugin 'lervag/vimtex'                      " Modern LaTeX plugin
    Plugin 'tommcdo/vim-lion'                   " Align text with gl and gL
    Plugin 'wellle/targets.vim'                 " Extends text objects like i}
    Plugin 'tpope/vim-commentary'               " Comment out code with gc
    Plugin 'tpope/vim-repeat'                   " Improves repeat support
    Plugin 'the-lambda-church/coquille'         " Coq plugin
    Plugin 'let-def/vimbufsync'                 " Required for Coquille
    Plugin 'vimwiki/vimwiki'                    " Orgmode-esque plugin
call vundle#end()

" ============================= Appearance ====================================
syntax enable		            " Enable syntax highlighting 
set t_Co=256		            " Terminal colors
colorscheme solarized	        " Solarized color scheme
set background=dark             " Use Solarized Dark
set number 		                " Enable line numbers
set rnu 		                " Relative line numbers"
set hlsearch                    " Highlight search results
set gcr=a:blinkon0              " Disable cursor blink
set visualbell                  " No bell sound
set t_vb=                       " No horrible visual flash on bell
set showcmd                     " Show incomplete commands
set encoding=utf-8              " Special characters for plugins
" Enable transparent background
hi Normal ctermbg=NONE
hi LineNr ctermbg=NONE   
hi texMathZoneX ctermbg=NONE
hi texMathMatcher ctermbg=NONE
hi texStatement ctermbg=NONE
hi texRefLabel ctermbg=NONE
hi SignColumn ctermbg=NONE
" Disable tilde on blank line
hi EndOfBuffer ctermfg=black
" Underline current line
set cursorline
hi CursorLine cterm=underline ctermbg=NONE ctermfg=NONE


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


" ============================= Airline =======================================
let g:airline_theme = 'solarized'   " Solarized color scheme for the status bar
let g:airline_solarized_bg = 'dark' " Use Solarized Dark
let g:airline_inactive_collapse = 1 " Collapse status bar for inactive windows
let g:airline_powerline_fonts = 1   " Use Powerline font for special symbols
set noshowmode                      " Disable default status bar
set laststatus=2                    " Always show status bar
" Extensions used:
"   Branch    - Show the current git branch
"   Tabline   - Enable top bar to show tabs and buffers
"   Syntastic - Show errors and warnings from Syntastic on the status bar
"   Tagbar    - Show the current function on the status bar
let g:airline_extensions = ['branch', 'tabline', 'ycm', 'tagbar', ]
" Label the tabs/buffers which allows for the tab navigation commands
let g:airline#extensions#tabline#buffer_idx_mode = 1


" ============================= NERDTree ======================================
let NERDTreeMapActivateNode = '<SPACE>' " Space opens dir/files
let NERDTreeMinimalUI   = 1             " Disable help message
let NERDTreeMouseMode   = 3             " Single click to open any dir/file
let NERDTreeQuitOnOpen  = 0             " Keep NERDTree open after opening file
" Automatically open NERDtree if Vim is opened on a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif


" ============================== Tagbar =======================================
let g:tagbar_compact = 1        " Disable help message
let g:tagbar_singleclick = 1    " Single click to navigate to tag definition
let g:tagbar_sort = 0           " Show tags in the same order as the source
let g:tagbar_width = 30         " Reduce Tagbar split width to 30 columns
let g:tagbar_autoshowtag = 1    " Expand folds to show current tag
let g:tagbar_map_togglefold = "<SPACE>"
" Automatically open Tagbar on C/C++ source files
"autocmd FileType c,cpp,h nested :TagbarOpen


" =========================== YouCompleteMe ===================================
let g:ycm_max_num_candidates = 10   " Show 10 autocompleter entries
let g:ycm_confirm_extra_conf = 0    " Don't ask to load ycm conf
let g:ycm_error_symbol = ''        " Marker for lines with errors
let g:ycm_warning_symbol = ''      " Marker for lines with warnings
" Use preview menu to show detailed information about completion from semantic
" engine including documentation from header. Close it when completion is done 
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
" Set default configuration file to use as a backup
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_global_conf.py"
let g:UltiSnipsExpandTrigger="<C-J>"



" =============================== Vimtex ======================================
let g:tex_flavor='latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_view_automatic = 0
let g:vimtex_toc_show_preamble = 1

" =============================== Coquille =====================================
au FileType coq call coquille#FNMapping()

" =============================== Orgmode ======================================
:let g:org_agenda_files=['~/Documents/agenda.org']

" =========================== Custom commands ==================================

" Tab navigation; uses Airline's tab navigation commands which handle windows
" from Tagbar and NERDTree better
nmap <S-H>  <Plug>AirlineSelectPrevTab
nmap <S-L>  <Plug>AirlineSelectNextTab

"Window navigation"
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k

" Invoke Make
nnoremap <leader>m :w<CR>:make<CR>

" Close buffer; uses Bbye plugin instead of default bdelete command for more
" desirable behavior when closing buffers when Tagbar or NERDTree are open
nnoremap <leader>q :Bdelete<CR>
nnoremap <leader>Q :Bdelete!<CR>

map <C-n> :NERDTreeToggle<CR>
map <C-b> :TagbarToggle<CR>
map <C-g> :YcmCompleter GoTo<CR>

"Go back to previous cursor position
nnoremap <Tab> <C-O> 
"Go forward
nnoremap <S-Tab> <C-I> 

"Open/close folds"
nnoremap <Space> zA

"Save without exiting insert mode"
imap <Leader>ww <ESC>:w<CR>


