## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)

## About

These are my dot files.  They're meant to be deployed on a Mac but with a small
ammount of modification they should work on Linux as well.  My bash profile
includes some aliases and functions for making basic opperations simpler.  As 
Apple has moved on to zsh I've largedly abandoned the bash profile, however.  My
zsh config uses Oh-My-Zsh which is quite complete and fantastic.  Do try it if 
you haven't.  The .vimrc file includes a bunch of settings and plugins to
supercharge your VIM experience, of which some of the best are NERDtree,
Ripgrep, and Fuzzy Finder.

## Quick Start

1. Install Xcode from App Store. You'll eventually need it run make.

2. Clone this repo to ~/Documents/repos. This part is important because the symlinking function expects this location.

    ```
    mkdir -p ~/Documents/repos; cd ~/Documents/repos
    git clone git@github.com:JamesCacioppo/mydotfiles.git
    ```

3. Run the install script. If you don't want a program installed, like Karabiner, then comment its function out of main()

    ```
    cd ~/Documents/repos/mydotfiles
    ./install.sh
    ```

4. Run vim and install the plugins

    ```
    :PlugInstall
    :PluginInstall
    ```

5. If you installed Karabiner you'll need to open it and edit OSX security settings.  Then configure Karabiner:

    ```
    cd ~/.confg/karabiner/; ln -sv ~/Documents/repos/mydotfiles/karabiner.json .
    ```
