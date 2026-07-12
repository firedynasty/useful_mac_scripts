#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/Users/stanleytan/Desktop/admin_code/karabiner_mappings.json"

# Extract ONLY the value part of the language setting
LANGUAGE=$(grep -o '"language"[^"]*"[^"]*"' "$CONFIG_FILE" | sed 's/.*"language"[^"]*"\([^"]*\)".*/\1/')

# Debug: output what we found to a log file
echo "Found language: $LANGUAGE" > /tmp/language_debug.log

# Default to English if no language is found
if [ -z "$LANGUAGE" ]; then
    echo "No language found, defaulting to english" >> /tmp/language_debug.log
    LANGUAGE="english"
fi

# Output the language
echo "$LANGUAGE"