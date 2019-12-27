#!/bin/bash

: '
* install iTerm2
* install Homebrew
# install git
* install gcloud SDK
* install AWS cli
* install Docker
* brew install Terraform
* brew install cmatrix
* brew install derailed/k9s/k9s
* brew install kubectl
* brew install txn2/tap/kubefwd
* brew tap moncho/dry; brew install dry
* brew install minicom
* Check that zsh is default
** chsh -s /bin/zsh
** Install oh-my-zsh
'

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
