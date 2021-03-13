set termguicolors
" colorscheme torte - not in use for now

" Own
set number
syntax on
color industry
set encoding=utf-8

" Display
set ls=2
set showmode
set showcmd
set modeline
set ruler
set title
" set nu

" Line wrapping
set nowrap
set linebreak
set showbreak=▹

" Auto indent what you can
set autoindent

" Searching
set ignorecase
set smartcase
set gdefault
set hlsearch
set showmatch

" Enable jumping into files in a search buffer
set hidden

" Make backspace a bit nicer
set backspace=eol,start,indent

" Indentation
set shiftwidth=4
set tabstop=4
set softtabstop=4
set shiftround
set expandtab

" j0eji
" experimental
let mapleader = "\<Space>"
" Toggle whitespace visibility with ,s
nmap <Leader>s :set list!<CR>
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×
:set list " Enable by default

" <Leader>L = Toggle line numbers
map <Leader>L :set invnumber<CR>

filetype indent on
filetype plugin on
set autoindent

" set indent to 4 spaces
" Experimental change
" set noexpandtab
" set copyindent
" set preserveindent
" set softtabstop=0
" set shiftwidth=4
" set tabstop=4

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" F2 = Paste Toggle (in insert mode, pasting indented text behavior changes)
set pastetoggle=<F2>

" <Leader>v = Paste
map <Leader>v "+gP

" <Leader>c = Copy
map <Leader>c "+y

" Annoying window
map q: :q

" Prevent cursor from moving to beginning of line when switching buffers
set nostartofline

" H = Home, L = End
noremap H ^
noremap L $
vnoremap L g_

" Clear search highlights when pressing <Leader>b
nnoremap <silent> <leader>b :nohlsearch<CR>

" http://www.vim.org/scripts/script.php?script_id=2572
" <Leader>a will open a prmompt for a term to search for
noremap <leader>a :Ack

"type S, then type what you're looking for, a /, and what to replace it with
nmap S :%s//g<LEFT><LEFT>
vmap S :s//g<LEFT><LEFT>

"------  Text Editing Utilities  ------
" <Leader>T = Delete all Trailing space in file
map <Leader>T :%s/\s\+$//<CR>

" <Leader>U = Deletes Unwanted empty lines
map <Leader>U :g/^$/d<CR>

" <Leader>R = Converts tabs to spaces in document
map <Leader>R :retab<CR>

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif