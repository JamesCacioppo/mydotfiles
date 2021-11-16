#!/bin/bash
#Prepare the base system by installing the necessary packages first.  Then
#install customizations like oh-my-zsh and Oh My Tmux!  Finally symlink all
#dotfiles to the repo.

# TODO: Ask for repoDir when running script
repoDir=~/Documents/repos
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

main() {
  moveRepo
  installBrew
  bundleInstall
  checkBundleSuccess
  installOhMyZsh
  installVimPlug
  installVundle
  installOhMyTmux
  deployDotFiles
  toolsRepo
  additionalUserConfig

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

moveRepo() {
  echo Moving the mydotfiles repo to ~/Documents/repos. This is an idempotent action.
  mkdir -p ~/Documents/repos
  mv $SCRIPTPATH ~/Documents/repos/mydotfiles
}

installBrew() {
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" > /dev/null
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.zprofile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

bundleInstall() {
  echo Installing from Brewfile
  echo Executing -- brew bundle install
  brew bundle install --file=Brewfile.container
}

installOhMyZsh() {
  #first check to make sure zsh is def shell and set it if not
  if [[ $PATH != /bin/zsh ]]
  then
    chsh -s /bin/zsh 
  fi
  #set perms so oh my zsh will load completions
  chmod g-w,o-w /usr/local/share/zsh
  chmod g-w,o-w /usr/local/share/zsh/site-functions
  #install zsh
  export ZSH="$HOME/.oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

installVimPlug() {
  curl -fsSLo ~/.vim/autoload/plug.vim \
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
  echo Unsetting any global user configs
  git config --global --unset user.name
  git config --global --unset user.email
  echo Linking .vimrc
  rm -f ~/.vimrc && ln -sv ~/Documents/repos/mydotfiles/.vimrc ~/.vimrc
}

toolsRepo() {
  git clone https://github.com/JamesCacioppo/tools.git $repoDir/tools
}

additionalUserConfig() {
	#Configure tab auto-completion for poetry
	mkdir $ZSH_CUSTOM/plugins/poetry
	poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
}

main
