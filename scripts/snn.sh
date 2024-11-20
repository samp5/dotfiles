#!/usr/bin/env bash

SESH=snn

tmux has-session -t $SESH 2>/dev/null

if [[ $? -eq 0 ]] # sesh does exist
then
  tmux attach -t $SESH
else
  tmux new-session -ds $SESH  -c ~/dev/snn  -n "build" 
  tmux new-window -d -t $SESH -n "edit" -c ~/dev/snn/src "/usr/bin/nvim ."
  tmux new-window -d -t $SESH -n "server" "ssh dolphin_jump"
fi

tmux attach -t $SESH
