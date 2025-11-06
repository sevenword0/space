#!/bin/bash

# ========================================
# Depth Estimation Viewer - Mac Launcher
# ========================================

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create AppleScript to run in Terminal
osascript <<EOF
tell application "Terminal"
    activate
    do script "cd '$SCRIPT_DIR' && bash start.sh"
end tell
EOF
