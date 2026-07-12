#!/bin/bash
# Opens every URL in tabs.txt as a new tab in Google Chrome.
# Usage: ./open_tabs.sh [path/to/tabs.txt]

FILE="${1:-/Users/stanleytan/Desktop/admin_code/tabs.txt}"

if [ ! -f "$FILE" ]; then
  echo "File not found: $FILE"
  exit 1
fi

grep -Eo 'https?://[^[:space:]]+' "$FILE" | while read -r url; do
  echo "Opening: $url"
  open -a "Google Chrome" "$url"
  sleep 0.3
done
