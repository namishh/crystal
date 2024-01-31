#!/usr/bin/env bash

function get_workspaces_info() {
  output=$(swaymsg -t get_workspaces)
    echo $output
}

get_workspaces_info

swaymsg -t subscribe '["window"]' --monitor | {
    while read -r event; do
        get_workspaces_info
    done
}

