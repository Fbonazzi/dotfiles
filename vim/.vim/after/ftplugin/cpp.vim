" Formatter
" MM: Kernighan & Ritchie with 4-space tabs
" Flags for Astyle 2.03
" -j is --add-braces (unsupported in Astyle 2.03)
" let b:formatter="astyle --mode=c --style=kr --indent=tab=4 -j --indent-namespaces --indent-col1-comments --pad-oper --unpad-paren --pad-header --align-pointer=type --close-templates"
let b:formatter="astyle --mode=c --style=kr --indent=tab=4 -j --indent-col1-comments --pad-oper --unpad-paren --pad-header --align-pointer=type --close-templates"
