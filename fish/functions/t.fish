function t --wraps='tmux attach -t' --description 'alias t tmux attach -t'
  tmux attach -t $argv
        
end
