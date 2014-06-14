" Vim filetype plugin.
" Language:	help
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" Version:	0.1
" Description:	Navigation mappings for Vim help files
" Last Change:	2014-06-14
" License:	Vim License (see :help license)
" Location:	ftplugin/help.vim
" Website:	https://github.com/dahu/vim-help
"
" See help.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help help

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another filetype plugin for this buffer
let b:did_ftplugin = 1

" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" Restore things when changing filetype.
let b:undo_ftplugin = "setlocal spell<"
set nospell

" Disable help maps - good for editing help files {{{1

function! s:disable_help_maps()
  nunmap <buffer> <CR>
  nunmap <buffer> <BS>
  nunmap <buffer> o
  nunmap <buffer> O
  nunmap <buffer> s
  nunmap <buffer> S
  nunmap <buffer> t
  nunmap <buffer> T
  nunmap <buffer> q
  nunmap <buffer> <leader>j
  nunmap <buffer> <leader>k
endfunction

" Maps {{{1

" jump to links with enter
nmap <buffer> <CR> <C-]>

" jump back with backspace
nmap <buffer> <BS> <C-T>

" skip to next option link
nmap <buffer> o /'[a-z]\{2,\}'<CR>

" skip to previous option link
nmap <buffer> O ?'[a-z]\{2,\}'<CR>

" skip to next subject link
nmap <buffer> s /\|\S\+\|<CR>l

" skip to previous subject link
nmap <buffer> S h?\|\S\+\|<CR>l

" skip to next tag (subject anchor)
nmap <buffer> t /\*\S\+\*<CR>l

" skip to previous tag (subject anchor)
nmap <buffer> T h?\*\S\+\*<CR>l

" quit
nmap <buffer> q :q<CR>

" skip to next/prev quickfix list entry (from a helpgrep)
nmap <buffer> <leader>j :cnext<CR>
nmap <buffer> <leader>k :cprev<CR>

" disable vim-help maps
nmap <buffer> <leader>q :<c-u>call <SID>disable_help_maps()<cr>

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
