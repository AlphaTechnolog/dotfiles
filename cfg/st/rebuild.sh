#!/bin/bash

cd $(dirname $0)

if test -f config.h; then
  rm -rf config.h
fi

sudo make clean install
