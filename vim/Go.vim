function! Go()
    let line = getline('.')
    echo line
    let file = matchstr(line, '(\zs[^)]*\ze)')
    echo file
    if !empty(file)
        execute 'edit ' . fnameescape(file)
    endif
endfunction

nnoremap <CR> :call  Go()<CR>
