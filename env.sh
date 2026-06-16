export PATH=$(brew --prefix)/scripts/bin:$PATH
export QTFRAMEWORK_BYPASS_LICENSE_CHECK=1

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: env.sh
