# Setting fzf vars
export FZF_DEFAULT_COMMAND='fd --type f .'
export FZF_DEFAULT_OPTS='--prompt="❯ " --marker="▶" --pointer="➤" --color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
export FZF_TMUX_OPTS='-p 75%'

# Setting zoxide fzf options
export _ZO_FZF_OPTS='--height=25% --layout=reverse --preview "printf {} | xargs exa -T -L 1 --icons 2>/dev/null"'

# Checking if tmux and setting correct fzf command
_FZF_COMMAND () {
    if [[ -v TMUX ]]; then
        fzf-tmux -p 75% --preview-window right:60% $*
    else
        local height=50%
        local pos=down
        if [ $COLUMNS -gt 70 ]; then
            height=35%
            pos=right:60%
        fi

        fzf --height=$height --layout=reverse --preview-window $pos $*
    fi
}

# fzf aliases

alias fzf=_FZF_COMMAND
alias app="i3-dmenu-desktop --dmenu=fzf"

# Useful fzf functions

# Install programs with paru
pi () {
	paru -Sl | awk '{print $2($4=="" ? "" : " *")}' | _FZF_COMMAND --multi --preview 'paru -Si {1}' | xargs -ro paru -S
}

# Uninstall programs, lists only explicitly installed
pu () {
	paru -Qqe | _FZF_COMMAND --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rnsu
}

# Jump to a directory using fd
j () {
	local d
	d=$(fd -E /.snapshots -t d -H . $* | _FZF_COMMAND --preview 'preview.sh {}')
	[[ -d $d ]] && z $d
}

# Open a file found with fd
o () {
	local file
	file=$(fd -E /.snapshots -t f -H . $* | _FZF_COMMAND --preview 'preview.sh {}')
	[[ -f $file ]] || return
	case $(file --mime-type "$file" -bL) in
		text/*|application/json) $EDITOR $file ;;
		*) xdg-open $file& ;;
	esac
}

# Trash file
tp () {
    fd -H -t f . $* | _FZF_COMMAND --multi --preview 'preview.sh {}' | xargs -ro trash-put
}

# Open a file by searching inside of it
f () {
	if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
	local file
	file=$(rg --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | _FZF_COMMAND --preview="rg --ignore-case --pretty --context 10 '"$*"' {}")
	[[ -f $file ]] || return
	case $(file --mime-type "$file" -bL) in
		text/*|application/json) $EDITOR $file ;;
		*) xdg-open $file& ;;
	esac
}

# Fuzzy search for man pages
fman () {
    man -k . | fzf | awk '{print $1}' | xargs -r man
}

# Some git commands

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

# Show git branches
_gb () {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  _FZF_COMMAND --ansi --multi --tac \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

# Checkout branch fuzzily
fgco () {
	git checkout $(_gb)
}

fgh () {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  _FZF_COMMAND --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}


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

