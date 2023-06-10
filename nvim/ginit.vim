set mouse=a
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    GuiFont! "JetBrainsMonoNL NFM:h12"
endif

" TODO: why doesn't this load automatically?"
:source C:/Program\ Files/Neovim/share/nvim-qt/runtime/plugin/nvim_gui_shim.vim

if exists(':GuiTabline')
    GuiTabline 0
endif

if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

