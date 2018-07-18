" Vim syntax file
" Language:			Legato API
" Author:			Filippo Bonazzi <filippo.bonazzi@zirak.it>
" Latest Revision:	201807181409

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" Read the javacc syntax to start with
"if version < 600
"  so <sfile>:p:h/javacc.vim
"else
"  runtime! syntax/javacc.vim
"  unlet b:current_syntax
"endif

" Keywords codelanguage-def[API]
" Basic types
syn keyword fType                int8 uint8 int16 uint16 int32 uint32 int64 uint64 double string file skipwhite
syn keyword fType_deprecated     handler skipwhite
" From legato.h
syn keyword fType				 le_result_t le_onoff_t skipwhite
" Enum, bitmask
syn keyword fStructure           ENUM BITMASK skipwhite
" Define
syn keyword syntaxElementKeyword DEFINE skipempty skipwhite
" Reference
syn keyword fStructure			 REFERENCE skipempty skipwhite
" Handler
syn keyword fStructure			 HANDLER skipempty skipwhite
" Function
syn match fFuncDef "FUNCTION\s\+[\h][\w\d]\+\s\+[$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*(.*)[ \t]*;" transparent contains=fFuncBlock
syn region fFuncBlock start="(" end=")" fold transparent contained
syn keyword syntaxElementKeyword FUNCTION skipempty skipwhite
syn keyword syntaxElementKeyword IN OUT skipempty skipwhite
" Event
syn keyword syntaxElementKeyword EVENT skipempty skipwhite
" Include definitions from other files
syn keyword syntaxElementKeyword USETYPES skipempty skipwhite

syn keyword fTodo      contained TODO FIXME XXX NOTE

hi def link fType       Type
hi def link fTodo       Todo
hi def link fStructure  Structure
hi def link syntaxElementKeyword Keyword
hi def link fType_deprecated Error

let b:current_syntax = "api"

