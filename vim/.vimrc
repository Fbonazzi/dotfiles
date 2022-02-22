" No need to be compatible
set nocompatible

" Set line numbers
set number

" Use true colors
if (has("termguicolors"))
    set termguicolors
    " This is only necessary if you use "set termguicolors"
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let g:gruvbox_italic=1
" Set theme and dark background
colorscheme gruvbox
set background=dark

" Set the title of the terminal based on the open file
set title
" Recognize filetype and indent consequently
filetype plugin indent on
" Enable Omnicompletion
set omnifunc=syntaxcomplete#Complete

" When a bracket is inserted, briefly jump to the matching one
set showmatch

" Be smart with upper and lowercase when searching
set ignorecase
set smartcase

" Incremental search
set incsearch

" Folding
set foldmethod=syntax
set foldlevelstart=99

" Space toggles folds
nnoremap <space> za

" More natural split opening
set splitbelow
set splitright

" Better completion menu
set completeopt=longest,menuone,preview

" Better file completion menu
set wildmode=longest,list,full

" Better word wrapping
set lbr

" Enable mouse
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
set ttymouse=xterm2

" Yank from cursor to end of line
nnoremap Y y$

" Netrw
let g:netrw_browse_split = 1
let g:netrw_liststyle = 3

" Changes from last save
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Delete comment character when joining commented lines
if v:version > 703
    set formatoptions+=j
endif

" Flag problematic whitespace (trailing and spaces before tabs)
" Note you get the same by doing let c_space_errors=1 but this applies
" everywhere
highlight RedundantSpaces term=standout ctermbg=red guibg=red
"\ze sets end of match so only spaces highlighted
" match RedundantSpaces /\s\+$\| \+\ze\t/
function HighlightBadWhitespace()
    match RedundantSpaces /\s\+$\| \+\ze\t/
endfunction
"use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>
call HighlightBadWhitespace()

" Set the filetype to sh when editing the command line with <C-x><C-e>
augroup cmdline_editor
    autocmd!
    autocmd BufEnter * if @% =~# '.*/bash-fc' | set ft=sh | endif
augroup END

" Format the whole file remaining in that position
function! Format()
    if exists("b:formatter")
        :delm q
        :delm r
        normal mqHmr
        :w
        let &formatprg=b:formatter
        silent exe "'[,']!".&formatprg
        if v:shell_error == 1
            let fe = join(getline(line("'["), line("']")), "\n")
            :earlier 1f
            echo fe
        endif
        normal `rzt`q
        :delm q
        :delm r
    else
        echom "No formatter defined"
    endif
endfunction
nmap <silent> <F2> :call Format() <CR>

" Highlight the cursor position
function HighlightNearCursor()
    checktime
    if !exists("s:highlightnearcursor")
        setlocal cursorline cursorcolumn
        let s:highlightnearcursor=1
    else
        setlocal nocursorline nocursorcolumn
        unlet s:highlightnearcursor
        call HighlightBadWhitespace()
    endif
endfunction
nnoremap <F12> :call HighlightNearCursor()<CR>


" Highlight all occurrences of variables under the cursor
function HighlightUnderCursor()
    checktime
    if !exists("s:highlightundercursor")
        exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
        let s:highlightundercursor=1
    else
        match None
        unlet s:highlightundercursor
        " Rematch the spaces
        call HighlightBadWhitespace()
    endif
endfunction
nnoremap <F11> :call HighlightUnderCursor()<CR>

" Reload file without prompting if file changed externally but not internally
set autoread
augroup reload_file
    autocmd CursorHold * checktime
augroup END

" Enable fenced code block syntax highlighting
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'shell=sh', 'c', 'Makefile=make']

" View a currently open buffer in a vertical split
:command -nargs=1 -complete=buffer Vsb vertical sb <args>
" Override the non-existing builtin :vsb command to call our Vsb command
:cabbrev vsb <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Vsb' : 'vsb')<CR>

" Automatically generate include guards in C headers
function! s:insert_C_gates()
    let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    execute "normal! i#ifndef " . gatename
    execute "normal! o#define " . gatename
    execute "normal! o"
    execute "normal! o"
    execute "normal! o"
    execute "normal! Go#endif /* " . gatename . " */"
    normal! kk
endfunction
" Automatically generate headers in various scripts
function! s:insert_script_header(command)
    set paste
    execute "normal! i#!" . a:command
    execute "normal! o#"
    execute "normal! o# TODO: description"
    execute "normal! o"
    execute "normal! o"
    set nopaste
    normal! kkw
endfunction
augroup headers
    autocmd!
    autocmd BufNewFile *.{h,hpp} call <SID>insert_C_gates()
    autocmd BufNewFile *.py call <SID>insert_script_header("/usr/bin/env python")
    autocmd BufNewFile *.sh call <SID>insert_script_header("/bin/sh")
    autocmd BufNewFile Makefile call <SID>insert_script_header("/usr/bin/make")
augroup END
