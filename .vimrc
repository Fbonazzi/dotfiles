" No need to be compatible
set nocompatible
set number

if has("gui_running")
	" Remove the stupid toolbar and scrollbars
	set guioptions-=T
	set guioptions-=r
	set guioptions-=L
	set guifont=Inconsolata\ Medium\ 11
	" Set theme and dark background
	set background=dark
	colorscheme solarized
else
	" Fix for GUI colorschemes
	set t_Co=256
	" Force italics (valid in urxvt, gnome-terminal)
	set t_ZH=[3m
	set t_ZR=[23m
	let g:gruvbox_italic=1
	" Set theme and dark background
	colorscheme gruvbox
	set background=dark
endif


"Should already be set in /etc/vim/vimrc
"if has("syntax")
"	syntax on
"endif
"
" Set the title of the terminal based on the open file
set title
" Recognize filetype and indent consequently
filetype plugin indent on
" Enable Omnicompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"Auto chmod +x executable files
"au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod a+x <afile> | endif | endif

" Experimental, suggested from /etc/vim/vimrc
set showcmd
set showmatch
set ignorecase
set smartcase
set incsearch
set autowrite
set hidden

" Folding
set foldmethod=syntax
set foldlevelstart=99
let g:sh_fold_enabled=7

" Space will toggle folds!
nnoremap <space> za

"Word count nei documenti di latex con F3
"map <F3> :w !detex -l \| wc -w<CR>

" More natural split opening
set splitbelow
set splitright

" Better completion menu
set completeopt=longest,menuone

" Better file completion menu
set wildmode=longest,list,full
set wildmenu

" Better word wrapping
set lbr

" Use mouse properly
set mouse=a

" Toggle paste mode
set pastetoggle=<F10>

" Yank from cursor to end of line
nnoremap Y y$

" Changes from last save
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Enable the man page viewer
" you can place your cursor on a word <Leader>K (\K) to see the man page for that word
" or :Man 3 printf
runtime! ftplugin/man.vim

" Compatibility with VIM as man pager
let $MANPAGER=''

" Delete comment character when joining commented lines
if v:version > 703
	set formatoptions+=j
endif

"flag problematic whitespace (trailing and spaces before tabs)
"Note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
highlight RedundantSpaces term=standout ctermbg=red guibg=red
"\ze sets end of match so only spaces highlighted
" match RedundantSpaces /\s\+$\| \+\ze\t/
function HighlightBadWhitespace()
	match RedundantSpaces /\s\+$\| \+\ze\t/
endfunction
"use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>
call HighlightBadWhitespace()

" Find the current git repository toplevel, if it exists
function! Get_git_toplevel()
	let git_path = substitute(system("git rev-parse --show-toplevel 2>/dev/null"), '\n', '', '')
	if empty(git_path)
		return ""
	else
		return git_path . "/"
	endif
endfunction
" Support repository or directory-specific .vimrc.custom files
let repository_vimrc = Get_git_toplevel() . ".vimrc.custom"
if filereadable(fnameescape(repository_vimrc))
	exec 'source '.fnameescape(repository_vimrc)
elseif filereadable(".vimrc.custom")
	so ".vimrc.custom"
endif

" Insert license information according to a directory or repository-specific .licenseinfo file
function! Insert_licenseinfo()
	let licenseinfo_file = Get_git_toplevel() . ".licenseinfo"
	if filereadable(".licenseinfo")
		exec '0read .licenseinfo'
		exec '$'
	elseif filereadable(fnameescape(licenseinfo_file))
		exec '0read '.fnameescape(licenseinfo_file)
		exec '$'
	endif
endfunction
" Automatically insert license info when creating a new source file
"augroup licenseinfo
"	autocmd!
"	autocmd BufNewFile *.{c,h,py,sh} call Insert_licenseinfo()
"augroup END

" Recognize m4 macro files in the Android tree
"augroup seandroid_macros
"	autocmd!
"	autocmd BufEnter * if @% =~# '_macros$' | set ft=m4 | endif
"augroup END

" Toggle color scheme
function! Toggle_color()
	if g:colors_name == "gruvbox"
		colorscheme default
	elseif g:colors_name == "default"
		colorscheme gruvbox
		set background=dark
	endif
endfunction
nnoremap <F1> :call Toggle_color() <CR>

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
" Disabled to work in Magneti Marelli without always breaking everything
"nmap <silent> <F2> :call Format() <CR>

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

" Markdown stuff
augroup markdown
	autocmd!
	" Recognize Markdown files
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown
	" Enable fenced code block syntax highlighting
	let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'shell=sh', 'c', 'Makefile=make']
augroup END

" View a currently open buffer in a vertical split
:command -nargs=1 -complete=buffer Vsb vertical sb <args>
" Override the non-existing builtin :vsb command to call our Vsb command
:cabbrev vsb <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Vsb' : 'vsb')<CR>
