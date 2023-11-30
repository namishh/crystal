#!/usr/bin/env bash

is_active=$(cat ~/.cache/redshift)

toggle() {
    if [[  $is_active == *"true"*  ]]; then
        redshift -x && echo false > ~/.cache/redshift
    else
        redshift -O 4000 && echo true > ~/.cache/redshift
    fi
}

if [[ $1 == "--toggle" ]]; then
    toggle
fi
