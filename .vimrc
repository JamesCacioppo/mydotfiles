"===========================Vim settings section==============================

set nocompatible "set by default. Compatible will disable features to make compatible with vi.
set nowrap "obvi
set wildmenu "enable that auto complete menu at bottom of screen
set wildmode=list:longest "something to do with the wildmenu
set visualbell "flash screen instead of audible bell
set scrolloff=3 "keep cursor from bottom or top 5 lines when scrolling if possible. set so=0 to restore
"TAB settings. These need to be turned off for Makefile
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab "expand tab just makes vim execute the above. Use :retab to fix existing tabs.

set showmode "show command vs insert always
set showcmd "show last command as you are typing
set hidden "something to do with unwritten buffers
syntax on "turn on syntax based coloring
set ttyfast "fast scrolling
set ruler "show row,column at bottom right of screen
"set backspace=indent,eol,start
set laststatus=2 "always show status line at bottom of window
set relativenumber "show line number relative to cursor. disable with `set norelativenumber`
set lazyredraw "helps with scrolling large files but may have delay issues when switching buffers
"set mouse=a "allow using mouse to move and click, disabled due to copy paste problem
set colorcolumn=80 "puts a vertical line out at 80 char for style guide
highlight ColorColumn ctermbg=235 guibg=#2c2d27 "sets the color of vertical guide

"Searching options
set ignorecase "kinda obvi, no?
set incsearch "search as char are entered
set hlsearch "highlight all terms

"NERDTree hacks
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeWinSize=50
let NERDTreeShowHidden=1

"Open and close NERDTree with ctrl+n
map <C-n> :NERDTreeToggle<CR>
"Auto close if NERDTree is last pane open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"Auto open if no file arguments provided at cli
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"======================Pluggin section for vim-plug===========================

call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()


"==============================Vundle Section==================================

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive' "git commands like :Gdiff and :Gstatus
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" nerdtree git plugin to show flags
Plugin 'Xuyuanp/nerdtree-git-plugin'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"==============================Configure ripgrep==============================

"" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

" This is what I got from github...
"command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

" This is what I got from Vinod...
"command! -bang -nargs=* Rg
"  \ call fzf#vim#grep(
"  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
"  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
"  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
"  \   <bang>0)

"==================================Keymaps====================================

"map ctrl-j to ctrl-d for page down
nmap <C-j> <C-d>
"map ctrl-k to ctrl-u for page up
nmap <C-k> <C-u>
