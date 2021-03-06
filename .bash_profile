export PATH=~/Documents/repos/tools:~/Library/Python/3.7/bin:$PATH
alias ll="ls -al"
alias gs="git status"
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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

################
# Docker stuff #
################
# open bash shell in docker container $1
function dbash() {
	docker exec -it $1 /bin/bash
}

######################
# Goolge Cloud stuff #
######################

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jamescacioppo/google-cloud-sdk/path.bash.inc' ]; then . '/Users/jamescacioppo/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jamescacioppo/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/jamescacioppo/google-cloud-sdk/completion.bash.inc'; fi

# gssh function from Vinod
function _gcloud_ssh() {
    local instance=$(gcloud compute instances list | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
    if [[ -n $instance ]]; then
        echo "gcloud compute ssh $instance --internal-ip"
        eval "gcloud compute ssh $instance --internal-ip"
        return $?
    fi
}

alias gssh=_gcloud_ssh #alias to Vinod's gssh function

function _gcloud_stop() {
    local instance=$(gcloud compute instances list | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
    if [[ -n $instance ]]; then
        echo "gcloud compute instances stop $instance"
        eval "gcloud compute instances stop $instance"
        return $?
    fi
}

alias gstop=_gcloud_stop

function _gcloud_start() {
    local instance=$(gcloud compute instances list | fzf-tmux --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
    if [[ -n $instance ]]; then
        echo "gcloud compute instances start $instance"
        eval "gcloud compute instances start $instance"
        return $?
    fi
}

alias gstart=_gcloud_start

# Show current gcloud config
function gcloud_config_get() {
    gcloud config get-value project
    gcloud config get-value compute/region
    gcloud config get-value compute/zone
}

# Functions to change gcloud environments
function switch_to_demo() {
    gcloud config set project
    gcloud config set compute/zone us-east1-c
    gcloud config set compute/region us-east1
}
# Function to auth gcloud
function auth_gcloud() {
    gcloud auth login
    gcloud auth configure-docker # auth docker to use gcri
    gcloud auth application-default login
}

##############################
# My quircky little functions #
##############################
# copy file to new ansible-bootstrap repo
function cabs() {
	cp -vR ~/Documents/repos/ansible/roles/$1 ~/Documents/repos/ansible-bootstrap/roles
}
# cd to a repo
function repo() {
	cd ~/Documents/repos/$1
}
# cp all dotfiles to repo, commit, and push
function dot() {
    if [ -z "$1" ]
    then
        echo Please provide a commit message in quotes and re-run
    else
        start_dir=$(pwd) 
        cd ~/
        cp -v .bash_profile ~/Documents/repos/mydotfiles && \
        cp -v .vimrc ~/Documents/repos/mydotfiles && \
        cp -v .gitconfig ~/Documents/repos/mydotfiles && \
        cd ~/Documents/repos/mydotfiles && \
        {
            git add .
            git commit -m "$1"
            git push
        } 
        cd $start_dir
        unset start_dir
    fi
}

function tmuxdot() {
    if [ -z "$1" ]
    then
        echo Please provide a commit message in quotes and re-run
    else
        start_dir=$(pwd) 
        cd ~/
        cp -v .tmux.conf.local ~/Documents/repos/.tmux
        cd ~/Documents/repos/.tmux
        {
            git add .
            git commit -m "$1"
            git push
        } 
        cd $start_dir
        unset start_dir
    fi
}

function gitemail() {
  if [ -z "$1" ]
  then
    echo Please provide an email address
  else
    git config user.email "$1"
    git config user.email
  fi
}

##################
# Computer hacks #
##################
# Bash History
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTIGNORE="ls:ps:history"
export PROMPT_COMMAND="history -a"
shopt -s histappend
shopt -s cmdhist

# make sure print screen files go to Pictures
screencaploc=/Users/`whoami`/Pictures #where we want screen caps to go
if [ $screencaploc != $(defaults read com.apple.screencapture location) ]
then
  defaults write com.apple.screencapture location $screencaploc
fi

# git fanciness: Supercharge your prompt!
# Below are paths for if git installed with Xcode. If you installed with
# Homebrew then you'll need to update these.
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
YELLOW="\[$(tput setaf 5)\]" #colors range from 0-6
RESET="\[$(tput sgr0)\]"
#export PS1="\u@\h:\W \$(__git_ps1 \" ${YELLOW}(%s)${RESET} \")\$ "
export PS1="\u@MyMBP:\W \$(__git_ps1 \" ${YELLOW}(%s)${RESET} \")\$ "
# Change PS1 because someone used a default JAMF profile and my hostname is my
# serial number: dumb dumb dumb dumb dumb

# set up ripgrep for bash and vim
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# set up fubectl
[ -f ~/.vim/fubectl.source ] && source ~/.vim/fubectl.source
