" here we define a new operator, the operator can work with Operator-Pending
" mode
"
" viw<leader>g, 'v', char width visual mode, operate the cursor word
" Vjj<leader>g, 'V', line width visual mode, do nothing
" <leader>giw,  'char', characterwise motion mode, operate the cursor word
" <leader>gG,   'line', linewise motion mode, do nothing
augroup grep_operator
	autocmd!
	" <SIG> indicate we search current file scope
	nnoremap <leader>g :set operatorfunc=<SIG>GrepOperator<cr>g@
	vnoremap <leader>g :<c-u>call <SIG>GrepOperator(visualmode())<cr>
augroup END

" s: prefix define the function only valid at current file (static)
function! s:GrepOperator(type)
	" protect register
	let save_unnamed_register = @@

	if a:type ==# 'v'
		execute "normal! `<v`>y"
	elseif a:type ==# 'char'
		execute "normal! `[v`]y"
	else
		return
	endif

	"echom shellescape(@@)
	silent execute "grep -R " . shellescape(@@) . " ."
	copen

	let @@ = save_unnamed_register
endfunction
