"======================================================================
"
" gdv.vim - 
"
" Created by skywind on 2025/11/16
" Last Modified: 2025/11/16 15:10:05
"
"======================================================================


"----------------------------------------------------------------------
" initialize highlight groups for better visibility
"----------------------------------------------------------------------
function! s:gdv_highlight_init() abort
	" Define highlight for selected line in diff view
	" Use a more visible background color
	if !hlexists('GdvSelectedLine')
		" Try to use a distinct background color
		" Use Search highlight as base, but make it more visible
		if &bg == 'dark'
			" Dark background: use a brighter, more distinct color
			highlight GdvSelectedLine ctermbg=238 ctermfg=255 cterm=bold guibg=#444444 guifg=#ffffff gui=bold
		else
			" Light background: use a darker, more distinct color
			highlight GdvSelectedLine ctermbg=252 ctermfg=0 cterm=bold guibg=#d0d0d0 guifg=#000000 gui=bold
		endif
	endif
	" Try to link quickui's selected line highlight to our custom one
	" This improves visibility in the diff view list
	if hlexists('QuickUIListSelected')
		" If quickui has its own highlight, try to make it more visible
		" by linking or redefining it
		try
			highlight link QuickUIListSelected GdvSelectedLine
		catch
			" If linking fails, try to redefine it directly
			if &bg == 'dark'
				highlight QuickUIListSelected ctermbg=238 ctermfg=255 cterm=bold guibg=#444444 guifg=#ffffff gui=bold
			else
				highlight QuickUIListSelected ctermbg=252 ctermfg=0 cterm=bold guibg=#d0d0d0 guifg=#000000 gui=bold
			endif
		endtry
	endif
endfunc


"----------------------------------------------------------------------
" command implementation
"----------------------------------------------------------------------
function! s:GitDiffView(...) abort
	let commit = (a:0 >= 1)? a:1 : ''
	call gdv#diffview#start(commit)
endfunc


"----------------------------------------------------------------------
" initialize buffer keymaps
"----------------------------------------------------------------------
function! s:gdv_buffer_init() abort
	let keymap = get(g:, 'gdv_keymap', 'dd')
	if keymap == ''
		return 0
	endif
	" Support normal file buffers with filetype=git
	if &bt == ''
		if &ft != 'git'
			" skip normal file buffers that are not git type
			return 0
		endif
	endif
	" Support nowrite buffers with filetype=git (fugitive git log output)
	" These are temporary windows created by :Git log commands like
	" :Git log --oneline or :Git log --graph --oneline --all --decorate
	" Note: buftype=nowrite, filetype=git windows are supported
	exec printf('nnoremap <buffer> %s :GitDiffView<cr>', keymap)
	return 0
endfunc


"----------------------------------------------------------------------
" command definition
"----------------------------------------------------------------------
command! -nargs=? GitDiffView call s:GitDiffView(<f-args>)


"----------------------------------------------------------------------
" autocommands
"----------------------------------------------------------------------
augroup gdv_plugin
	autocmd! 
	autocmd VimEnter,ColorScheme * call s:gdv_highlight_init()
	autocmd FileType fugitive call s:gdv_buffer_init()
	autocmd FileType GV call s:gdv_buffer_init()
	autocmd FileType floggraph call s:gdv_buffer_init()
	autocmd FileType qf call s:gdv_buffer_init()
	autocmd FileType git call s:gdv_buffer_init()
augroup END

" Initialize highlight on plugin load
call s:gdv_highlight_init()


