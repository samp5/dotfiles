if status is-interactive
end
set -x MANROFFOPT "-c"
bind -M insert \cF accept-autosuggestion
set JAVA_HOME /usr/lib/jvm/java-1.21.0-openjdk-amd64
navi widget fish | source
starship init fish | source
