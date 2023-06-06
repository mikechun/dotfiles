" -----------------------------------------------------------------------------
" This config is targeted for Vim 8.1+ and expects you to have Plug installed.
" -----------------------------------------------------------------------------

" mikechun's ViM configuration
" Author: Michael Chun
" Created: 2022-05-26
"
" Derived many parts from 
" Jaeho Shin <netj@sparcs.org>
"
" References 
" https://github.com/nickjj/dotfiles/blob/master/.vimrc
" https://github.com/mathiasbynens/dotfiles/blob/main/.vimrc
"
" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------
" Source optional files. This autoloads plugin script
fun! SourceOptional(files)
  for f in a:files | if filereadable(expand(f)) | exec 'source '.f | endif | endfor
endfun
command! -nargs=* SourceOptional :call SourceOptional([<f-args>])

SourceOptional ~/.vim_local.before       " keep this file clean

" install plugins in plugged directory
call plug#begin('~/.vim/plugged')
Plug 'junegunn/seoul256.vim'             " color schemes
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'                " git commands
Plug 'ctrlpvim/ctrlp.vim'                " fuzzy file and buffer finder
call plug#end()

" typescript results in redraw time exceed error https://jameschambers.co.uk/vim-typescript-slow
set re=0                " use new regular expression engine 

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" indent and UI settings
set autoindent		" always set autoindenting on
set copyindent		" indent even when copying
set preserveindent	" preserve whitespace for indentations
set nobackup		" don't keep backups
set history=1024	" keep so many lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set showmode		" display current mode
set title		" set xterm title
set nowrap              " no line wrapping

" searching
set incsearch		" do incremental searching
set ignorecase          " ignore case when searching
set smartcase           " but be smart when I type uppercases

" encodings
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,korea

" tabs
set softtabstop=4
set tabstop=8
set shiftwidth=4
set expandtab
set listchars=tab:>.,eol:$

" highlighting
syntax on
set hlsearch
highlight Search term=reverse ctermbg=3 ctermfg=1

SourceOptional ~/.vim/vimplugin.vim

" Use the Solarized Dark theme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" Configure ctrlp
"
let g:ctrlp_cmd = 'CtrlPMixed'       " search in Files, Buffers and MRU files at the same time.
let g:ctrlp_mruf_relative = 1        " show MRUF first
let g:ctrlp_show_hidden=1            " show hidden files such as dot-files
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
                                     " in git, hide all files non-indexed files in .gitignore.  
                                     " if you want to see a file from gitignore, add it to the index
