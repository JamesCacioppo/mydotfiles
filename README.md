## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)

## About

These are my dot files.  My bash profile includes some aliases and functions for
making basic opperations simpler.  The .vimrc file includes a bunch of settings
and plugins to supercharge your VIM experience, of which some of the best are
NERDtree, Ripgrep, and Fuzzy Finder.

## Quick Start

1. Install Xcode from App Store.  Xcode will come with git and bash-completion. Start this first since it takes for ever.

2. Install Vim-Plug

    ` curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

3. Install Vundle

    ` git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

4. Install fzf

    ` brew install fzf`

5. Install ripgrep

    ` brew install ripgrep`

6. Install tmux

    ` brew install tmux`    

7. Clone this repo which is just about the best stable config of tmux ever...

    - One option is to get this from gpakosz directly 

    ` git clone https://github.com/gpakosz/.tmux.git`

    - Another option is to get a copy from my fork so you have my key bindings. If you go this route you should get iterm2 and set opt keys to Esc+ in Preferences->Profiles->Keys.

    ` git clone https://github.com/JamesCacioppo/.tmux.git`

    - Then copy the files into place

    ` cd .tmux && cp .tmux* ~/`

8. Clone this repo and copy dot files into place

    ```
    git clone https://github.com/JamesCacioppo/mydotfiles.git
    cd mydotfiles && export GLOBIGNORE=.git && cp .* ~/
    ```

9. Run vim and install the plugins

    ```
    :PlugInstall
    :PluginInstall
    ```
