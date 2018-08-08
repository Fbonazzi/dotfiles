" Set the formatter program
" Kernel
"let b:formatter="indent -nbad -bap -nbc -bbo -hnl -br -brs -c33 -cd33 -ncdb -ce -ci4 -cli0 -d0 -di1 -nfc1 -i8 -ip0 -l80 -lp -npcs -nprs -npsl -sai -saf -saw -ncs -nsc -sob -nfca -cp33 -ss -ts8 -il1"
" Kernighan & Ritchie (without -l75, with -l150) (with -nbfda) (without -ci4, with -ut and -ts4)
" let b:formatter="indent -nbad -bap -bbo -nbc -br -brs -c33 -cd33 -ncdb -ce -cli0 -cp33 -cs -d0 -di1 -nfc1 -nfca -hnl -i4 -ip0 -l150 -lp -npcs -nprs -npsl -saf -sai -saw -nsc -nsob -nss -nbfda -ut -ts4"
" MM: Kernighan & Ritchie with 4-space tabs
let b:formatter="astyle --mode=c --style=kr --indent=tab=4 --pad-oper --unpad-paren --pad-header --align-pointer=type"

" 80-character color column
setlocal colorcolumn=80
" show existing tab with 4 spaces width
set tabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4
" " On pressing tab, insert 4 spaces
set noexpandtab
