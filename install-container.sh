#!/bin/bash
#Prepare the base system by installing the necessary packages first.  Then
#install customizations like oh-my-zsh and Oh My Tmux!  Finally symlink all
#dotfiles to the repo.

# TODO: Ask for repoDir when running script
repoDir="$HOME/Documents/repos"
repoName="mydotfiles"
targetRepo="$repoDir/$repoName"
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
  mkdir -p "$repoDir"

  if [[ "$SCRIPTPATH" == "$targetRepo" ]]; then
    echo "Repo is already at $targetRepo."
    return
  fi

  if [[ -e "$targetRepo" ]]; then
    echo "$targetRepo already exists. Not moving $SCRIPTPATH over it."
    exit 1
  fi

  mv "$SCRIPTPATH" "$targetRepo"
}

installBrew() {
  if command -v brew >/dev/null 2>&1; then
    echo Homebrew is already installed.
    configureBrewShellenv
    loadBrewShellenv
    return
  fi

  if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    echo Homebrew is already installed.
    configureBrewShellenv
    loadBrewShellenv
    return
  fi

  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null
  configureBrewShellenv
  loadBrewShellenv
}

configureBrewShellenv() {
  touch /root/.zprofile
  grep -qxF 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' /root/.zprofile || \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.zprofile
}

loadBrewShellenv() {
  local brew_path

  if brew_path="$(command -v brew 2>/dev/null)"; then
    eval "$("$brew_path" shellenv)"
    return
  fi

  if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

bundleInstall() {
  echo Installing from Brewfile
  echo Executing -- brew bundle install
  brew bundle install --file=Brewfile.container
}

installOhMyZsh() {
  #first check to make sure zsh is def shell and set it if not
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  if [[ -n "$zsh_path" && "$SHELL" != "$zsh_path" ]]
  then
    chsh -s "$zsh_path"
  fi
  #set perms so oh my zsh will load completions
  for zsh_dir in /usr/local/share/zsh /usr/local/share/zsh/site-functions /home/linuxbrew/.linuxbrew/share/zsh /home/linuxbrew/.linuxbrew/share/zsh/site-functions; do
    [[ -d "$zsh_dir" ]] && chmod g-w,o-w "$zsh_dir"
  done
  #install zsh
  export ZSH="$HOME/.oh-my-zsh"
  if [[ -d "$ZSH" ]]; then
    echo Oh My Zsh is already installed.
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

installVimPlug() {
  curl -fsSLo ~/.vim/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

installVundle() {
  cloneRepo https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
}

installOhMyTmux() {
  echo Cloning Oh My Tmux!
  cloneRepo https://github.com/JamesCacioppo/.tmux.git "$repoDir/.tmux"
  echo Linking .tmux.conf and .tmux.conf.local
  linkFile "$repoDir/.tmux/.tmux.conf" "$HOME/.tmux.conf"
  linkFile "$repoDir/.tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
}

deployDotFiles() {
  echo Linking .zshrc
  linkFile "$targetRepo/.zshrc" "$HOME/.zshrc"
  echo Linking .bash_profile
  linkFile "$targetRepo/.bash_profile" "$HOME/.bash_profile"
  echo Linking .gitconfig
  linkFile "$targetRepo/.gitconfig" "$HOME/.gitconfig"
  echo Unsetting any global user configs
  git config --global --unset user.name || true
  git config --global --unset user.email || true
  echo Linking .vimrc
  linkFile "$targetRepo/.vimrc" "$HOME/.vimrc"
}

toolsRepo() {
  cloneRepo https://github.com/JamesCacioppo/tools.git "$repoDir/tools"
}

additionalUserConfig() {
		#Configure tab auto-completion for poetry
		if command -v poetry >/dev/null 2>&1; then
			mkdir -p "$ZSH_CUSTOM/plugins/poetry"
			poetry completions zsh > "$ZSH_CUSTOM/plugins/poetry/_poetry"
		fi
}

cloneRepo() {
  local source="$1"
  local destination="$2"

  if [[ -d "$destination/.git" ]]; then
    echo "$destination already exists. Updating with fast-forward only."
    git -C "$destination" pull --ff-only
  elif [[ -e "$destination" ]]; then
    echo "$destination exists and is not a git repo. Skipping clone from $source."
  else
    git clone "$source" "$destination"
  fi
}

linkFile() {
  local source="$1"
  local destination="$2"

  mkdir -p "$(dirname "$destination")"

  if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
    echo "$destination is already linked."
    return
  fi

  if [[ -e "$destination" || -L "$destination" ]]; then
    local backup
    backup="${destination}.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $destination to $backup"
    mv "$destination" "$backup"
  fi

  ln -sv "$source" "$destination"
}

main
