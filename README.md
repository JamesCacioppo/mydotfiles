## Table of Contents

- [About](#about)
- [Quick Start](#quick-start)

## About

These are my dot files.  They're meant to be deployed on a Mac but with a small
ammount of modification they should work on Linux as well.  My bash profile
includes some aliases and functions for making basic opperations simpler.  As 
Apple has moved on to zsh I've largedly abandoned the bash profile and long ago
migrated everything to my .zshrc.  My zsh config uses Oh-My-Zsh which is quite
complete and fantastic.  Do try it if you haven't.  The .vimrc file includes a
bunch of settings and plugins to supercharge your VIM experience, of which some
of the best are NERDtree, Ripgrep, and Fuzzy Finder.

Be advised that this will install Docker Desktop which will run automatically
at boot.  Docker Desktop uses a lot of RAM so you may want to disable this or
uninstall it completely.  There will be an error when you open a new terminal
if Docker Desktop is not running, however.

## Quick Start

2. Clone this repo to your local storage.  You can download it directly or you can clone it using git.

    ```
    git clone git@github.com:JamesCacioppo/mydotfiles.git
    ```

3. Run the install script. If you don't want a program installed, like Karabiner, then remove it from the Brewfile.

    ```
    cd mydotfiles
    ./install.sh
    ```

4. Run vim and install the plugins

    ```
    :PlugInstall
    :PluginInstall
    ```

5. If you installed Karabiner you'll need to open it and edit OSX security settings.  Then configure Karabiner:

    ```
    cp ~/Documents/repos/mydotfiles/karabiner.json ./.config/karabiner/
    ```

6. Install Settings Sync extension in VS Code and pull down settings

7. Configure iTerm for Tmux option keys.  The Tmux configs use the option + hjkl to navigate between panes.  Go to prefs -> Profiles -> Keys and set "Left Option Key" to "Esc+"
