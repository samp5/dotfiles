
set -x MANROFFOPT "-c"

set fish_cursor_default     block     
set fish_cursor_insert      block
set fish_cursor_replace_one underscore
set fish_cursor_visual      block

bind -M insert \cF accept-autosuggestion
bind -M insert \cp history-search-backward
bind -M insert "alt-p" history-pager 
eval (ssh-agent -c) > /dev/null
starship init fish | source
