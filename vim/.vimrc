filetype indent plugin on
set background=dark
set encoding=utf-8
syntax on
set hidden
set viminfo+=n~/.dotfiles/vim/viminfo
set wildmenu
set showcmd
set nohlsearch
set incsearch
set ignorecase
set backspace=indent,eol,start
set autoindent
set mouse=a
set cmdheight=2
set number relativenumber
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autochdir
set showmatch
set autoread
set scrolloff=3
set updatecount=100
set spl=en spell
set nospell
augroup SpellCheck
    autocmd!
    autocmd FileType text,txt,latex,tex,md,markdown setlocal spell
augroup END

function! Mosh_Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
endfunction
inoremap <Tab> <C-R>=Mosh_Tab_Or_Complete()<CR>

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'ycm-core/YouCompleteMe'
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
Plug 'preservim/nerdtree'
Plug 'lervag/vimtex'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
let g:bufferline_echo = 0
let g:tex_flavor='latex'
let g:vimtex_compiler_latexmk = {
            \'options' : [
            \   '--shell-escape'
            \],
   \}
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
call plug#end()

colorscheme nord

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"
