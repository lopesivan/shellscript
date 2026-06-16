
imaple() {
    /opt/maple2021/jre.X86_64_LINUX/bin/java \
        -Xmx1024m -Xss4m \
        -Dsun.java2d.pmoffscreen=false \
        -Djogamp.gluegen.UseTempJarCache=false \
        -Dswing.plaf.metal.userFont="Hack Nerd Font Mono-26" \
        -Dswing.plaf.metal.controlFont="Hack Nerd Font Mono-26" \
        -cp '/opt/maple2021/java/*' \
        -Dmaple.bin.path='/opt/maple2021/bin.X86_64_LINUX'   \
        com.maplesoft.application.Launcher \
        -command Start Maple
}
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: maple.sh
