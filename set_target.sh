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
# Check if the target is already listed
if ! grep -qE "^[[:space:]]*$TARGET[[:space:]]+target" "$HOSTS_FILE"; then
    echo "$HOSTS_LINE" | sudo tee -a "$HOSTS_FILE" > /dev/null
    echo "Added $HOSTS_LINE to $HOSTS_FILE."
else
    echo "$HOSTS_LINE already exists in $HOSTS_FILE."
fi

echo "Target setup completed."
