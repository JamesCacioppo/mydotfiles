" Vim settings section
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

" Pluggin section

call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Initialize plugin system
call plug#end()
