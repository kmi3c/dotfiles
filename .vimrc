" Small vim setup: monokai-chris (in .vim/colors), NERDTree, fzf file search, folding, pl/en spelling.
" Plugins come from vim-plug, which installs itself on the first start.

let s:plug = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug))
  silent execute '!curl -fsLo ' . s:plug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
call plug#end()

" --- basics -----------------------------------------------------------------
set encoding=utf-8
syntax on
filetype plugin indent on
set number
set expandtab tabstop=2 softtabstop=2 shiftwidth=2 autoindent
set hidden                      " switch buffers without saving (:b, :bn are used a lot)
set incsearch hlsearch ignorecase smartcase
set wildmenu wildmode=longest:full,full
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamedplus       " yank/paste with the system clipboard (vim-gtk3)
set undofile undodir=~/.vim/undo//
silent! call mkdir(expand('~/.vim/undo'), 'p')
" no permanent `set paste`: it turns autoindent off, and vim handles bracketed
" paste from the terminal by itself

" --- colours ----------------------------------------------------------------
set termguicolors
" monokai-chris: the look used for years (from vim-colorschemes), kept in .vim/colors
silent! colorscheme monokai-chris

" --- file tree: Ctrl+E toggles, \e shows the current file -------------------
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <leader>e :NERDTreeFind<CR>
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.swp$', '\~$', '^\.git$']

" --- search: Ctrl+P files, \b buffers, \g text in files (ripgrep) -----------
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>

" --- git: fugitive + gitgutter (changed lines in the sign column) ---------------
" fugitive dropped the old command names; keep them, they are in the fingers
command! Gblame Git blame
command! Gstatus Git
command! Gcommit Git commit
command! Glog Gclog
command! Gdiff Gdiffsplit
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gl :Gclog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :GitGutterToggle<CR>
set updatetime=300              " gitgutter refreshes the signs after this idle time

" --- folding by indent, files open unfolded: za toggles, zR/zM all ----------
set foldmethod=indent
set foldlevelstart=99

" --- spelling pl+en, off by default: F7 toggles, z= suggests -----------------
set spelllang=pl,en
nnoremap <F7> :setlocal spell!<CR>
inoremap <F7> <C-o>:setlocal spell!<CR>
