" Vim global plugin for better help invocation & navigation
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" Version:	0.2
" Description:	Maps for opening help on current word with F1 and re-opening
" 		prior help location with shift-F1
" License:	Vim License (see :help license)
" Location:	plugin/help.vim
" Website:	https://github.com/dahu/vim-help
"
" See help.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help help

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" if exists("g:loaded_help")
"       \ || v:version < 700
"       \ || &compatible
"   let &cpo = s:save_cpo
"   finish
" endif
let g:loaded_help = 1

" Maps: {{{1

" Use F1 to show context sensitive help for keyword under cursor
" Deliberately left off the terminating <cr> to allow modification.
" Moves the cursor to the beginning of the term for contextual markup.
" (:help help-context)

nnoremap <plug>HelpWord :help <c-r>=help#expand_help_word()<cr><c-b><c-right><right>

if !hasmapto('<plug>HelpWord')
  nmap <unique> <f1> <plug>HelpWord
  cmap <unique> <f1> <c-\><c-n><plug>HelpWord
endif

" If we have https://github.com/dahu/markmywords then shift-F1 jumps to the
" last help file you were in.  NOTE: Some terminals might need a map for the
" keycode that <s-f1> generates to the symbolic <s-f1>. For example, in
" xfce-terminal, that looks like:
"   map ^[O1;2P <s-f1>
" where   ^[01;2P   is generated with    ctrl-v shift-F1
" Do this in your ~/.vimrc

nnoremap <plug>LastHelp :call help#last_help_jump()<cr>

if !hasmapto('<plug>LastHelp')
  nmap <unique> <s-f1> <plug>LastHelp
endif

" Commands: {{{1

if exists('g:vimple_version')
  command! -nargs=0 -bang -bar TopicToClipboard     echo help#topic(<q-bang>)
  command! -nargs=0 -bang -bar HelpTopicToClipboard echo help#topic(<q-bang>)
endif

" Teardown: {{{1
" reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
