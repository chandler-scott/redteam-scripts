#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <hostname/ip> <port>"
    exit 1
fi

# Assign variables from arguments
TARGET=$1
PORT=$2

OUTPUT_FILE="$HOME/target/port_$PORT"

# Wordlist to use (you can change this to any wordlist you'd like)
WORDLIST="/usr/share/wordlists/dirb/common.txt"

# Run gobuster directory scan
gobuster dir -u http://$TARGET:$PORT -w $WORDLIST -t 50 -x php,html,txt > $OUTPUT_FILE 2> /dev/null
