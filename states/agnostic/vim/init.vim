if &compatible
  set nocompatible
endif

let mapleader=","

set mouse=""
set encoding=utf-8

set title
set nowrap

set cursorline
set cursorcolumn

set tabstop=2
set shiftwidth=2
set shiftround
set softtabstop=2
set expandtab

set backspace=indent,eol,start

set autoindent
set copyindent

set number
set relativenumber

set showmatch
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch

map <CR> :nohl<cr>

"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
"augroup ProjectDrawer
""  autocmd!
""  autocmd VimEnter * :Vexplore
"augroup END

nmap <leader>t :NERDTree<cr>
map <silent> <C-n> :NERDTreeFocus<CR>


" Required:
set runtimepath+={{ grains.homedir }}/.dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('{{ grains.homedir }}/.dein')
  call dein#begin('{{ grains.homedir }}/.dein')

  " Let dein manage dein
  " Required:
  call dein#add('{{ grains.homedir }}/.dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/denite.nvim')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  call dein#add('Shougo/deoplete.nvim')

  " UI
  call dein#add('chriskempson/base16-vim')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('scrooloose/nerdtree')

  " Finders
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  " Fluent Editing
  call dein#add('Raimondi/delimitMate')
  call dein#add('scrooloose/nerdcommenter')

  " Git
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')

  " Only load language files when inside a file of that language
  call dein#add('sheerun/vim-polyglot')

  " Neomake
  call dein#add('neomake/neomake')
  " Run Neomake when I save any buffer
  augroup localneomake
    autocmd! BufWritePost * Neomake
  augroup END
  let g:neomake_markdown_enabled_makers = []


  " Elixir
  let g:neomake_elixir_enabled_makers = ['dccredo']
  function! NeomakeCredoErrorType(entry)
    if a:entry.type ==# 'F'
      let l:type = 'W'
    elseif a:entry.type ==# 'D'
      let l:type = 'I'
    elseif a:entry.type ==# 'W'
      let l:type = 'W'
    elseif a:entry.type ==# 'R'
      let l:type = 'I'
    elseif a:entry.type ==# 'C'
      let l:type = 'W'
    else
      let l:type = 'M'
    endif
    let a:entry.type = l:type
  endfunction

  let g:neomake_elixir_dccredo_maker = {
        \ 'exe': 'docker-compose',
        \ 'args': ['run', '--rm', 'api', 'credo', 'list', '%:p', '--format=oneline'],
        \ 'errorformat': '[%t] %. %f:%l:%c %m,[%t] %. %f:%l %m',
        \ 'postprocess': function('NeomakeCredoErrorType')
        \ }

  call dein#add('elixir-lang/vim-elixir')
  call dein#add('slashmili/alchemist.vim')
  call dein#add('c-brenn/phoenix.vim')
  call dein#add('tpope/vim-projectionist')

  " SaltStack
  call dein#add('saltstack/salt-vim')

  "
  call dein#add('powerman/vim-plugin-AnsiEsc')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end
" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" tern
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>

let g:airline_powerline_fonts = 1
let g:airline_theme='base16_eighties'

" Fuzzy-find with fzf
map <C-p> :Files<cr>
nmap <C-p> :Files<cr>

" View commits in fzf
nmap <Leader>c :Commits<cr>
" Complete from open tmux panes (from @junegunn)
inoremap <expr> <C-x><C-t> fzf#complete( 'tmuxwords.rb -all-but-current --scroll 499 --min 5')

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

let base16colorspace=256
set background=dark
syntax enable
colorscheme base16-materia

