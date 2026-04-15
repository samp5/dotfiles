#! /usr/bin/env bash
OPEN_CMD=$1
TARGET_APP_ID=$2
TARGET_APP_INFO=$(niri msg -j windows | jq "unique_by(.app_id) | .[] | select(.app_id == \"$TARGET_APP_ID\")")

if [[ -z "$TARGET_APP_INFO" ]]; then 
  niri msg action spawn-sh -- "$OPEN_CMD"
  exit 1
fi

TARGET_ID=$(echo "$TARGET_APP_INFO" | jq ".id")
niri msg action focus-window  --id "$TARGET_ID"
