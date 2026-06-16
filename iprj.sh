IPRJ=$(command -v iprj)
[[ $IPRJ ]] && eval "$(iprj init)"
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: iprj.sh
	iprj --version
}
