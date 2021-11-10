alias gi="git init"
alias gs="git status -sbu"
alias gp="git push"
alias gcm="git commit -m"
alias gcr='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'
alias gpl="git pull"
alias gb="git branch"

gco () {
    if [ "$#" -gt 0 ]; then
        git checkout $*
        return $?
    fi
    git checkout $(_gb)
}

ga () {
    if [ "$#" -gt 0 ]; then
        git add $*
        return $?
    fi
    git add $(_gf)
}

gm () {
    if [ "$#" -gt 0 ]; then
        git merge $*
        return $?
    fi
    git merge $(_gb)
}
