#!/bin/zsh

# Get the directory of the install.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="/usr/scripts"
ZSHRC_FILE="$HOME/.zshrc"

# Create the target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p "$TARGET_DIR"
fi

# Link all .sh files from the scripts directory to /usr/scripts
echo $SCRIPT_DIR
for script in "$SCRIPT_DIR"/*.sh; do
    if [ -f "$script" ]; then
        sudo ln -sf "$script" "$TARGET_DIR/$(basename $script)"
    fi
done

# Add /usr/scripts to .bashrc if it doesn't already exist
if ! grep -q "$TARGET_DIR" "$ZSHRC_FILE"; then
    echo "export PATH=\$PATH:$TARGET_DIR" >> "$ZSHRC_FILE"
    echo "/usr/scripts added to PATH in .zshrc"
fi

# Reload .bashrc
source "$ZSHRC_FILE"

