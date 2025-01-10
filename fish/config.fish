if status is-interactive
end
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | batcat -l man -p'"
bind -M insert \cF accept-autosuggestion
set JAVA_HOME /usr/lib/jvm/java-1.21.0-openjdk-amd64
navi widget fish | source
starship init fish | source
