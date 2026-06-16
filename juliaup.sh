# juliaup

case ":$PATH:" in
*:/home/ivan/.juliaup/bin:*) ;;

*)
	export PATH=/home/ivan/.juliaup/bin${PATH:+:${PATH}}
	;;
esac

[ $SCRIPT_DEBUG_ON ] && echo load file: juliaup.sh
