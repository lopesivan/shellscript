# cabal

if [ -d "/opt/cabal/bin" ]; then
    export PATH=/opt/cabal/bin:$PATH
fi

if [ -d "/opt/ghc/bin" ]; then
    export PATH=/opt/ghc/bin:$PATH
fi

if [ -d "$HOME/.cabal/bin" ]; then
    export PATH=$HOME/.cabal/bin:$PATH
fi

# DEBUG ON
[ "$SCRIPT_DEBUG_ON" ] && echo load file: cabal.sh
