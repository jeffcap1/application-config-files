" set leader key to space
" let mapleader="<Space>"


" reclaim ctrl-p and reset to k (beekeeper specific issue)
nnoremap <C-p> k

" Yank to system clipboard
nnoremap <leader>y "*y
vnoremap <leader>y "*y

" Keep visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Better defaults for Y and J
nnoremap Y yg$
nnoremap J mzJ`z

" Paste over a visual selection without replacing the current register
vnoremap p "_dP

