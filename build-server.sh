#!/bin/bash

#godot_path = "/Applications/Godot/Godot_4.2.2.app/Contents/MacOS/Godot"
project_path="/Users/eke/Game Dev/godot/adri_jack_game_v2"

echo "building [$1] server"

/Applications/Godot/Godot_4.2.2.app/Contents/MacOS/Godot --headless --export-debug "macOS_server"
