#!/bin/bash
#Prepare the base system by installing the necessary packages first.  Then
#install customizations like oh-my-zsh and Oh My Tmux!  Finally symlink all
#dotfiles to the repo.

# TODO: Ask for repoDir when running script
repoDir=~/Documents/repos

main() {
  checkDir
  moveRepo
  installBrew
  bundleInstall
  checkBundleSuccess
  installOhMyZsh
  installVimPlug
  installVundle
  installOhMyTmux
  deployDotFiles
  configVScodeScrolling
  toolsRepo

  echo Install routine complete.  Please verify that all packages have been
  echo successfully installed.
  echo -e "\nThe next step is to start vim and execute the following two commands:"
  echo -e ":PlugInstall\n:PluginInstall"
}

checkBundleSuccess() {
  brew bundle check
  if [[ $? == 0 ]]; then
    echo All Brewfile dependencies have been installed.
  else
    echo brew bundle check returned non-zero exit code.  There was a problem during installation.
    echo Exiting installation.
    exit 1
  fi
}

checkDir() {
  if [ -d ~/Documents/repos ]
  then
    cd ~/Documents/repos
  else
    mkdir -p ~/Documents/repos
    cd ~/Documents/repos
  fi
}

moveRepo() {
  SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
  echo Moving the mydotfiles repo to ~/Documents/repos. This is an idempotent action.
  mv $SCRIPTPATH ~/Documents/repos
}

installBrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

bundleInstall() {
  echo Installing from Brewfile
  echo Executing -- brew bundle install
  brew bundle install
}

installOhMyZsh() {
  #first check to make sure zsh is def shell and set it if not
  if [[ $PATH != /bin/zsh ]]
  then
    chsh -s /bin/zsh 
  fi
  #install zsh
  export ZSH="$HOME/.oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

installVimPlug() {
  curl -fLo ~/.vim/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

installVundle() {
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

installOhMyTmux() {
  echo Clonging Oh My Tmux!
  git clone https://github.com/JamesCacioppo/.tmux.git $repoDir/.tmux
  rm ~/.tmux.conf
  echo Linking .tmux.conf and .tmux.conf.local
  ln -sv ~/Documents/repos/.tmux/.tmux.conf ~/.tmux.conf
  ln -sv ~/Documents/repos/.tmux/.tmux.conf.local ~/.tmux.conf.local
}

deployDotFiles() {
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

configVScodeScrolling() {
  # Must change this global setting so that pressing and holding hjkl actually
  # allows scrolling
  defaults write -g ApplePressAndHoldEnabled -bool false
}

toolsRepo() {
  git clone https://github.com/JamesCacioppo/tools.git $repoDir/tools
}

installXcodeCommandLineTools() {
	xcode-select --install
	sleep 1
	osascript <<- EOD
	  tell application "System Events"
	    tell process "Install Command Line Developer Tools"
	      keystroke return
	      click button "Agree" of window "License Agreement"
	    end tell
	  end tell
	EOD
}

main
