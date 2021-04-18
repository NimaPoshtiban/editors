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



"-------Mappings--------"



