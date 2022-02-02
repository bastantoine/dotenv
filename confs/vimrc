""""""""""""""
"" PURE VIM
""""""""""""""
syntax on
set number
colorscheme desert

" Install vim-plug if not found, from https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Enable some vim-airline plugins
" run :PlugInstall after adding a new one
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
call plug#end()

" Allow vim-airline to use powerline fonts
" Fonts installed from https://github.com/powerline/fonts
let g:airline_powerline_fonts = 1

""""""""""""""""
"" FZF IN VIM
""""""""""""""""
set rtp+=/usr/local/opt/fzf

"""""""""""""""""""""
"" NERDTREE config
"""""""""""""""""""""

" Configure the icons used. The followings are not Windows compatible
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Open NERDTree using Ctrl+n
map <C-n> :NERDTreeToggle<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Start NERDTree on VIM launch and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Automatically close vim when NERDTree is the only tab left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

