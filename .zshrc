# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git terraform kubectl minikube alias-finder)
ZSH_ALIAS_FINDER_AUTOMATIC=false

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=~/go/bin:~/Documents/repos/tools:~/Library/Python/3.7/bin:$PATH
export PATH="${PATH}:${HOME}/.krew/bin" # Required to execute kubectl plugins installed by krew
alias ll="ls -al"
alias gs="git status"
alias gl="git log --oneline --graph --decorate"
# The following aliases depend on fzf.  `brew install fzf`
alias preview="fzf --preview 'cat {}'"
alias previewbinary="fzf --preview 'strings {}'"
alias preview100="fzf --preview 'head -100 {}'"
alias p="find . -type f | fzf --preview 'head -100 {}'"
alias vf="fzf --bind 'crtl-v:execute(vim {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"
alias vimf="vim \$(fzf)"
alias appsanywhere="sudo spctl --master-disable" # Pref> Sec&Priv > Allow apps from anywhere
alias appsnowhere="sudo spctl --master-enable"
alias socat='socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"'
alias chrome="docker run -e DISPLAY=192.168.225.32:0 --privileged jess/chrome"
alias dbs="bootstrap=`docker ps | grep bootstrap | awk '{print $1}'`; echo bootstrap = $bootstrap"
alias run_jenkins="cd ~/;docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts"
alias eval-ssh-agent='eval "$(ssh-agent -s)"'
alias speed-test-curl='curl -o /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'
alias speed-test-wget='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'
alias git-user='git config user.name'
alias git-email='git config user.email'
alias fix-xcode-cli='xcode-select --install'
alias teams_background='cd ~/Library/Application Support/Microsoft/Teams/Backgrounds/Uploads'
alias k='kubectl'

######################
# Goolge Cloud stuff #
######################

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jamescacioppo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jamescacioppo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jamescacioppo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jamescacioppo/google-cloud-sdk/completion.zsh.inc'; fi

## gssh functions
function _gcloud_ssh() {
    local instance=$(gcloud compute instances list | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
    if [[ -n $instance ]]; then
        echo "gcloud compute ssh $instance --internal-ip"
        eval "gcloud compute ssh $instance --internal-ip"
        return $?
    fi
}

#alias gssh=_gcloud_ssh #alias to Vinod's gssh function
#
#function _gcloud_stop() {
#    local instance=$(gcloud compute instances list | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
#    if [[ -n $instance ]]; then
#        echo "gcloud compute instances stop $instance"
#        eval "gcloud compute instances stop $instance"
#        return $?
#    fi
#}
#
#alias gstop=_gcloud_stop
#
#function _gcloud_start() {
#    local instance=$(gcloud compute instances list | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
#    if [[ -n $instance ]]; then
#        echo "gcloud compute instances start $instance"
#        eval "gcloud compute instances start $instance"
#        return $?
#    fi
#}
#
#alias gstart=_gcloud_start
#
# Show current gcloud config
function gcloud_config_get() {
    gcloud config get-value project
    gcloud config get-value compute/region
    gcloud config get-value compute/zone
}

## Functions to change gcloud environments
#function switch_to_demo() {
#    gcloud config set project
#    gcloud config set compute/zone us-east1-c
#    gcloud config set compute/region us-east1
#}

###############################
# My quircky little functions #
###############################
# Add ssh keys
function add_ssh() {
  ~/Documents/repos/mydotfiles/add_ssh_keys.sh
}

# cd to a repo
function repo() {
  cd ~/Documents/repos/$1
}

# build keyboard firmware for spacecommander 60
function build_flash_60() {
  repo
  cd keyboards/handwired/spacecommander/60
  qmk compile -km default
  qmk flash -kb handwired/spacecommander/60 -km default
}

##################
# Computer hacks #
##################
# make sure print screen files go to Pictures
#screencaploc=$HOME/Pictures #where we want screen caps to go
#defaults read com.apple.screencapture location &> /dev/null #just need to get exit code for next test
#if [ $? -ne 0 ] || [ $screencaploc != $(defaults read com.apple.screencapture location) ]
#then
#  defaults write com.apple.screencapture location $screencaploc
#fi

# This was causing issues with key repeats when using VIM extension in VScode
# make sure hold and press is running for accented keys
#defaults read -g ApplePressAndHoldEnabled &> /dev/null
#if [ $? -ne - ] || [ $(defaults read -g ApplePressAndHoldEnabled) != 1 ]
#then
#  defaults write -g ApplePressAndHoldEnabled -bool true
#fi

# set up ripgrep for bash and vim
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# set up fubectl
#[ -f ~/.vim/fubectl.source ] && source ~/.vim/fubectl.source

# QMK repo location
export QMK_HOME=~/Documents/repos/qmk_firmware
