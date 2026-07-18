#!/bin/bash
# Read ~/.clipboard_collect.md and open each --- separated chunk as a Sublime tab
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
FILE="$HOME/.clipboard_collect.md"

if [ ! -f "$FILE" ] || [ ! -s "$FILE" ]; then
    osascript -e 'display notification "clipboard_collect.md is empty or missing" with title "Clipboard Collect Split"'
    exit 0
fi

TMPDIR=$(mktemp -d /tmp/collect_split.XXXXXX)

# Split by --- separator lines
awk -v dir="$TMPDIR" '
BEGIN { count=1; file=dir "/chunk_" sprintf("%03d",count) ".txt" }
/^---$/ {
    close(file)
    count++
    file=dir "/chunk_" sprintf("%03d",count) ".txt"
    next
}
{ print >> file }
' "$FILE"

# Remove empty files
find "$TMPDIR" -empty -delete

COUNT=$(ls "$TMPDIR" | wc -l | tr -d ' ')

if [ "$COUNT" -gt 0 ]; then
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl "$TMPDIR"/chunk_*.txt
    osascript -e "display notification \"${COUNT} chunks opened from clipboard_collect.md\" with title \"Clipboard Collect Split\""
else
    osascript -e 'display notification "No chunks found in clipboard_collect.md" with title "Clipboard Collect Split"'
    rm -rf "$TMPDIR"
fi
