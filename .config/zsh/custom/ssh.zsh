# Slightly modified version of oh-my-zsh ssh-apent plugin
# Get the filename to store/lookup the environment from
ssh_env_cache="$HOME/.ssh/agent.env"

function _start_agent() {
  # Check if ssh-agent is already running
  if [[ -f "$ssh_env_cache" ]]; then
    . "$ssh_env_cache" > /dev/null

    # Test if $SSH_AUTH_SOCK is visible
    zmodload zsh/net/socket
    if [[ -S "$SSH_AUTH_SOCK" ]] && zsocket "$SSH_AUTH_SOCK" 2>/dev/null; then
      return 0
    fi
  fi

  # start ssh-agent and setup environment
  ssh-agent | sed '/^echo/d' >! "$ssh_env_cache"
  chmod 600 "$ssh_env_cache"
  . "$ssh_env_cache" > /dev/null
}
# Add a nifty symlink for screen/tmux if agent forwarding is enabled
if zstyle -t :omz:plugins:ssh-agent agent-forwarding \
   && [[ -n "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
  ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USERNAME-screen
else
  _start_agent
fi

unset agent_forwarding ssh_env_cache
unfunction _start_agent 
