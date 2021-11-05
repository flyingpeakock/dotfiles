cheat() {
    local p="bat"
    if ! command -v $p &> /dev/null
    then
        p="less -fR"
    fi
    curl -s cheat.sh/$1 | $p
}

up(){
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
        do
           d=$d/..
        done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}
                                        
ex ()
{
	local remove_archive
	local success
	local extract_dir

	if (( $# == 0 )); then
		cat <<-'EOF' >&2
			Usage: extract [-option] [file ...]
			Options:
			    -r, --remove    Remove archive after unpacking.
		EOF
	fi

	remove_archive=1
	if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
		remove_archive=0
		shift
	fi

	while (( $# > 0 )); do
		if [[ ! -f "$1" ]]; then
			echo "extract: '$1' is not a valid file" >&2
			shift
			continue
		fi

		success=0
		extract_dir="${1:t:r}"
		case "${1:l}" in
			(*.tar.gz|*.tgz) (( $+commands[pigz] )) && { pigz -dc "$1" | tar xv } || tar zxvf "$1" ;;
			(*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
			(*.tar.xz|*.txz)
				tar --xz --help &> /dev/null \
				&& tar --xz -xvf "$1" \
				|| xzcat "$1" | tar xvf - ;;
			(*.tar.zma|*.tlz)
				tar --lzma --help &> /dev/null \
				&& tar --lzma -xvf "$1" \
				|| lzcat "$1" | tar xvf - ;;
			(*.tar.zst|*.tzst)
				tar --zstd --help &> /dev/null \
				&& tar --zstd -xvf "$1" \
				|| zstdcat "$1" | tar xvf - ;;
			(*.tar) tar xvf "$1" ;;
			(*.tar.lz) (( $+commands[lzip] )) && tar xvf "$1" ;;
			(*.tar.lz4) lz4 -c -d "$1" | tar xvf - ;;
			(*.tar.lrz) (( $+commands[lrzuntar] )) && lrzuntar "$1" ;;
			(*.gz) (( $+commands[pigz] )) && pigz -dk "$1" || gunzip -k "$1" ;;
			(*.bz2) bunzip2 "$1" ;;
			(*.xz) unxz "$1" ;;
			(*.lrz) (( $+commands[lrunzip] )) && lrunzip "$1" ;;
			(*.lz4) lz4 -d "$1" ;;
			(*.lzma) unlzma "$1" ;;
			(*.z) uncompress "$1" ;;
			(*.zip|*.war|*.jar|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl) unzip "$1" -d $extract_dir ;;
			(*.rar) unrar x -ad "$1" ;;
			(*.rpm) mkdir "$extract_dir" && cd "$extract_dir" && rpm2cpio "../$1" | cpio --quiet -id && cd .. ;;
			(*.7z) 7za x "$1" ;;
			(*.deb)
				mkdir -p "$extract_dir/control"
				mkdir -p "$extract_dir/data"
				cd "$extract_dir"; ar vx "../${1}" > /dev/null
				cd control; tar xzvf ../control.tar.gz
				cd ../data; extract ../data.tar.*
				cd ..; rm *.tar.* debian-binary
				cd ..
			;;
			(*.zst) unzstd "$1" ;;
			(*)
				echo "extract: '$1' cannot be extracted" >&2
				success=1
			;;
		esac

		(( success = $success > 0 ? $success : $? ))
		(( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
		shift
	done
}

please ()
{
    if [ $# -ne 0 ]; then
        sudo $*
    else
        sudo $(fc -ln -1)
    fi
}

parufind () {
     paru -Sl | awk '{print $2($4=="" ? "" : " *")}' | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S
}

spotify() {
    local started=""
    pgrep spotifyd > /dev/null && $started=true
    if [[ $started -eq "" ]];
    then
        spotifyd -U "bw get username spotify" -P "bw get password spotify"
    fi
    spt
    if [[ $started -eq "" ]];
    then
        pkill spotifyd
    fi
}

ls () {
    exa -l --git --icons "$@" 2> /dev/null || ls
}

lf () {
    if command -v lfrun &> /dev/null
    then
        lfrun "$@"
    else
        lf "$@"
    fi
}

j () {
    z $(fd -t d -H . $1 | fzf --preview 'exa -T -L 1 --icons {}')
}

o () {
    file=$(fd -t -f -H . $1 | fzf --preview 'preview.sh {}')
    case $(file --mime-type "$file" -bL) in
        text/*|application/json) $EDITOR $file ;;
        *) xdg-open $file& ;;
    esac
}
