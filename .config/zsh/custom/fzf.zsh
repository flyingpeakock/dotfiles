# Checking if marker option is availible
echo '' | fzf --marker="▶" -1 &> /dev/null
if [ "$?" -gt 0 ]; then
    _fzf_marker=
else
    _fzf_marker="--marker=\"▶\""
fi

# Checking if pointer option is availible
echo '' | fzf --pointer="➤" -1 &> /dev/null
if [ "$?" -gt 0 ]; then
    _fzf_pointer=
else
    _fzf_pointer="--pointer=\"➤\""
fi

# Setting fzf vars
export FZF_DEFAULT_COMMAND='fd --type f .'
export FZF_DEFAULT_OPTS='--prompt="❯ " "'"$_fzf_marker"'" "'"$_fzf_pointer"'" --color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
export FZF_TMUX_OPTS='-p 75%'

# Setting zoxide fzf options
export _ZO_FZF_OPTS='--height=60% -n 2 --preview "preview.sh {2}"'

# Check if fzf-tmux supports -p
fzf-tmux --help 2>&1 /dev/null | rg Popup &> /dev/null
if [ "$?" -gt 0 ]; then
    export _FZF_POPOUT=
else
    export _FZF_POPOUT="-p"
fi

# Checking if tmux and setting correct fzf command
_FZF_COMMAND () {
    if [ -v TMUX ] && [ ! -z "$_FZF_POPOUT" ]; then
        fzf-tmux -p -w 95% -h 50% --preview-window right:60% $@
    else
        fzf --height=60% --layout=reverse --preview-window down:60% $@
    fi
}

# Check if --keep-right is availible
echo '' | fzf --keep-right -1 &> /dev/null
if [ "$?" -gt 0 ]; then
    export _FZF_KEEP_RIGHT=
else
    export _FZF_KEEP_RIGHT="--keep-right"
fi

# fzf aliases
alias fzf=_FZF_COMMAND
alias app="i3-dmenu-desktop --dmenu=fzf"


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


########################################
# Start fzf setup taken from oh-my-zsh #
########################################

# Sources fzf completion and bindings

function setup_using_base_dir() {
    local fzf_base fzf_shell fzfdirs dir

    test -d "${FZF_BASE}" && fzf_base="${FZF_BASE}"

    if [[ -z "${fzf_base}" ]]; then
        fzfdirs=(
          "${HOME}/.fzf"
          "${HOME}/.nix-profile/share/fzf"
          "${XDG_DATA_HOME:-$HOME/.local/share}/fzf"
          "/usr/local/opt/fzf"
          "/usr/share/fzf"
          "/usr/local/share/examples/fzf"
        )
        for dir in ${fzfdirs}; do
            if [[ -d "${dir}" ]]; then
                fzf_base="${dir}"
                break
            fi
        done

        if [[ -z "${fzf_base}" ]]; then
            if (( ${+commands[fzf-share]} )) && dir="$(fzf-share)" && [[ -d "${dir}" ]]; then
                fzf_base="${dir}"
            elif (( ${+commands[brew]} )) && dir="$(brew --prefix fzf 2>/dev/null)"; then
                if [[ -d "${dir}" ]]; then
                    fzf_base="${dir}"
                fi
            fi
        fi
    fi

    if [[ ! -d "${fzf_base}" ]]; then
        return 1
    fi

    # Fix fzf shell directory for Arch Linux, NixOS or Void Linux packages
    if [[ ! -d "${fzf_base}/shell" ]]; then
        fzf_shell="${fzf_base}"
    else
        fzf_shell="${fzf_base}/shell"
    fi

    # Setup fzf binary path
    if (( ! ${+commands[fzf]} )) && [[ "$PATH" != *$fzf_base/bin* ]]; then
        export PATH="$PATH:$fzf_base/bin"
    fi

    # Auto-completion
    if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
        source "${fzf_shell}/completion.zsh" 2> /dev/null
    fi

    # Key bindings
    if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
        source "${fzf_shell}/key-bindings.zsh"
    fi
}


function setup_using_debian_package() {
    if (( ! $+commands[dpkg] )) || ! dpkg -s fzf &>/dev/null; then
        # Either not a debian based distro, or no fzf installed
        return 1
    fi

    # NOTE: There is no need to configure PATH for debian package, all binaries
    # are installed to /usr/bin by default

    local completions key_bindings

    case $PREFIX in
        *com.termux*)
            # Support Termux package
            completions="${PREFIX}/share/fzf/completion.zsh"
            key_bindings="${PREFIX}/share/fzf/key-bindings.zsh"
            ;;
        *)
            # Determine completion file path: first bullseye/sid, then buster/stretch
            completions="/usr/share/doc/fzf/examples/completion.zsh"
            [[ -f "$completions" ]] || completions="/usr/share/zsh/vendor-completions/_fzf"
            key_bindings="/usr/share/doc/fzf/examples/key-bindings.zsh"
            ;;
    esac

    # Auto-completion
    if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
        source $completions 2> /dev/null
    fi

    # Key bindings
    if [[ ! "$DISABLE_FZF_KEY_BINDINGS" == "true" ]]; then
        source $key_bindings
    fi

    return 0
}

function setup_using_opensuse_package() {
    # OpenSUSE installs fzf in /usr/bin/fzf
    # If the command is not found, the package isn't installed
    (( $+commands[fzf] )) || return 1

    # The fzf-zsh-completion package installs the auto-completion in
    local completions="/usr/share/zsh/site-functions/_fzf"
    # The fzf-zsh-completion package installs the key-bindings file in
    local key_bindings="/etc/zsh_completion.d/fzf-key-bindings"

    # If these are not found: (1) maybe we're not on OpenSUSE, or
    # (2) maybe the fzf-zsh-completion package isn't installed.
    if [[ ! -f "$completions" || ! -f "$key_bindings" ]]; then
        return 1
    fi

    # Auto-completion
    if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
        source "$completions" 2>/dev/null
    fi

    # Key bindings
    if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
        source "$key_bindings" 2>/dev/null
    fi

    return 0
}

function setup_using_openbsd_package() {
    # openBSD installs fzf in /usr/local/bin/fzf
    if [[ "$OSTYPE" != openbsd* ]] || (( ! $+commands[fzf] )); then
        return 1
    fi

    # The fzf package installs the auto-completion in
    local completions="/usr/local/share/zsh/site-functions/_fzf_completion"
    # The fzf package installs the key-bindings file in
    local key_bindings="/usr/local/share/zsh/site-functions/_fzf_key_bindings"

    # Auto-completion
    if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
        source "$completions" 2>/dev/null
    fi

    # Key bindings
    if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
        source "$key_bindings" 2>/dev/null
    fi

    return 0
}

function indicate_error() {
    cat >&2 <<EOF
[oh-my-zsh] fzf plugin: Cannot find fzf installation directory.
Please add \`export FZF_BASE=/path/to/fzf/install/dir\` to your .zshrc
EOF
}

# Indicate to user that fzf installation not found if nothing worked
setup_using_openbsd_package \
    || setup_using_debian_package \
    || setup_using_opensuse_package \
    || setup_using_base_dir \
    || indicate_error

unset -f setup_using_opensuse_package setup_using_debian_package setup_using_base_dir indicate_error

if [[ -z "$FZF_DEFAULT_COMMAND" ]]; then
    if (( $+commands[rg] )); then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
    elif (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    elif (( $+commands[ag] )); then
        export FZF_DEFAULT_COMMAND='ag -l --hidden -g "" --ignore .git'
    fi
fi

