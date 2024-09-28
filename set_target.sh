#!/bin/zsh

TARGET=$1
ZSHRC_FILE="/home/chandler/.zshrc"
HOSTS_FILE="/etc/hosts"
HOSTS_LINE="$TARGET target"

# Check if TARGET is provided
if [ -z "$TARGET" ]; then
    echo "Usage: set_target.sh <TARGET>"
    exit 1
fi

# Update .zshrc
if grep -q "^export TARGET=" "$ZSHRC_FILE"; then
    sed -i "s|^export TARGET=.*|export TARGET=$TARGET|" "$ZSHRC_FILE"
    echo "Updated TARGET variable in $ZSHRC_FILE."
else
    echo "export TARGET=$TARGET" >> "$ZSHRC_FILE"
    echo "Added TARGET variable to $ZSHRC_FILE."
fi

# Modify /etc/hosts with sudo
if grep -q "target" "$HOSTS_FILE"; then
    # Update the line if it exists
    sudo sed -i "s|^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} target|$HOSTS_LINE|" "$HOSTS_FILE"
    echo "Updated $HOSTS_LINE in $HOSTS_FILE."
else
    # Add the line if it does not exist
    echo "$HOSTS_LINE" | sudo tee -a "$HOSTS_FILE" > /dev/null
    echo "Added $HOSTS_LINE to $HOSTS_FILE."
fi

echo "Target setup completed."

