#!/bin/bash

rootdo () {
  if command -v doas 2>&1 > /dev/null; then
    doas ${@}
  elif command -v sudo 2>&1 > /dev/null; then
    sudo ${@}
  else
    echo "WARN: Cannot use neither sudo or doas, using su, type the root passwd"
    su root -c "bash -c '${@}'"
  fi
}

cd $(dirname $0)

if test -f config.h; then
  rm -rf config.h
fi

rootdo make clean install
