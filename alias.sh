alias manview='groff -Tascii -man'
alias less='less -r'   # raw control characters
alias whence='type -a' # where, of a sort
alias odoc='zathura'
alias oimg='sxiv'
alias lvim="v -c':e#<1'"

# alias H='history'
alias H='python3 ~/.config/shellscript/history_manager.py'

# alias gs="git status"
# alias ga="git add ."
# alias gc='git commit -m'
# alias gp="git push"

# alias img='LD_LIBRARY_PATH=/usr/local/lib img2sixel'
alias pst="env PS_ARGS=%cpu,%mem,lstart pst"
# alias calc='bc -l ~/.config/bc/*'
# alias brilho='PYENV_VERSION=system brightness-controller'

# alias workspace.restart='sudo systemctl restart workspace.service'
# alias sdcv='sdcv -c -2 $HOME/.config/nvim/dictionary/sdcv'
# alias pt-en='sdcv -u "Portuguese - English"'
# alias en-pt='sdcv -u "English-Portuguese"'
alias ls-mem='ps axch -o cmd:15,%mem --sort=-%mem'
alias ls-cpu='ps axch -o cmd:15,%cpu --sort=-%cpu'
alias game='/usr/games/mednafen'
#alias git.nvim='/usr/bin/git --git-dir=$HOME/git/dotfiles/.nvim --work-tree=$HOME/.config/nvim'

#alias logout-gnome='gnome-session-quit --logout'
#alias desliga='systemctl enable poweroff.target'
#                sudo service lightdm restart
#alias x.restart='sudo service gdm restart'
# sudo systemctl restart gdm
#alias asciiflow="google-chrome file:///${HOME}/developer/asciiflow2/index.html"
#sudo systemctl restart gdm.service as Ubuntu can be using systemd –

#alias slide='lookatme --no-ext-warn'
alias slide="PYENV_VERSION=3.6.15 lookatme -e file_loader"
# alias nf='iprj new file --list'

alias rec='arecord -c 1 -r 48000 -f S16_LE -D "hw:CARD=Loopback,DEV=1,SUBDEV=0"'
#alias mic.server='sudo micclient-ubuntu-x86_64 -t wifi 192.168.2.104'
alias ei3="v -c'0' -c'map ? :qall!<CR>' -c'map q :qall!<CR>' ~/.config/i3/config"
alias egit="v -c'0' -c'map ? :qall!<CR>' -c'map q :qall!<CR>' ~/.gitconfig"
alias xevkb="xev -event keyboard"
#alias ccat="highlight --out-format=ansi" # Color cat - print file with syntax highlighting.

# Some shortcuts for different directory listings
alias ls-perms='stat -c "%a %n"'
#alias perms='stat -c "%a"'

#alias scanner='scangearmp'
alias nw="i3-msg workspace $(wmctrl -d | rev | cut -c 1 | awk -v RS='\\s+' '{ a[$1] } END { for(i = 1; i in a; ++i); print i }')"
##alias r='ranger --cmd "set show_hidden=true"'
#alias mvi='mpv -profile image'
#xhost +
#alias vp='xhost +; sudo su visualparadigm -c /opt/visualparadigm/Visual_Paradigm_14.2/bin/Visual_Paradigm'
#alias audio-hdmi='pacmd set-card-profile 0 "output:hdmi-stereo"'
#alias audio-analog='pacmd set-card-profile 0 "output:analog-stereo"'
#alias audio-lx3000='pacmd set-card-profile 1 "output:analog-stereo"'

alias xopen='xdg-open'
#alias vp='/opt/Visual_Paradigm_16.2/bin/Visual_Paradigm'

alias godarwin='GOOS=darwin GOARCH=amd64 go'
alias golinux='GOOS=linux GOARCH=amd64 go'
alias goraspbian='GOOS=linux GOARCH=arm GOARM=7 go'
#alias terminal="rxvt -fn \"xft:InconsolataGo Nerd Font Mono:size=31:hinting=true:hintstyle=Regular:minspace=False\" -fb \"xft:InconsolataGo Nerd Font Mono:size=31:hinting=true:hintstyle=Bold\""
#alias terminal="rxvt -fn \"xft:DroidSansMono Nerd Font Mono:pixelsize=31:hinting=true:hintstyle=Book\""

# Language aliases
alias rb='ruby'
alias py='python'
alias ipy='ipython'

# Godot
alias godot='/usr/local/bin/godot --rendering-driver opengl3'
alias godot-mono='/usr/local/bin/godot-mono --rendering-driver opengl3'

# paginas web locais
alias calibre='open http://192.168.2.43:8083'
alias ownclound='open http://192.168.2.43:8080'

# Pianobar can be found here: http://github.com/PromyLOPh/pianobar/

# alias piano='pianobar'

alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back
# vi:set nu nowrap:
# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: alias.sh
