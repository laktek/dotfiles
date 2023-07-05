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

" Display extra whitespace
set list
set listchars=""          " reset listchars
set listchars=tab:‣\      " display tabs with a sign
set listchars+=trail:·    " display trailing whitespaces with a dot
set listchars+=extends:»  " right wrap
set listchars+=precedes:« " left wrap

nmap <silent> <leader>s :set nolist!<CR>

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

" set the current directory to the working buffer
map <leader>cd :cd %:p:h<CR>

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

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

" Toggle spell-checking
:map <F5> :setlocal spell! spelllang=en_us<CR>

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

" syntax highlighting for less
au BufNewFile,BufRead *.less set filetype=less

" Disable beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

autocmd Filetype gitcommit setlocal spell textwidth=72

au BufNewFile,BufRead *.hamlc,*.hbs.haml,*.js.hamlbars set filetype=haml

" disable listchars for Go
" tab chars adds noise
autocmd FileType go set nolist

" enable goimports
let g:go_fmt_command = "goimports"

" run stylefmt on write
au BufWritePre *.css :Stylefmt

" press F2 to toggle paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Tsuquyomi TypeScript plugin
" let g:tsuquyomi_disable_default_mappings = 1
" map <buffer> <C-i> <Plug>(TsuquyomiReferences)
" map <buffer> <C-]> <Plug>(TsuquyomiDefinition)

" Configure Ale fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'deno', 'eslint'],
\   'typescript': ['deno', 'prettier'],
\}

" Only run ale for explicitly enabled languages
let g:ale_linters_explicit = 1

" Automatically fix files on save
let g:ale_fix_on_save = 1

" Enable Ale completion where available.
let g:ale_completion_enabled = 1

" Run rustfmt on save
let g:rustfmt_autosave = 1
