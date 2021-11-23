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
        git merge --no-edit $main
    done
    git checkout $current
}

# Used by fzf functions defined in fpath
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

# Keyboard binding for git difined in fpath
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '\e$c' fzf-g$c-widget"
  done
}
bind-git-helper f b h s
unset -f bind-git-helper

