# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias f="fzf"
alias searchinnotes="ag --nobreak --nonumbers --noheading . | fzf"
alias preview="fzf --preview 'cat {}'"
alias preview100="fzf --preview 'head -100 {}'"
alias p="find . -type f | fzf --preview 'head -100 {}'"
alias vf="fzf --bind 'crtl-v:execute(vim {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'"
alias vimf="vim \$(fzf)"
alias previewbinary="fzf --preview 'strings {}'"


f-rm() {
    docker rm -it $(docker ps \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $1}') "$@"
}

f-exec() {
    docker exec -it $(docker ps \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $1}') "$@"
}

f-logs() {
    docker logs $(docker ps \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $1}') "$@"
}

f-stop() {
    docker stop $(docker ps \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $1}') "$@"
}

f-start() {
    docker start $(docker ps -a \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $1}') "$@"
}

f-rmi() {
    docker images \
        | fzf-tmux --reverse --header-lines=1 --multi --ansi \
        | awk '{print $3}' \
        | xargs docker rmi ${1+"$@"}
}

