# funcoeszz
_f=${HOME}/developer/funcoeszz/funcoeszz
if [ -f $_f ]; then
	ZZ_HOME="${HOME}/developer/funcoeszz/funcoeszz"
	eval "$(<$ZZ_HOME)"
fi
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: funcoeszz.sh
