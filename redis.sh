_redis_list() {
	redis-cli ZRANGE "$1" 0 -1
}

_redis_zram() {
	db=$1
	shift
	redis-cli zadd $db 1 $1
}

alias redis.list='_redis_list'
alias redis.keys='redis-cli KEYS \*'
alias redis.get='redis-bash-cli get'
alias redis.set='redis-bash-cli set'
alias redis.del='redis-bash-cli del'
alias redis.zadd='_redis_zram'

alias e.clean='redis-cli DEL vimmru'
alias e.list='redis-cli ZRANGE vimmru 0 -1'
alias e.last='redis-cli ZRANGE vimmru -1 -1| xargs nvim.sh'

_redis_get() {
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD - 1]}"
	opts=$(redis.keys | grep -v vimmru | sed.joinlines)

	COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
	return 0
}

complete -F _redis_get redis.get redis.del redis.list

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: redis.sh
