# jenv
# echo ${JAVA_HOME}
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
#jenv enable-plugin export
# DEBUG ON

java_version=$(jenv version-name)
echo "Java versão $java_version está ativa"

[ $SCRIPT_DEBUG_ON ] && {
	echo load file: jenv.sh
	jenv version
}
