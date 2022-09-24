cd $(dirname $0)

function exe () {
    local cmd=$@
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

exe picom --config=./picom/picom.conf -b
exe $HOME/.config/awesome/scripts/redshift.sh restore

xrdb merge $HOME/.Xresources
