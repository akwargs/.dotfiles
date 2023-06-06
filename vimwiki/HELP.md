 - `:help vimwiki-commands` -- List all commands.
 - `:help vimwiki`          -- General vimwiki help docs.

- `<Leader>ww`  -- Open default wiki index file.
- `<Leader>wt`  -- Open default wiki index file in a new tab.
- `<Leader>ws`  -- Select and open wiki index file.
- `<Leader>wd`  -- Delete wiki file you are in.
- `<Leader>wr`  -- Rename wiki file you are in.
- `<Leader>wi`  -- Open diary index file.
- `<Leader>wn`  -- Goto to create new wiki page.

- `<Leader>w<Leader>w` -- Open diary wiki-file for today.
- `<Leader>w<Leader>t` -- Open diary wiki-file for today in a new tab.
- `<Leader>w<Leader>y` -- Open diary wiki-file for yesterday in the current wiki.
- `<Leader>w<Leader>m` -- Open diary wiki-file for tomorrow in the current wiki.

- `<Enter>`       -- Follow/Create wiki link.
- `<Shift-Enter>` -- Split and follow/create wiki link.
- `<Ctrl-Enter>`  -- Vertical split and follow/create wiki link.
- `<Backspace>`   -- Go back to parent(previous) wiki link.
- `<Tab>`         -- Find next wiki link.
- `<Shift-Tab>`   -- Find previous wiki link.

- `=`           -- Add header level. Create if needed.
- `-`           -- Remove header level.
- `[[`          -- Go to the previous header in the buffer.
- `]]`          -- Go to the previous header in the buffer.
- `[=`          -- Go to the previous header which has the same level as the header the
                   cursor is currently under.
- `]=`          -- Go to the next header which has the same level as the header the
                   cursor is currently under.
- `]u [u`       -- Go one level up -- that is, to the parent header of Go one level up
                   that is, to the parent header of.
- `+`           -- Create and/or decorate links.


- [ ] -- 0% complete
- [󰁻] -- 1-33% complete
- [󰁽] -- 34-66% complete
- [󰂁] -- 67-99% complete
- [󱟢] -- 100% complete

- `<C-Space>`   -- Toggle checkbox of a list item on/off.
- `gnt`         -- Find next unfinished task in the current page.
- `gl<Space>`   -- Remove checkbox from list item.
- `gL<Space>`   -- Remove checkboxes from all sibling list items.
- `gln`         -- Increase the "done" status of a list checkbox.
- `glp`         -- Decrease the "done" status of a list checkbox.
- `gll`         -- Increase the level of a list item.
- `gLl`         -- Increase the level of a list item and all child items.
- `glh`         -- Decrease the level of a list item.
- `gLh`         -- Decrease the level of a list item and all child items.
- `glr`         -- Renumber list items if the cursor is on a numbered list item.
- `gLr`         -- Renumber list items in all numbered lists in the whole file. Also
                   readjust checkboxes.
- `gl*`         -- Make a list item out of a normal line or change the symbol of the
                   current item to *.
- `gL*`         -- Change the symbol of the current list to *.
- `gl#`         -- Make a list item out of a normal line or change the symbol of the
                   current item to #.
- `gL#`         -- Change the symbol of the current list to #.
- `gl-`         -- Make a list item out of a normal line or change the symbol of the
                   current item to -.
- `gL-`         -- Change the symbol of the current list to -.
- `gl1`         -- Make a list item out of a normal line or change the symbol of the
                   current item to 1., the numbering is adjusted according to the
                   surrounding list items.
- `gL1`         -- Change the symbol of the current list to 1. 2. 3. ...
- `gla`         -- Make a list item out of a normal line or change the symbol of the
                   current item to a), the numbering is adjusted according to the
                   surrounding list items.
- `gLa`         -- Change the symbol of the current list to a) b) c) ...

- `glA`         -- Make a list item out of a normal line or change the symbol of the
                   current item to A), the numbering is adjusted according to the
                   surrounding list items.
- `gLA`         -- Change the symbol of the current list to A) B) C) ...

- `gli`         -- Make a list item out of a normal line or change the symbol of the
                   current item to i), the numbering is adjusted according to the
                   surrounding list items.
- `gLi`         -- Change the symbol of the current list to i) ii) iii) ...
- `glI`         -- Make a list item out of a normal line or change the symbol of the
                   current item to I), the numbering is adjusted according to the
                   surrounding list items.
- `gLI`         -- Change the symbol of the current list to I) II) III) ...
- `glx`         -- Toggle checkbox of a list item disabled/off.
- `gqq` or `gww`  -- Reformats table after making changes.
- `gq1` or `gw1`  -- Fast format table. The same as the previous, except or that only
                     a few lines above the current line are tested. If the alignment
                     of the current line differs, then the whole table gets
                     reformatted.
- `<A-Left>`    -- Move current table column to the left.
- `<A-Right>`   -- Move current table column to the right.
- `<C-Up>`      -- Open the previous day's diary link if available.
- `<C-Down>`    -- Open the next day's diary link if available.


These mappings are disabled by default.
See `|g:vimwiki_key_mappings|` to enable.

Note: `<2-LeftMouse>` is just left double click.
- `<2-LeftMouse>`       Follow wiki link (create target wiki page if needed).
- `<S-2-LeftMouse>`     Split and follow wiki link (create target wiki page if
                        needed).
- `<C-2-LeftMouse>`     Vertical split and follow wiki link (create target
                        wiki page if needed).
- `<RightMouse><LeftMouse>` Go back to previous wiki page.

- `<CR>`                In a list item, insert a new bullet or number in the
                        next line, numbers are incremented.
                        In an empty list item, delete the item symbol. This is
                        useful to end a list, simply press <CR> twice.
                        See `|vimwiki-lists|` for details and for how to
                        configure the behavior.

- `<S-CR>`              Does not insert a new list item, useful to create
                        multilined list items. See `|vimwiki-lists|` for
                        details and for how to configure the behavior. The
                        default map may not work in all terminals and may
                        need to be remapped.

- `<C-T>`               Increase the level of a list item.

- `<C-D>`               Decrease the level of a list item.

- `<C-L><C-J>`          Change the symbol of the current list item to the next
                        available. From - to 1. to * to I) to a).

- `<C-L><C-K>`          Change the symbol of the current list item to the prev
                        available. From - to a) to I) to * to 1.

- `<C-L><C-M>`          Create/remove a symbol from a list item.
                        Remap command: `<Plug>VimwikiListToggle`

- `ah`                  A header including its content up to the next header.

- `ih`                  The content under a header (like 'ah', but excluding
                        the header itself and trailing empty lines).

- `aH`                  A header including all of its subheaders. When [count]
                        is 2, include the parent header, when [count] is 3,
                        the grandparent and so on.

- `iH`                  Like 'aH', but excluding the header itself and
                        trailing empty lines.

Examples:

- type `cih` to change the content under the current header
- `daH` deletes an entire header plus its content including the content of all
  of its subheaders
- `v2aH` selects the parent header of the header the cursor is under plus all
  of the content of all of its subheaders

  - `a\`                      A cell in a table.
  - `i\`                      An inner cell in a table.
  - `ac`                      A column in a table.
  - `ic`                      An inner column in a table.
  - `al`                      A list item plus its children.
  - `il`                      A single list item.

Search

- Use `:VWS` /term/ to search.
- Use `:lopen` to see all results

  - `:Vimwiki2HTML`          -- Convert current wiki link to HTML.
  - `:VimwikiAll2HTML`       -- Convert all your wiki links to HTML.

