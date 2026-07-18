#!/bin/bash
# Paste clipboard into collect file and split into Sublime tabs
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
FILE="$HOME/.clipboard_collect.md"

CLIP=$(pbpaste)
if [ -z "$CLIP" ]; then
    osascript -e 'display notification "Clipboard is empty" with title "Clipboard Split"'
    exit 0
fi

echo "$CLIP" > "$FILE"
COUNT=$(grep -c "^---$" "$FILE" 2>/dev/null || echo 0)
CHARS=$(wc -m < "$FILE" | tr -d ' ')
echo "Wrote clipboard ($COUNT entries, $CHARS chars) to $FILE"
echo "Workflow: copy to clipboard → go to /accumulator → Copy All → use '6' (clipboard_split) to split into Sublime tabs"

/Users/stanleytan/Desktop/admin_code/open_snippets.sh
