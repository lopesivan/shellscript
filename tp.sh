export SHELLSCRIPT_TEMPLATE_PKG=/home/ivan/developer/scripts/tp/template
export SHELLSCRIPT_CTEMPLATE=/home/ivan/developer/scripts/tp/ctemplate
export SHELLSCRIPT_PKG=/home/ivan/developer/scripts/tp/bin-shellscript-pakages
export PATH=/home/ivan/developer/scripts/tp/bin-shellscript-pakages:$PATH
export SHELLSCRIPT_PAKAGES=/home/ivan/developer/scripts/tp/archive-shellscript-pakages

mvToTemplate ()
{
  cp *.templatefile $SHELLSCRIPT_TEMPLATE_PKG
}
goTemplate ()
{
  cd  $SHELLSCRIPT_TEMPLATE_PKG
}

_tp()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  # n=$(( $(tp list --| wc -l) -1 ))
  opts=`tp list --| awk '{print }'| sed -e '' | sed -e :a -e 'N; # s/\n/ /; ta'`

  if [[ ${cur} == --* ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi
}
complete -F _tp tp
