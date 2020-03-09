#!/bin/bash
#Prepare the base system by installing the necessary packages first.  Then
#install customizations like oh-my-zsh and Oh My Tmux!  Finally symlink all
#dotfiles to the repo.

# TODO: Ask for repoDir when running script
repoDir=~/Documents/repos

main() {
  _dir
  _brew
  _iterm
  _git
  _gcloud_sdk
  _awscli
  _docker
  _terraform
  _cmatrix
  _derailed
  _kubectl
  _kubefwd
  _dry
  _minicom
  _zsh
  _vim-plug
  _vundle
  _fzf
  _ripgrep
  _tmux
  _karabiner
  _dotfiles
  _wireshark
  _go
  _vscode
  _chrome
  _firefox
  toolsRepo
  _nmap
  _iproute2mac

  echo Install routine complete.  Please verify that all packages have been
  echo successfully installed.
  echo -e "\nThe next step is to start vim and execute the following two commands:"
  echo -e ":PlugInstall\n:PluginInstall"
}

_dir() {
  if [ -d ~/Documents/repos ]
  then
    cd ~/Documents/repos
  else
    mkdir -p ~/Documents/repos
    cd ~/Documents/repos
  fi
} #TODO: need to make sure we're running from ~/Documents/repo/mydotfiles or
# we'll have problems with later functions

_brew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

_iterm() {
#  curl -L https://iterm2.com/downloads/stable/latest --output /tmp/iterm.zip
#  unzip /tmp/iterm.zip
#  mv /tmp/iterm.app /Applications/
  brew cask install iterm2
}

_git() {
  brew install git
}

_gcloud_sdk() {
  brew cask install google-cloud-sdk
}

_awscli() {
  brew install awscli
}

_docker() {
  #Does this install everything needed like downloading and installing from web?
  brew cask install docker
}

_terraform() {
  brew install terraform
}

_cmatrix() {
  brew install cmatrix
}

_derailed() {
  brew install derailed/k9s/k9s
}

_kubctl() {
  brew install kubectl
}

_kubefwd() {
  brew install txn2/tap/kubefwd
}

_dry() {
  brew tap moncho/dry; brew install dry
}

_minicom() {
  #minicom is a utility for opening a tty console to Cisco using usb console port
  brew install minicom
}

_zsh() {
  #first check to make sure zsh is def shell and set it if not
  if [[ $PATH != /bin/zsh ]]
  then
    chsh -s /bin/zsh 
  fi
  #install zsh
  export ZSH="$HOME/.oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

_vim-plug() {
  curl -fLo ~/.vim/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

vundle() {
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

_fzf() {
  brew install fzf
}

_ripgrep() {
  brew install ripgrep
}

_tmux() {
  echo Installing tmux
  brew install tmux
  echo Clonging Oh My Tmux!
  git clone https://github.com/JamesCacioppo/.tmux.git $repoDir/.tmux
  rm ~/.tmux.conf
  echo Linking .tmux.conf and .tmux.conf.local
  ln -sv ~/Documents/repos/.tmux/.tmux.conf ~/.tmux.conf
  ln -sv ~/Documents/repos/.tmux/.tmux.conf.local ~/.tmux.conf.local
}

_karabiner() {
  echo Installing Karabiner Elements
  brew cask install karabiner-elements
}

_wireshark() {
  echo Installing Wireshark
  brew cask install wireshark
}

_go() {
  echo Installing go
  brew install go
}

_vagrant() {
  echo Installing Vagrant
  brew cask install vagrant
}

_dotfiles() {
  echo Linking .zshrc
  rm -f ~/.zshrc && ln -sv ~/Documents/repos/mydotfiles/.zshrc ~/.zshrc
  echo Linking .bash_profile
  rm -f ~/.bash_profile && ln -sv ~/Documents/repos/mydotfiles/.bash_profile ~/.bash_profile
  echo Linking .gitconfig
  rm -f ~/.gitconfig && ln -sv ~/Documents/repos/mydotfiles/.gitconfig ~/.gitconfig
  echo Linking .vimrc
  rm -f ~/.vimrc && ln -sv ~/Documents/repos/mydotfiles/.vimrc ~/.vimrc
# We need a fix for the following.  Karabiner dir isn't created until it's started for the
# first time and we can't start it for the first time until we modify security settings.
# We may be able to just make the dir but then karabiner.json might be overwritten (doubt it).
#  echo Linking karabiner.json
#  rm -f ~/.config/karabiner/karabiner.json && \
#    ln -sv ~/Documents/repos/mydotfiles/karabiner.json ~/.config/karabiner/karabiner.json
}

_vscode() {
  brew cask install visual-studio-code
  # Must change this global setting to that pressing and holding hjkl actually
  # allows scrolling
  defaults write -g ApplePressAndHoldEnabled -bool false
  #TODO Figure out how to include VSCODE settings
}

_chrome() {
  brew cask install google-chrome
}

_firefox() {
  brew cask install firefox
}

toolsRepo() {
  git clone https://github.com/JamesCacioppo/tools.git $repoDir/tools
}

_nmap() {
  brew install nmap
}

_iproute2mac() {
  brew install iproute2mac
}

main
