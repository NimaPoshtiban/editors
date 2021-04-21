set nocompatible              "We want the latest vim settings/options"

so ~/.vim/plugins.vim

syntax enable

"-------Make backspace behave like every other editor."

set backspace=indent,eol,start                      
let mapleader = ','      "The default leader is \ but a comma is much better"
set number               "lets activate line numbers."




"-----Visuals------"

set linespace=15                           "gvim specific line-height."
colorscheme desert
set t_CO=256                                "set 256 colors, this is useful for terminal vim"
set guifont=Fira_code:h15

set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R




"-------searching--------"
set hlsearch         "highlights the searched word"
set incsearch        "incrementally search"

"-------Split Management--------"
set splitbelow              "New sp will be created below the first split"
set splitright              "New vsp will be created at the right side of the vim"

nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>
nmap <C-H> <C-W><C-H>

"-------Mappings--------"
"-------Make it easy to edit the vimrc file"
nmap <Leader>ev :tabedit  ~/.vimrc<cr>
"-------Add simple highlight removal"
nmap <Leader><space> :nohlsearch<cr>
"-------add simple NERDTreeToggle--------------"
nmap <C-\> :NERDTreeToggle<cr>

