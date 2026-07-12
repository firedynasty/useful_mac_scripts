#!/bin/bash
# Cmd+3: Peek at collected clipboard  |  Cmd+2: Clear contents
FILE="$HOME/.clipboard_collect.md"
if [ -f "$FILE" ]; then
    COUNT=$(grep -c "^---$" "$FILE" 2>/dev/null || echo 0)
    CHARS=$(wc -m < "$FILE" | tr -d ' ')
    osascript -e "display notification \"${COUNT} entries, ${CHARS} chars — Cmd+2 to clear\" with title \"Clipboard Peek\""
    qlmanage -p "$FILE" &>/dev/null &
else
    osascript -e 'display notification "Nothing collected yet" with title "Clipboard Peek"'
fi
