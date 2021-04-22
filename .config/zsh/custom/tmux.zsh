t() {
    tmux attach -t $1 || tmux new-session -s $1
}

alis tl="tmux list-sessions"
