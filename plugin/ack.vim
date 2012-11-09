" vim-ack - performs searches with Ack.
" Version: 0.1
" Copyright © 2012 Alejandro Exojo Piqueras
" License: So-called MIT/X license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

if exists('g:loaded_vimack')
  finish
endif
let g:loaded_vimack = 1

" Needed for something?? I doubt it, but...
let s:saved_cpo = &cpo
set cpo&vim


if !exists('g:ackprg')
	if executable('ack')
		let g:ackprg = 'ack'
	elseif executable('ack-grep')
		let g:ackprg = 'ack-grep'
	endif
endif

if !exists('g:ackprg_parameters')
	let g:ackprg_parameters = ' --with-filename --column --nocolor --nogroup'
endif

function! s:Ack(pattern)
	if empty(a:pattern)
		let l:pattern = expand("<cword>")
	else
		let l:pattern = a:pattern
	end

	" Default grepformat:   %f:%l:%m,%f:%l%m,%f  %l%m
	let g:ackformat="%f:%l:%c:%m,%f:%l:%m"

	let l:saved_grepprg=&grepprg
	let l:saved_grepformat=&grepformat
	let &grepprg=g:ackprg . g:ackprg_parameters
	let &grepformat=g:ackformat
	silent execute "grep" . " " . pattern
	let &grepprg=l:saved_grepprg
	let &grepformat=l:saved_grepformat

	" TODO: :grep!
	" With the [!] any changes in the current buffer are abandoned.
endfunction

command! -bang -nargs=* Ack call s:Ack(<q-args>)


" Restore compatible options.
let &cpo = s:saved_cpo
unlet s:saved_cpo

