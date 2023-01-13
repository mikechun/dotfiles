" mikechun's ViM configuration
" Author: Michael Chun
" Created: 2022-05-26
"
" Derived many parts from 
" Jaeho Shin <netj@sparcs.org>

version 8.2
set nocompatible                         " This is Vi IMproved, not Vi :^)

" source optional files
fun! SourceOptional(files)
  for f in a:files | if filereadable(expand(f)) | exec 'source '.f | endif | endfor
endfun
command! -nargs=* SourceOptional :call SourceOptional([<f-args>])

SourceOptional ~/.vim_local.before       " keep this file clean

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




