" Vim library providing better :help support
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" Version:	0.2
" Description:	Vim library providing better :help support
" License:	Vim License (see :help license)
" Location:	autoload/help.vim
" Website:	https://github.com/dahu/help
"
" See help.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help help

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" if exists("g:loaded_lib_help")
"       \ || v:version < 700
"       \ || &compatible
"       \ || !exists('g:vimple_version')
"   let &cpo = s:save_cpo
"   finish
" endif
let g:loaded_lib_help = 1

" Vim Script Information Function: {{{1
function! help#info()
  let info = {}
  let info.name = 'help'
  let info.version = 0.2
  let info.description = 'Better :help support'
  let info.dependencies = [
        \ {'name': 'MarkMyWords', 'version': 0.1}
        \ {'name': 'Vimple', 'version': 0.9}
        \ ]
  return info
endfunction

let s:topic_pattern = '\*.\{-}\*'

function! help#sort_topicly(a, b)
  if a:a =~ 'E\d' && a:b =~ 'E\d'
    return str2nr(strpart(a:a, 2)) - str2nr(strpart(a:b, 2))
  else
    let a = (a:a =~ '^no') ? strpart(a:a, 2) : a:a
    let b = (a:b =~ '^no') ? strpart(a:b, 2) : a:b
    return a > b
  endif
endfunction

function! help#topic_cluster()
  let topics = []
  let line = line('.')
  let d = 1
  for i in range(2)
    let l = getline(line)
    while l =~ s:topic_pattern
      call extend(topics, string#scanner(l).collect(s:topic_pattern))
      let line += d
      let l = getline(line)
    endwhile
    let line -= 1
    let d = -1
  endfor
  return map(uniq(sort(topics, 'help#sort_topicly')), 'strpart(v:val, 1, len(v:val)-2)')
endfunction

" Collect the current help topic into the selection register
" always_show_distance_from_topic : show cursor line distance
" even if the cursor is less than 9 lines from the topic
function! help#topic(always_show_distance_from_topic)
  if &ft != 'help'
    return ''
  endif
  let pos = getpos('.')
  call search(s:topic_pattern, 'bW')
  let tpos = getpos('.')
  let topics = help#topic_cluster()
  call setpos('.', pos)
  if len(topics) == 0
    return ''
  else
    let result = ':help ' . topics[0]
    let distance = pos[1] - tpos[1]
    if (distance > 9) || (a:always_show_distance_from_topic == '!')
      let result .= ' |+' . distance
    endif
    let @* = result
    return result
  endif
endfunction

" Expand topic under cursor, and out from cursor upon multiple successive calls

let s:last_help_curpos = []
let s:help_count= -1

function! help#terms(line)
  let terms = []
  for w in split(getline('.'), '[^a-zA-Z_:]')
    call extend(terms, split(w, '[[:space:]]'))
  endfor
  return filter(filter(terms, 'v:val !~ "^\\s*$"'), 'len(v:val) > 1')
endfunction

function! help#uniq(list)
  let list = []
  let seen = {}
  for i in a:list
    if has_key(seen, i)
      continue
    else
      let seen[i] = 0
    endif
    call add(list, i)
  endfor
  return list
endfunction

function! help#expand_help_word()
  let term   = expand('<cword>')
  let terms  = help#terms('.')
  let idx    = index(terms, term)
  let terms  = help#uniq(extend(reverse(terms[: idx]), terms[idx :]))
  let curpos = getpos('.')
  if s:last_help_curpos != curpos
    let s:help_count = 0
    let s:last_help_curpos = curpos
  endif
  let term = terms[s:help_count % len(terms)]
  let s:help_count += 1
  return term
endfunction

function! help#clear_last_help_curpos()
  let s:last_help_curpos = []
endfunction

augroup HelpTerms
  au!
  autocmd CursorMoved,CursorHold,InsertLeave * call help#clear_last_help_curpos()
augroup END

" Use the MarkMyWords plugin to return to the last help-file position

function! help#last_help_jump()
  if exists('g:markmywords_version')
    MMWSelect helpmark
  endif
endfunction

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
