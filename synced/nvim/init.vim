set tabstop=4
set shiftwidth=4
set expandtab   " tab is 4 spaces instead

let verbose=1

" selection isnt lost after shifting it
vnoremap < <gv
vnoremap > >gv

" bind ESC to this
inoremap jj <Esc>

" split settings
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

let g:python3_host_prog = '/opt/homebrew/bin/python3'

" install: "pip install pynvim black isort"
" +++++++++++++++ Plugins ++++++++++++++
call plug#begin()

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } 
" Plug 'dense-analysis/ale'

call plug#end()


" +++++++++++++++  DEOPLETE configuration  +++++++++++++++
let g:deoplete#enable_at_startup = 1

" deoplete tab-complete :   if Completion proposal window is visible, tab will
" complete, else it works as a normal tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


" ++++++++++++++ ALE
let g:ale_fixers = {
\       '*': ['remove_trailing_lines', 'trim_whitespace'],
\       'python': ['black', 'isort'],
\}

