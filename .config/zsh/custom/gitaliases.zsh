alias gi="git init"
alias gs="git status -sbu"
alias gp="git push"
alias gm="git merge"
alias ga="git add"
alias gcm="git commit -m"
alias gcr='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'
alias gpl="git pull"

gb () {
    if [ "$#" -gt 0 ]; then
        git branch $*
        return 0
    fi
    fgco
}

gco () {
    if [ "$#" -gt 0 ]; then
        git checkout $*
        return 0
    fi
    fgco
}
