source C:/Program\ Files/Neovim/share/nvim-qt/runtime/plugin/nvim_gui_shim.vim

set columns=130 lines=35
set guifont="JetBrains_Mono_NL_Light:h10:l"
set guioptions=gmtTlar
set mouse=a
set mousehide

if exists(':GuiPopupmenu')
  :GuiPopupmenu 1
endif

if exists(':GuiScrollBar')
  :GuiScrollBar 1
endif

if exists(':GuiTabline')
  :GuiTabline 1
endif

map <ScrollWheelUp>   <C-Y>
map <ScrollWheelDown> <C-E>
nmap <silent><RightMouse> :call GuiShowContextMenu()<CR>
imap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xmap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
smap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
