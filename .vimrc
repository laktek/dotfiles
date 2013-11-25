" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=100		" keep 100 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Keep all backup files in one location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

execute pathogen#infect()

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
" vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

	autocmd BufWritePre *.js :%s/\s\+$//e

	autocmd BufWritePost *.go :silent Fmt

else
  set autoindent		" always set autoindenting on
endif

if has("folding")
  set foldenable
  set foldmethod=syntax
  set foldlevel=1
  set foldnestmax=3
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '

  " automatically open folds at the starting cursor position
  " autocmd BufReadPost .foldo!
endif

"------------------------------------------------------------------------------
"" whitespaces
"
set autoindent
set smartindent
set smarttab     " smarter tab levels
set nowrap       " don't wrap lines
set textwidth=0
set shiftwidth=2 " autoindent is two spaces
set softtabstop=2
set tabstop=2    " a tab is two spaces
set expandtab    " use spaces, not tabs
set backspace=indent,eol,start " backspace through everything

set list
set listchars=""          " reset listchars
set listchars=tab:‣\      " display tabs with a sign
set listchars+=trail:·    " display trailing whitespaces with a dot
set listchars+=extends:»  " right wrap
set listchars+=precedes:« " left wrap

" Set leader key to ','
let mapleader = ","

" Always display the status line
set laststatus=2

" Hide search highlighting
map ,nh :nohls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: ,e
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: ,t
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" No Help, please
nmap <F1> <Esc>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Toggles NERDTree
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" set the current directory to the working buffer
map <leader>cd :cd %:p:h<CR>

" Display extra whitespace
"set listchars=tab:>-,trail:·,eol:$
"nmap <silent> <leader>s :set nolist!<CR>

" Edit routes
command! Rroutes :e config/routes.rb
command! RTroutes :tabe config/routes.rb

" Run Cucumber Tests
command! Rcumber :!cucumber %

" open snippets files
map ,sv :tabe "~/projects/snippets/vim.txt"
map ,sg :tabe "~/projects/snippets/git.txt"
map ,sr :tabe "~/projects/snippets/ruby.txt"

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Use Ag for code search
let g:agprg = 'ag --nogroup --nocolor --column'

" Color scheme
syntax enable
set background=dark
colorscheme solarized
" colorscheme vividchalk
" highlight NonText guibg=#060606
" highlight Folded  guibg=#0A0A0A guifg=#9090D0

" set font
set gfn=Inconsolata:h13

" Numbers
set number
set numberwidth=5

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
 
" Smart Paste
function! SmartPasteSelection(insertMode)
  let s:old_col = col(".")
  let s:old_lnum = line(".")
  " Correct the cursor position
  exec 'normal "+gP'
  if a:insertMode
    exec 'normal x'
  endif
  let s:after_col = col(".")
  let s:after_col_end=col("$")
  let s:after_col_offset=s:after_col_end-s:after_col
  let s:after_lnum = line(".")
  let s:cmd_str='normal V'
  if s:old_lnum < s:after_lnum
    let s:cmd_str=s:cmd_str . (s:after_lnum - s:old_lnum) . "k"
  elseif s:old_lnum> s:after_lnum
    let s:cmd_str=s:cmd_str . (s:old_lnum - s:after_lnum) . "j"
  endif
  let s:cmd_str=s:cmd_str . "="
  exec s:cmd_str
  let s:new_col_end=col("$")
  call cursor(s:after_lnum, s:new_col_end-s:after_col_offset)
  if a:insertMode
    if s:after_col_offset <=1
      exec 'startinsert!'
    else
      exec 'startinsert'
    endif
  endif
endfunction

" Use CTRL-V for pasting, also in Insert mode
nmap <C-V> :call SmartPasteSelection(0)<CR>
imap <C-V> #<Esc>:call SmartPasteSelection(1)<CR>

" Toggle spell-checking
:map <F5> :setlocal spell! spelllang=en_us<CR>

" clojure editor
let vimclojure#NailgunClient = "/home/lakshan/projects/hobby/clojure/vimclojure-2.1.1/ng"
let clj_want_gorilla = 1

" code folding for JS
function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen

" code folding for CoffeeScript
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable

" code for auto-formatting Go files
set rtp+=$GOROOT/misc/vim

" syntax highlighting for less
au BufNewFile,BufRead *.less set filetype=less

" Disable beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
