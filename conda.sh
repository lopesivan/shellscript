# conda

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ivan/.pyenv/versions/miniforge3-24.3.0-0/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/home/ivan/.pyenv/versions/miniforge3-24.3.0-0/etc/profile.d/conda.sh" ]; then
		. "/home/ivan/.pyenv/versions/miniforge3-24.3.0-0/etc/profile.d/conda.sh"
	else
		export PATH="/home/ivan/.pyenv/versions/miniforge3-24.3.0-0/bin:$PATH"
	fi
fi
unset __conda_setup

if [ -f "/home/ivan/.pyenv/versions/miniforge3-24.3.0-0/etc/profile.d/mamba.sh" ]; then
	. "/home/ivan/.pyenv/versions/miniforge3-24.3.0-0/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && {
	echo load file: conda.sh
}
