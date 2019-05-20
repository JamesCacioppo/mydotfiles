## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)

## About

These are my dot files.  My bash profile includes some aliases and functions for
making basic opperations simpler.  The .vimrc file includes a bunch of settings
and plugins to supercharge your VIM experience. 

## Quick Start

1. Install Vim-Plug

    ` curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

2. Install Vundle

    ` git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

3. Install fzf

    ` brew install fzf`

4. Install ripgrep

    ` brew install ripgrep`

5. Clone this repo and copy dot files into place

    ```
     git clone https://github.com/JamesCacioppo/mydotfiles.git
     cp .* ~/
    ```

6. Run vim and install the plugins

    ```
    :PlugInstall
    :PluginInstall
    ```
