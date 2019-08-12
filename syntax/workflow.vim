" GitHub Actions Workflow (.workflow) syntax file
" Language:     GitHub Actions Workflow
" Last change:  2019 Aug 12

" Usage:
"   1. Copy this file to ~/.vim/syntax/workflow.vim
"   2. Detect workflow filetypes in ~/.vim/syntax/ftdetect/workflow.vim:
" >
" au BufNewFile,BufRead *.workflow setfiletype workflow
" <
"   3. Enable syntax in your vimrc:
" >
" syntax enable
" <


if exists("b:current_syntax")
  finish
endif

syn case match

syn keyword  gfTask        action
syn keyword  gfAttribute   workflow on resolves
syn keyword  gfAttribute   runs args needs secrets env uses

syn region      gfCommentL     start="//" end="$" keepend
syn region      gfCommentL     start="#" end="$" keepend
syn region      gfComment      start="/\*" end="\*/"
syn region      gfString       start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=gfInterp
syn region      gfRegex        start="m/" skip=+\\/+ end="/"
syn region      gfInterp       start=/\${/ end=/}/
syn match       gfNumbers      display transparent "\<\d\|\.\d" contains=gfNumber
syn match       gfNumber       display contained "\d\+[a-z]*"
syn match       gfBraces       "[{}\[\]]"

hi def link gfText Normal
hi def link gfTask Keyword
hi def link gfAttribute Statement
hi link gfString String
hi link gfRegex String
hi link gfNumber Number
hi def link gfCommentL pipComment
hi def link gfCommentL Comment
hi def link gfInterp Identifier
hi def link gfBraces Delimeter

let b:current_syntax = "workflow"
