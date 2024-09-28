#!/bin/bash

TARGET=$1
IP_ADDRESS="192.168.1.10"  # Example IP Address; customize as needed

# Check if the TARGET argument is provided
if [ -z "$TARGET" ]; then
  echo "Usage: $0 TARGET"
  exit 1
fi

# Update or add the TARGET variable in .zshrc
ZSHRC="$HOME/.zshrc"
VAR_DECL="export TARGET=\"$TARGET\""

if grep -q "^export TARGET=" "$ZSHRC"; then
  sed -i "s|^export TARGET=.*|$VAR_DECL|" "$ZSHRC"
  echo "Updated TARGET variable in $ZSHRC."
else
  echo "$VAR_DECL" >> "$ZSHRC"
  echo "Added TARGET variable to $ZSHRC."
fi

# Add or update the target in /etc/hosts (IP_ADDRESS TARGET_ALIAS target)
HOSTS_LINE="$IP_ADDRESS $TARGET target"
if grep -q "$TARGET" /etc/hosts; then
  sed -i "/$TARGET/c\\$HOSTS_LINE" /etc/hosts
  echo "Updated $TARGET in /etc/hosts."
else
  echo "$HOSTS_LINE" >> /etc/hosts
  echo "Added $TARGET to /etc/hosts."
fi

# Reload .zshrc to apply changes
source "$ZSHRC"
echo "Target setup completed."

