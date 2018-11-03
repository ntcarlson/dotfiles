set spell
set tw=80

" Show Vimtex ToC instead of tagbar
map <C-b> <plug>(vimtex-toc-open)

let vimtex_toc_config = {'layer_keys': {'label': 'L', 'include': 'I', 'todo': 'T', 'content': 'C'}, 'todo_sorted': 1, 'split_width': 25, 'mode': 1, 'split_pos': 'vert leftabove', 'name': 'Table of contents', 'fold_level_start': -1, 'hotkeys_leader': ';', 'show_numbers': 0, 'hotkeys_enabled': 0, 'fold_enable': 0, 'hotkeys': 'abcdeilmnopuvxyz', 'show_help': 0, 'layer_status': {'label': 1, 'include': 1, 'todo': 1, 'content': 1}, 'hide_line_numbers': 1, 'refresh_always': 1, 'tocdepth': 3, 'resize': 0} 

" Function to nicely wrap paragraphs in TeX source
fun! TeX_fmt()
    if (getline(".") != "")
    let save_cursor = getpos(".")
        let op_wrapscan = &wrapscan
        set nowrapscan
        let par_begin = '^\(%D\)\=\s*\($\|\\label\|\\begin\|\\end\|{\|}\|\\[\|\\]\|\\\(sub\)*section\>\|\\item\>\|\\NC\>\|\\blank\>\|\\noindent\>\)'
        let par_end   = '^\(%D\)\=\s*\($\|\\begin\|\\end\|{\|}\|\\\(sub\)*section\>\|\\item\>\|\\NC\>\|\\blank\>\)'
    try
      exe '?'.par_begin.'?+'
    catch /E384/
      1
    endtry
        norm V
    try
      exe '/'.par_end.'/-'
    catch /E385/
      $
    endtry
    norm gq
        let &wrapscan = op_wrapscan
    call setpos('.', save_cursor) 
    endif
endfun

nmap Q :call TeX_fmt()<CR>
