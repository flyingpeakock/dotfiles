t() {
    tmux attach -t $1 2> /dev/null || tmux new-session -s $1
}

alias tl="tmux list-sessions"
