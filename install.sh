#!/bin/bash

: '
Prepare the base system by installing the necessary packages first.  Then
install customizations like oh-my-zsh and Oh My Tmux!  Finally symlink all
dotfiles to the repo.
'

main() {
  _dir()
  _brew()
  _iterm()
  _git()
  _gcloud_sdk()
  _awscli()
  _docker()
  _terraform()
  _cmatrix()
  _derailed()
  _kubectl()
  _kubefwd()
  _dry()
  _minicom()
  _zsh()
  _vim-plug()
  _vundle()
  _fzf()
  _ripgrep()
  _tmux()
  _karabiner()
  _dotfiles()

  echo Install routine complete.  Please verify that all packages have been
  echo successfully installed.
  echo -e "\nThe next step is to start vim and execute the following two commands:"
  echo -e ":PlugInstall\n:PluginInstall"
}

_dir() {
  if [ -d ~/Documents/repo ]
  then
    cd ~/Documents/repo
  else
    mkdir -p ~/Documents/repo
    cd ~/Documents/repo
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
  brew install docker
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

_vundle() {
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
  cd ~/Documents/repo && git clone https://github.com/JamesCacioppo/.tmux.git
  rm ~/.tmux.conf
  echo Linking .tmux.conf
  ln -sv ~/Documents/repo/.tmux/.tmux.conf ~/.tmux.conf
}

_karabiner() {
  echo Installing Karabiner Elements
  brew cask install karabiner-elements
}

_dotfiles() {
  echo Linking .zshrc
  rm -f ~/.zshrc && ln -sv ~/Documents/repo/mydotfiles/.zshrc ~/.zshrc
  echo Linking .bash_profile
  rm -f ~/.bash_profile && ln -sv ~/Documents/repo/mydotfiles/.bash_profile ~/.bash_profile
  echo Linking .gitconfig
  rm -f ~/.gitconfig && ln -sv ~/Documents/repo/mydotfiles/.gitconfig ~/.gitconfig
  echo Linking .vimrc
  rm -f ~/.vimrc && ln -sv ~/Documents/repo/mydotfiles/.vimrc ~/.vimrc
  echo Linking karabiner.json
  rm -f ~/.config/karabiner/karabiner.json && \
    ln -sv ~/Documents/repo/mydotfiles/karabiner.json ~/.config/karabiner/karabiner.json
}

main