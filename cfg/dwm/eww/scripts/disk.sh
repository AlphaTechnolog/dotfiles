#!/usr/bin/env bash
df --output=pcent / | tail -n 1 | sed 's/%//g' | xargs
