#!/usr/bin/env bash

xfile() {
	[ "$1" ] || {
		nohup nautilus --no-desktop . >/dev/null 2>&1
	}

	nohup nautilus --no-desktop $1 >/dev/null 2>&1
}

__xenv() {

	# Declaração de um vetor associativo
	declare -A meuVetor

	# Inicializa um contador
	contador=0

	# Lê cada linha do arquivo
	while IFS= read -r linha; do
		# Armazena cada linha no vetor associativo com o contador como chave
		meuVetor[$contador]="$linha"
		# Incrementa o contador
		((contador++))
	done < <(jenv vars | sed -e '/^#/d' -e '/^$/d')

	# Exibe o vetor associativo para verificar
	for chave in "${!meuVetor[@]}"; do
		echo "${meuVetor[$chave]}"
	done | tac

}

xenv() {
	eval "$(__xenv)"
}

# mm() { eval BACK_DIR=`pwd`; }
mm() {
	pwd | /usr/bin/xclip -selection secondary
	clear
	message="👉rec: >>>> $(xclip -selection secondary -o) <<<<"
	#n=$(echo $message | wc -c)
	n=${#message}
	c=$COLUMNS
	#c=$(tput cols)
	declare -i Lin=1 Col=$((c - n))
	tput civis
	# tput smso # bold ON
	tput bold
	tput cup $Lin $Col
	# tput rmso # bold OFF
	echo "$message"
	tput sgr0
	tput cnorm
}

vv() {
	clear
	message="🏃back: >>>> $(xclip -selection secondary -o) <<<<"
	n=${#message}
	c=$COLUMNS
	declare -i Lin=1 Col=$((c - n))
	tput civis
	# tput smso # bold ON
	tput bold
	tput cup $Lin $Col
	# tput rmso # bold OFF
	echo "$message"
	tput sgr0
	tput cnorm
	BACK_DIR=$(xclip -selection secondary -o)
	cd $BACK_DIR
}

gg() {
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# Se for um repositório Git, vai para o diretório raiz do repositório
		repo_root=$(git rev-parse --show-toplevel)
		clear
		message="🗣️ back: >>>> ${repo_root} <<<< 📌"
		n=$(echo $message | wc -c)
		c=$(tput cols)
		declare -i Lin=1 Col=$((c - n))
		tput civis
		# tput smso # bold ON
		tput bold
		tput cup $Lin $Col
		# tput rmso # bold OFF
		echo "$message"
		tput sgr0
		tput cnorm
		cd "$repo_root"
	else
		echo "Não é um repositório Git. Não foi feita nenhuma alteração."
	fi

}

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: xfile.sh
