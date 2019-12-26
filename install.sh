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
* brew install derailed/k8s/k8s
* brew install kubectl
* brew install txn2/tap/kubefwd
* brew tap moncho/dry; brew install dry
* brew install minicom
* Check that zsh is default
** chsh -s /bin/zsh
** Install oh-my-zsh
'

_iterm() {
  curl -L https://iterm2.com/downloads/stable/latest --output /tmp/iterm.zip
  unzip /tmp/iterm.zip
  mv /tmp/iterm.app /Applications/
}

_brew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
