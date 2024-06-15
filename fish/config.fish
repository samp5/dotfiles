if status is-interactive
end
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | batcat -l man -p'"
bind -M insert \cF accept-autosuggestion
navi widget fish | source
starship init fish | source
