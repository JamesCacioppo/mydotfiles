alias ll="ls -la"
alias gssh=_gcloud_ssh #alias to Vinod's gssh function
alias preview="fzf --preview 'cat {}'"
alias preview100="fzf --preview 'head -100 {}'"
alias p="find . -type f | fzf --preview 'head -100 {}'"
alias vf="fzf --bind 'crtl-v:execute(vim {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"
alias vimf="vim \$(fzf)"

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
if [ -f '/Users/jamescacioppo/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/jamescacioppo/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jamescacioppo/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/jamescacioppo/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# gssh function from Vinod
function _gcloud_ssh() {
    local instance=$(gcloud compute instances list | fzf --header-lines=1 --reverse --multi --cycle | awk '{print $1}')
    if [[ -n $instance ]]; then
        echo "gcloud compute ssh $instance --internal-ip"
        eval "gcloud compute ssh $instance --internal-ip"
        return $?
    fi
}

# Functions to change gcloud environments
function switch_to_devstaging() {
    gcloud container clusters get-credentials devstagingcluster1  --zone us-east4-a  --project gs-dev-staging
    gcloud config set project gs-dev-staging
    gcloud config set compute/zone us-east4-a
    gcloud config set compute/region us-east4
}

# Function to auth gcloud
function auth_gcloud() {
    gcloud auth login
    gcloud auth configure-docker # auth docker to use gcloud docker image repo
}

##############################
# My quircky little functions #
##############################
#copy file to new ansible-bootstrap repo
function cabs() {
	cp -vR ~/Documents/repos/ansible/roles/$1 ~/Documents/repos/ansible-bootstrap/roles
}
#cd to a repo
function repo() {
	cd /Users/jamescacioppo/Documents/repos/$1
}
#cp all dotfiles to repo, commit, and push
function dot() {
    if [ -z "$1" ]
    then
        echo Please provide a commit message in quotes and re-run
    else
        start_dir=$(pwd) 
        cd ~/
        cp -v .bash_profile ~/Documents/repos/mydotfiles && \
        cp -v .vimrc ~/Documents/repos/mydotfiles && \
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
# git fanciness
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
YELLOW="\[$(tput setaf 5)\]" #colors range from 0-6
RESET="\[$(tput sgr0)\]"
export PS1="\u@\h:\W \$(__git_ps1 \" ${YELLOW}(%s)${RESET} \")\$ "
# set up ripgrep for bash and vim
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
