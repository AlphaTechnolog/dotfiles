cd $(dirname $0)

function exe () {
    local query=$1
    local cmd=$2
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

exe picom 'picom --config=./picom/picom.conf -b'
exe nm-applet 'nm-applet'
