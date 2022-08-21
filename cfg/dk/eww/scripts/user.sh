#!/usr/bin/env bash

name () {
  username=$(whoami)
  echo ${username^}
}

name