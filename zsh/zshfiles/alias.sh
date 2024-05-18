alias vi="nvim"
alias t="tmux attach -t"
alias tl="tmux ls"

# long, header, created, modified time stamp, 
alias ll="exa -l -U -h -m --no-user --icons"
alias ls="exa --color=always"
alias lt="exa --tree --level=3"
alias cl="clear"

alias rm="rm -i"
alias fd="fdfind"
alias g++="g++ -Wpedantic -Wall -Wextra -Wcast-align -Wduplicated-cond -Wlogical-op -Wswitch-enum"
alias fman='compgen -c | fzf | xargs man'
alias fls='exa -a | fzf'

alias catp='batcat -p'
alias cat='batcat'

alias ff='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}"'

alias mon='gotop'

alias cd="z"
# alias cdi="zi"
