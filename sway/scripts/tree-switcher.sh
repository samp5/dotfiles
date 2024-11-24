#!/bin/bash

# Function to get workspace name for a given window id
get_workspace_name() {
    local window_id=$1
    local workspace_name
    
    # Use jq to find the workspace name for the given window id
    workspace_name=$(swaymsg -t get_tree | jq -r "
        def find_workspace:
            if .type == \"workspace\" and 
                  (.nodes | any(recurse(.nodes[]?, .floating_nodes[]?) | 
                    select(.type==\"con\" or .type==\"floating_con\") | .id == $window_id)) then
                .name
            elif .nodes then
                (.nodes[] | find_workspace),
                (.floating_nodes[] | find_workspace)
            else
                empty
            end;
        find_workspace
    ")
    echo "$workspace_name"
}

# Get all windows
IFS=$'\n'
windows=($(swaymsg -t get_tree | jq -r '
    recurse(.nodes[]?) | 
    recurse(.floating_nodes[]?) | 
    select(.type=="con"), select(.type=="floating_con") | 
    select((.app_id != null) or .name != null) | 
    {id, app_id, name} | 
    .id, .app_id, .name
'))

# Build the selection string with workspace symbols
str=""
for ((i=0; i<"${#windows[@]}"; i=i+3)); do
    id="${windows[i]}"
    app_id="${windows[i+1]}"
    name="${windows[i+2]}"

    # Get workspace name for this window
    workspace_symbol=$(get_workspace_name "$id")

    building_string="$workspace_symbol  $id:"
    if [[ $app_id != "null" ]]; 
    then
        if [[ $app_id == "org.wezfurlong.wezterm" ]]
        then
          app_id="terminal"
        fi
        building_string="$building_string $app_id"
    fi
    if [[ $name != "null" ]];
    then
        building_string="$building_string : $name"
    fi
    str="$str$building_string\n" 
done

# Show rofi menu and get selection
selection=$(printf "$str" | rofi -p "Switch to a window" -dmenu)
[[ -z $selection ]] && exit

# Extract window ID from selection (now accounting for workspace symbol)
id=$(echo "$selection" | awk '{print $2}' | cut -d ":" -f1)
echo $id
[[ -z $id ]] && exit

# Focus the selected window
swaymsg "[con_id=$id]" focus
exit
