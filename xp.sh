XP=$(command -v xp)
[[ $XP ]] && eval "$(xp init)"
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: xp.sh
	xp --version
}
