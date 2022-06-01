#!/bin/bash

get_cpu () {
  grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}' | tr '.' ' ' | awk '{print $1}'
}

if [[ $1 == "cpu" ]]; then
  get_cpu
fi