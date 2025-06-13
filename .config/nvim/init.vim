" DON'T DELETE TRAILING WHITESPACE IN THIS FILE!

call plug#begin()
    Plug 'dag/vim-fish'
    Plug 'jeffkreeftmeijer/vim-dim', { 'branch': 'main' }
    Plug 'machakann/vim-highlightedyank'
    Plug 'Raimondi/delimitmate'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'vim-scripts/ReplaceWithRegister'
call plug#end()

" add plugins that come with locally installed packages
set runtimepath+=/usr/share/vim/vimfiles

" make nvim use bash if started from fish
if &shell =~# 'fish$'
    set shell=bash
endif

" load included matchit_plugin
runtime macros/matchit.vim


" functions
" from vimcasts.org
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    " restore previous position, before the find function if that has been run
    if exists('b:__s')
        call cursor(b:__l, b:__c)
        let @/=b:__s
        unlet b:__l
        unlet b:__c
        unlet b:__s
    else
        let @/=_s
        call cursor(l, c)
    endif
endfunction

function! <SID>FindTrailingWhitespaces()
    if !exists('b:__s')
        let b:__l = line(".")
        let b:__c = col(".")
        let b:__s=@/
    endif
    let @/='\s\+$'
    norm n
endfunction


" general settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set autoindent
set linespace=3
set showcmd
set mouse=a
set ttimeout
set ttimeoutlen=10
set linebreak
set showbreak=…
set breakindent
set hidden
set hlsearch
set ignorecase
set smartcase
set relativenumber
set splitbelow
set inccommand=split
set wildmode=longest,list,full

" set cursor shape
set guicursor=i-ci-ve:ver20-blinkwait700-blinkoff400-blinkon250
            \,n-v-c:block-blinkon0,i-ci-ve:ver20-blinkon0
            \,r-cr:hor20-blinkon0,o:hor50-blinkon0

" color options
set background=light
" no termguicolors (use Emacs for real editing)
set notermguicolors
colorscheme dim

" always use system clipboard
set clipboard=unnamedplus

"" keybinds
let mapleader=' '

" general
nnoremap Y y$
nnoremap - g,
nnoremap _ g;
" use dot repetition in visual mode
vnoremap . :normal .<CR>

" buffer navigation
nnoremap <silent> <leader><Tab> :bn<CR>
nnoremap <silent> <leader><S-Tab> :bp<CR>
nnoremap <silent> <leader>x :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>b :buffer 
nnoremap <silent> <leader>B :buffers<CR>
nnoremap <leader>e :e 
nnoremap <leader>rc :vsplit $MYVIMRC<CR>

" simpler split commands
nnoremap <silent> <leader>s :vsplit<CR>
nnoremap <silent> <leader>vs :split<CR>

" auto-delete trailing whitespace
nnoremap <silent> <F3> :call <SID>FindTrailingWhitespaces()<CR>
nnoremap <silent> <leader><F3> :call <SID>StripTrailingWhitespaces()<CR>

" turn off search highlighting until next search
nnoremap <silent> <Esc> :nohlsearch<CR>

" insert blank links without entering insert mode
nnoremap <silent> ö :call append(line('.'),'')<CR>
nnoremap <silent> Ö :call append(line('.')-1,'')<CR>
nnoremap <leader>ö o<ESC>
nnoremap <leader>Ö O<ESC>

" window navigation with alt key
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap <silent> <A-c> :clo<CR>
nnoremap <silent> <S-A-c> :bp<bar>sp<bar>bn<bar>bd<bar>clo<CR>

" use up-down bindings like in my shell configuration
cnoremap <A-k> <Up>
cnoremap <A-j> <Down>

" delete word using ctrl or alt + backspace in command mode
cnoremap <A-BS> <C-W>
cnoremap <C-BS> <C-W>

" section navigation that works better with an ISO keyboard
nnoremap ( {
nnoremap ) }
onoremap ( {
onoremap ) }
vnoremap ( {
vnoremap ) }
nnoremap { (
nnoremap } )
onoremap { (
onoremap } )
vnoremap { (
vnoremap } )

" search for visually selected text in file
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"" plugin configuration
" delimitMate
let g:delimitMate_expand_cr = 1

" vim-highlightedyank
let g:highlightedyank_highlight_duration = 600
