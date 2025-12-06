if status is-interactive
    if string match -q -- '*ghostty*' $TERM
        set -g fish_vi_force_cursor 1
    end
end
set -x MANROFFOPT "-c"

set fish_cursor_default     block     
set fish_cursor_insert      block
set fish_cursor_replace_one underscore
set fish_cursor_visual      block
source ~/dotfiles/api_keys/set_api_keys.fish
bind -M insert \cF accept-autosuggestion
bind -M insert \cp history-search-backward
bind -M insert "alt-p" history-pager 
set JAVA_HOME /usr/lib/jvm/java-1.21.0-openjdk-amd64
navi widget fish | source
starship init fish | source
