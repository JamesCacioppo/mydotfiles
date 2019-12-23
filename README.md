## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)

## About

These are my dot files.  They're meant to be deployed on a Mac but with a small
ammount of modification they should work on Linux as well.  My bash profile
includes some aliases and functions for making basic opperations simpler.  The
.vimrc file includes a bunch of settings and plugins to supercharge your VIM
experience, of which some of the best are NERDtree, Ripgrep, and Fuzzy Finder.

## Quick Start

1. Install Xcode from App Store.  Xcode will come with git and bash-completion. Start this first since it takes for ever.

2. Install oh-my-zsh

    ` export ZSH="$HOME/.oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

3. Install Vim-Plug

    ` curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

4. Install Vundle

    ` git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

5. Install fzf

    ` brew install fzf`

6. Install ripgrep

    ` brew install ripgrep`

7. Install tmux

    ` brew install tmux`    

8. Clone this repo which is just about the best stable config of tmux ever...

    - One option is to get this from gpakosz directly 

    ` git clone https://github.com/gpakosz/.tmux.git`

    - Another option is to get a copy from my fork so you have my key bindings. If you go this route you should get iterm2 and set opt keys to Esc+ in Preferences->Profiles->Keys.

    ` git clone https://github.com/JamesCacioppo/.tmux.git`

    - Then copy the files into place

    ` cd .tmux && cp .tmux* ~/`

9. Clone this repo and copy dot files into place

    - You can symlink the dot files to the local repo for easier management (suggested)

    ```
    git clone https://github.com/JamesCacioppo/mydotfiles.git
    cd ~/; ln -sv ~/Documents/repos/mydotfiles/.zshrc .
    ```
    - Alternatively you can copy the dot files into place

    ```
    git clone https://github.com/JamesCacioppo/mydotfiles.git
    cd mydotfiles && export GLOBIGNORE=.git && cp .* ~/
    ```

10. Run vim and install the plugins

    ```
    :PlugInstall
    :PluginInstall
    ```

11. Install Karabiner

    - Visit https://pqrs.org/osx/karabiner/index.html to download and install Karabiner then copy the config into place.

    ```
    cd ~/.confg/karabiner/; ln -sv ~/Documents/repos/mydotfiles/karabiner.json .
    ```
