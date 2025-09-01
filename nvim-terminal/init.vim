set clipboard=unnamedplus,unnamed
set cmdheight=0
set laststatus=0
set mouse=""
set shell=powershell\ -NoLogo
set wrap

function! Highlight()
  hi TerminalError cterm=underline ctermfg=124 gui=underline guifg=#af0000 guisp=Red
  hi TerminalGood  cterm=underline ctermfg=28 gui=underline guifg=#008700 guisp=Blue
  call matchadd('TerminalError', '\c\<\(admin\(istrative\)\=\(ly\)\= \)\=\(shut\)\=down\>', 0)
  call matchadd('TerminalError', '\c\<bad\>', 0)
  call matchadd('TerminalError', '\c\<blk\>', 0)
  call matchadd('TerminalError', '\c\<den\(y\|ies\|ied\)\>', 0)
  call matchadd('TerminalError', '\c\<disconnect\(ed\)\=\>', 0)
  call matchadd('TerminalError', '\c\<drop\(ped\|s\)\=\>', 0)
  call matchadd('TerminalError', '\c\<\(err-\)\=disabled\>', 0)
  call matchadd('TerminalError', '\c\<err\(ors\=\)\=\>', 0)
  call matchadd('TerminalError', '\c\<exceeded\>', 0)
  call matchadd('TerminalError', '\c\<expired\>', 0)
  call matchadd('TerminalError', '\c\<fail\(s\|ed\|ure\)\=\>', 0)
  call matchadd('TerminalError', '\c\<inaccessible\>', 0)
  call matchadd('TerminalError', '\c\<infinity\>', 0)
  call matchadd('TerminalError', '\c\<invalid\>', 0)
  call matchadd('TerminalError', '\c\<los\(t\|ing\)\>', 0)
  call matchadd('TerminalError', '\c\<mismatch\>', 0)
  call matchadd('TerminalError', '\c\<notconnect\>', 0)
  call matchadd('TerminalError', '\c\<reject\(ing\|ed\)\=\>', 0)
  call matchadd('TerminalError', '\c\<runts\>', 0)
  call matchadd('TerminalError', '\c\<timed\=-\=out\>', 0)
  call matchadd('TerminalError', '\c\<traceback\>', 0)
  call matchadd('TerminalError', '\c\<unreachable\>', 0)
  call matchadd('TerminalError', '\c\<unsynchronized\>', 0)
  call matchadd('TerminalError', '\c\<unusable\>', 0)
  call matchadd('TerminalError', '\c\<wrong\>', 0)
  call matchadd('TerminalGood', '\c\<allowed\>', 0)
  call matchadd('Normal', '\c\<up/down\>', 1)
endfunction

augroup Terminal
  au!
  au TermOpen * startinsert
  au TermOpen,TermEnter * call Highlight()
augroup END

highlight clear SpecialKey
highlight clear SignColumn
highlight clear FoldColumn
