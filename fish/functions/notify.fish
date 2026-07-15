function notify --description 'Run a command, then tmux display-message its completion (success or failure)'
    $argv
    set -l ret $status
    if test $ret -eq 0
        tmux display-message -l "[$argv[1]]: done"
    else
        tmux display-message -l "[$argv[1]]: failed (exit $ret)"
    end
    return $ret
end
