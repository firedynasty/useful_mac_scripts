#!/bin/bash
FILE="$HOME/.clipboard_collect.md"
TITLE="${1:-Clipboard Appended}"
CLIP=$(pbpaste)
if [ -n "$CLIP" ]; then
    echo "$CLIP" >> "$FILE"
    printf "\n---\n\n" >> "$FILE"
    COUNT=$(grep -c "^---$" "$FILE" 2>/dev/null || echo 1)
    CHARS=$(wc -m < "$FILE" | tr -d ' ')
    osascript -e "display notification \"${COUNT} entries, ${CHARS} chars\" with title \"${TITLE}\""
fi
