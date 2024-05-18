bar {
    font Fira Code
    position top
    # When the status_command prints a new line to stdout, swaybar updates.
    # The default just shows the current date and time.
    status_command while ~/dotfiles/sway/scripts/sway_bar.sh; do sleep 1; done

    colors {
        background #1F1F28

        #                 border background text
        inactive_workspace #1F1F28 #32323200 #1F1F28
        focused_workspace #1F1F28 #7E9CD8 #1F1F28
        urgent_workspace  #7E9CD8 #1F1F28 #DCD7BA

    }
}
