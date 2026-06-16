ANDROID_HOME=$HOME/Android/Sdk # or your custom SDK path
CMDLINE_TOOLS=${ANDROID_HOME}/cmdline-tools

if [ -d "${CMDLINE_TOOLS}" ]; then
    export PATH=$PATH:${CMDLINE_TOOLS}/latest/bin
fi

export ANDROID_HOME=$ANDROID_HOME

## -----------------------------------
## Android ADB aliases
## -----------------------------------
#
#alias adb-home='adb shell input keyevent 3'
#alias adb-back='adb shell input keyevent 4'
#alias adb-menu='adb shell input keyevent 82'
#
#alias adb-up='adb shell input keyevent 19'
#alias adb-down='adb shell input keyevent 20'
#alias adb-left='adb shell input keyevent 21'
#alias adb-right='adb shell input keyevent 22'
#alias adb-ok='adb shell input keyevent 23'
#
#alias adb-tab='adb shell input keyevent 61'
#
#alias adb-volume-up='adb shell input keyevent 24'
#alias adb-volume-down='adb shell input keyevent 25'

# -----------------------------------
# Android ADB keyevent helper
# -----------------------------------

adb-key() {
    local key="$1"
    local repeat="${2:-1}"
    local delay="${3:-0.08}"

    for ((i = 1; i <= repeat; i++)); do
        adb shell input keyevent "$key"

        if [ "$i" -lt "$repeat" ]; then
            sleep "$delay"
        fi
    done
}

# -----------------------------------
# Android ADB shortcuts
# uso: adb-down 5
# uso: adb-tab 3 0.2
# -----------------------------------

adb-home() { adb-key KEYCODE_HOME "${1:-1}" "${2:-0.08}"; }
adb-back() { adb-key KEYCODE_BACK "${1:-1}" "${2:-0.08}"; }
adb-menu() { adb-key KEYCODE_MENU "${1:-1}" "${2:-0.08}"; }

adb-up() { adb-key KEYCODE_DPAD_UP "${1:-1}" "${2:-0.08}"; }
adb-down() { adb-key KEYCODE_DPAD_DOWN "${1:-1}" "${2:-0.08}"; }
adb-left() { adb-key KEYCODE_DPAD_LEFT "${1:-1}" "${2:-0.08}"; }
adb-right() { adb-key KEYCODE_DPAD_RIGHT "${1:-1}" "${2:-0.08}"; }
adb-ok() { adb-key KEYCODE_DPAD_CENTER "${1:-1}" "${2:-0.08}"; }

adb-onoff() { adb-key KEYCODE_POWER "${1:-1}" "${2:-2}"; }
adb-tab() { adb-key KEYCODE_TAB "${1:-1}" "${2:-0.08}"; }

adb-volume-up() { adb-key KEYCODE_VOLUME_UP "${1:-1}" "${2:-0.08}"; }
adb-volume-down() { adb-key KEYCODE_VOLUME_DOWN "${1:-1}" "${2:-0.08}"; }
# desliga-mobile()
# {
#   adb shell "su -c 'reboot -p'"
# }

# DEBUG opcional do próprio script de completion
[ "$SCRIPT_DEBUG_ON" ] && echo "android.sh"
