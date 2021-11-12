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

ga () {
    if [ "$#" -gt 0 ]; then
        git add $@
        return $?
    fi
    git add $(_gf)
}

gm () {
    if [ "$#" -gt 0 ]; then
        git merge $@
        return $?
    fi
    git merge $(_gb)
}

gma () {
    local main="${1:-main}"
    local current="$(git branch --show-current)"
    for branch in $(git branch -l); do
        git checkout $branch
        git merge $main
    done
    git checkout $current
}
