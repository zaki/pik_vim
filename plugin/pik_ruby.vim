" Author:   Zoltan Dezso <dezso.zoltan@gmail.com>
" License:  MIT License

" Return if not windows
if !has("win32") && !has("win64")
  finish
endif

if &cp || exists("g:pik_ruby_loaded") && g:pik_ruby_loaded
  finish
endif
let g:pik_ruby_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

if empty($RUBY_VERSION)
  let s:pik_info = system("pik info")
  let s:pik_ruby_version = matchlist(s:pik_info, 'version: *"\([^"]\+\)*"')[1]
  let s:pik_ruby_dir     = matchlist(s:pik_info, 'binaries:\nruby: *"\([^"]\+\)*"')[1].'\'
  let $RUBY_VERSION=s:pik_ruby_version
endif

" Grabbed from RVM plugin
function! s:PikSystemCall(command, ...)
  let s:arg_string = join(a:1, " ")
  return system(s:pik_ruby_dir . a:command . " " . s:arg_string)
endfunction

function! s:PikRuby(...)
  let s:result = s:PikSystemCall("ruby", a:000)
  echo s:result
endfunction

function! s:PikGem(...)
  let s:result = s:PikSystemCall("gem", a:000)
  echo s:result
endfunction

function! s:PikList()
  let s:result = system("pik list")
  echo s:result
endfunction

command! PikList :call <SID>PikList()
command! -nargs=+ -complete=file PikRuby :call <SID>PikRuby(<f-args>)
command! -nargs=+ -complete=file PikGem :call <SID>PikGem(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
