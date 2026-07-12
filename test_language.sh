#!/bin/bash

echo "Testing language extraction from karabiner_mappings.json"
echo "=====================================================>"

# Define the file path
CONFIG_FILE="/Users/stanleytan/Desktop/admin_code/karabiner_mappings.json"

# Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: File not found: $CONFIG_FILE"
    exit 1
fi

# Display the file content
echo "File content:"
cat "$CONFIG_FILE"
echo "=====================================================>"

# Try different grep patterns
echo "Pattern 1 result:"
grep -o '"language"\s*:\s*"[^"]*"' "$CONFIG_FILE"
echo "=====================================================>"

echo "Pattern 2 result:"
grep -o '"language"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE"
echo "=====================================================>"

echo "Pattern 3 result (simplest):"
grep -o '"language" *: *"[^"]*"' "$CONFIG_FILE"
echo "=====================================================>"

# Try jq if available
if command -v jq &> /dev/null; then
    echo "jq result:"
    jq -r '.language' "$CONFIG_FILE"
    echo "=====================================================>"
else
    echo "jq not installed, skipping jq test"
fi

echo "Test completed. Run this script to debug the language extraction."
echo "Execute with: bash /Users/stanleytan/Desktop/admin_code/test_language.sh"
