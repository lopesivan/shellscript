export PATH=$(brew --prefix)/scripts/bin:$PATH
export QTFRAMEWORK_BYPASS_LICENSE_CHECK=1

export CARGO_TARGET_DIR=/workspace/.target
export GRADLE_USER_HOME=/workspace/.gradle
export CCACHE_DIR=/workspace/.ccache
export TMPDIR=/workspace/.tmp

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: env.sh
