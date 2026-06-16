XCLIP=$(command -v xclip)
if [[ $XCLIP ]]; then
	s=clipboard
	alias xcopy="$XCLIP -selection $s" &&
		alias xpaste="$XCLIP -selection $s -o"

	s=primary
	alias xcopy-p="$XCLIP -selection $s" &&
		alias xpaste-p="$XCLIP -selection $s -o"

	s=secondary
	alias xcopy-s="$XCLIP -selection $s" &&
		alias xpaste-s="$XCLIP -selection $s -o"

	alias xpwd='pwd|xclip -selection secondary'
	alias xcd='cd $(xclip -selection secondary -o)'

	xcp() {
		if [[ $# -eq 0 ]]; then
			echo 1>&2 'Sintaxe: xcp [files]'
		else
			echo cp $* $(xclip -selection secondary -o)
		fi
	}

	xclone() {
		git clone $(xclip -selection secondary -o)
	}

fi
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: xclip.sh
