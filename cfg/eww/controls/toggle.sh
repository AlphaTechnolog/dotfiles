#!/bin/bash

cachefile="$HOME/.cache/eww/controls"
cachedir=$(dirname $cachefile)

if ! test -d $cachedir; then
  mkdir -p $cachedir
fi

if ! test -f $cachefile; then
  touch $cachefile
fi

read_cache () {
  cat $cachefile
}

write_default_cache () {
cat << EOF
opened=false
EOF
}

initial_struct () {
  local cache=$(read_cache)
  if [[ $cache == "" ]]; then
    write_default_cache > $cachefile
  fi
}

get_cache_key () {
  local cache=$(read_cache)
  local key=$1
  echo $(echo $cache | grep $key | tr '=' ' ' | awk '{print $2}')
}

set_cache_key () {
  local cache=$(read_cache)
  local key=$1
  local newval=$2
  local newcache=$(echo $cache | sed "s/${key}=.*/${key}=${newval}/g")
  echo $newcache > $cachefile
}

initial_struct

# ;;

declare -a windows=(stats date musiccontrol search)

opened=$(get_cache_key "opened")

if [[ $(get_cache_key "opened") == "true" ]]; then
  eww close ${windows[@]}
  set_cache_key "opened" "false"
else
  eww open-many ${windows[@]}
  set_cache_key "opened" "true"
fi
