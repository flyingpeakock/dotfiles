t() {
    tmux attach -t $1 || tmux new-session -s $1
}

alias tl="tmux list-sessions"
