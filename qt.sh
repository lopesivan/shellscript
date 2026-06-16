Qt6
export Qt6_DIR=/home/ivan/Qt/6.10.0/gcc_64
export PATH=/home/ivan/Qt/6.10.0/gcc_64/bin:$PATH
export LD_LIBRARY_PATH=/home/ivan/Qt/6.10.0/gcc_64/lib:$LD_LIBRARY_PATH

alias qt-cmake='/home/ivan/Qt/6.10.0/gcc_64/bin/qt-cmake'
alias qmake='/home/ivan/Qt/6.10.0/gcc_64/bin/qmake'
alias designer='/home/ivan/Qt/6.10.0/gcc_64/bin/designer'
###############################
Qt2
QTDIR=/workspace/qt
PATH=$QTDIR/bin:$PATH
if [ $MANPATH ]; then
    MANPATH=$QTDIR/man:$MANPATH
else
    MANPATH=$QTDIR/man
fi
if [ $LD_LIBRARY_PATH ]; then
    LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH
else
    LD_LIBRARY_PATH=$QTDIR/lib
fi
LIBRARY_PATH=$LD_LIBRARY_PATH
if [ $CPLUS_INCLUDE_PATH ]; then
    CPLUS_INCLUDE_PATH=$QTDIR/include:$CPLUS_INCLUDE_PATH
else
    CPLUS_INCLUDE_PATH=$QTDIR/include
fi

export QTDIR PATH MANPATH LD_LIBRARY_PATH LIBRARY_PATH
export CPLUS_INCLUDE_PATH

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: qt.sh
