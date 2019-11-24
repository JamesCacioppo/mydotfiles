[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=~/Library/Python/3.7/bin:$PATH
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
