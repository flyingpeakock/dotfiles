alias gi="git init"
alias gs="git status -sbu"
alias gp="git push"
alias gcm="git commit -m"
alias gcr='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'
alias gpl="git pull"
alias gb="git branch"

gco () {
    if [ "$#" -gt 0 ]; then
        git checkout $@
        return $?
    fi
    git checkout $(_gb)
}

compdef gco=_gco
_gco() {
    service=git CURRENT+=1
    words=(git status)
    _git
}

ga () {
    if [ "$#" -gt 0 ]; then
        git add $@
        return $?
    fi
    git add $(_gf)
}

compdef ga=_ga
_ga() {
    service=git CURRENT+=1
    words=(git status)
    _git
}

gm () {
    if [ "$#" -gt 0 ]; then
        git merge $@
        return $?
    fi
    git merge $(_gb)
}

compdef gm=_gm
_gm() {
    service=git CURRENT+=1
    words=(git status)
    _git
}
