" TODO: why doesn't this load automatically?"

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

if has('gui_running')
  call SourceIfExists($NVIM_QT_RUNTIME . "/runtime/plugin/nvim_gui_shim.vim")

  if has('unix')
    set guifont="JetBrainsMonoNL_Nerd_Font_Mono:h10:l"
  endif

  if has('win32')
    set guifont="JetBrainsMonoNL_NFM_Light:h10:l"
  endif

  set mouse=a
  if exists(':GuiTabline')
    GuiTabline 1
  endif

  if exists(':GuiPopupmenu')
    GuiPopupmenu 0
  endif

  if exists(':GuiScrollBar')
    GuiScrollBar 1
  endif

  try
    colorscheme mymountaineer-light
  endtry

  " Right Click Context Menu (Copy-Cut-Paste)
  nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
  inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
  xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
  snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
endif
