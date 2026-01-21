"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range

    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" function! CleverTab()
"    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
"       return "\<Tab>"
"    else
"       return "\<C-X>\<C-O>"
"    endif
" endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'} " CocInstall coc-pyright coc-rust-analyzer
Plug 'Yggdroot/indentLine'
Plug 'Konfekt/FastFold'

call plug#end()

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-@> coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set history=500

" Enable filetype plugins
set nocp
filetype plugin indent on

" Enable omnifunc for autocomplete
set omnifunc=syntaxcomplete#Complete
set completeopt+=menuone,noselect,noinsert
set pumheight=5
set shortmess+=c

" inoremap <Tab> <C-R>=CleverTab()<CR>

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/__pycache__/

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Show relative number with the line number at the current line and not 0
set relativenumber
set number

" Enable mouse
set mouse=a

" Add ruler
set colorcolumn=100
highlight ColorColumn ctermbg=2

" Enable spell check
" set spell

" Enable syntax highlighting
syntax enable

" Set regular expression engine automatically
set regexpengine=0

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

colorscheme slate
set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Line break on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" set foldmethod=indent
set nofen fdm=indent foldcolumn=3

" Key bindings
map <leader>h :noh<cr>
map <C-q> :quit<cr>
" map <leader>bD :Bclose<cr>:tabclose<cr>gT
" map <leader>ba :bufdo bd<cr>
map <C-k> :bnext<cr>
map <C-j> :bprevious<cr>

" map <C-w> :tabclose<cr>
noremap <C-t> :tabnew<cr>
noremap <C-l> :tabnext<cr>
noremap <C-h> :tabprevious<cr>
noremap <leader>1 :tabfirst<cr>
noremap <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/
" map <leader>tO :tabonly<cr>
" map <leader>tm :tabmove +1<cr>
nmap <leader>n :cnext<cr>
nmap <leader>p :cprevious<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Move a line of text using
nnoremap <C-S-Down> :m+1<cr>
vnoremap <C-S-Down> :m '>+1<CR>gv=gv

nnoremap <C-S-Up> :m-2<cr>
vnoremap <C-S-Up> :m '<-2<CR>gv=gv

" Delete trailing white space on save, useful for some filetypes
if has("autocmd")
    autocmd BufWritePre *.c,*.cpp,*.h,*.hpp,*.md,*.txt,*.js,*.py,*.sh :call CleanExtraSpaces()
endif
nmap <C-s> :call CleanExtraSpaces()<cr>:write<cr>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Highlighting trailing whitespaces
set list
set listchars=trail:\ "
highlight SpecialKey ctermfg=red ctermbg=red

" Netrw config
" Pattern to hide dot files/folders
let ghregex='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide = '.git/,__pycache__/'
let g:netrw_list_hide .= ',' . ghregex

function! NetrwMapping()
    nnoremap <buffer> ; <c-l>
    nnoremap <buffer> <C-l> :tabnext<cr>
    nmap <buffer> . gh
endfunction

autocmd FileType netrw call NetrwMapping()

" Terminal config
tnoremap <Esc> <C-W>N

function! TermConfig()
    setlocal notimeout ttimeout timeoutlen=100
    setlocal nospell
endfunction

autocmd TerminalWinOpen * call TermConfig()
