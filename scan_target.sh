#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <hostname/ip>"
    exit 1
fi

TARGET=$1

# Set the target directory
TARGET_DIR="$HOME/target"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR does not exist."
    mkdir -p $TARGET_DIR
fi

OUTPUT_FILE="$TARGET_DIR/target_report"

# Validate if the argument is a valid IP address or hostname
if ! [[ "$TARGET" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [[ "$TARGET" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Error: Invalid IP address or hostname."
    exit 1
fi

echo "Scanning $TARGET..."
echo "Target: $TARGET" > $OUTPUT_FILE

# Run rustscan, filter the output, and process with awk
output=$(docker run -it --rm --name rustscan rustscan/rustscan:2.1.1 -a "$TARGET" | \
    grep Open | \
    awk '{print $2}' | \
    awk -F: '{print $2}') 

IFS=$'\n' read -r -d '' -a ports <<< "$output"

# Loop through the array
for port in "${ports[@]}"; do
    echo "Scanning port: $port"
    port_int=$(printf "%d" "$port" 2>/dev/null)
    sudo nmap -v -sV $TARGET -p $port_int | grep -E "$port_int/(tcp|udp)\s+open" >> $OUTPUT_FILE &
done




