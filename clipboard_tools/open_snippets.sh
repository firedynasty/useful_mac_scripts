#!/bin/bash
# Split clipboard accumulator sections into temp files and open in Sublime Text
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
FILE="$HOME/.clipboard_collect.md"

if [ ! -f "$FILE" ] || [ ! -s "$FILE" ]; then
    osascript -e 'display notification "No snippets found" with title "Open Snippets"'
    exit 0
fi

TMPDIR=$(mktemp -d /tmp/snippets.XXXXXX)
COUNT=0

# Split by --- separator lines
awk -v dir="$TMPDIR" '
BEGIN { count=1; file=dir "/snippet_" sprintf("%03d",count) ".txt" }
/^---$/ {
    close(file)
    count++
    file=dir "/snippet_" sprintf("%03d",count) ".txt"
    next
}
{ print >> file }
' "$FILE"

# Remove empty files
find "$TMPDIR" -empty -delete

COUNT=$(ls "$TMPDIR" | wc -l | tr -d ' ')

if [ "$COUNT" -gt 0 ]; then
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl "$TMPDIR"/snippet_*.txt
    osascript -e "display notification \"${COUNT} snippets opened\" with title \"Open Snippets\""
else
    osascript -e 'display notification "No snippets found" with title "Open Snippets"'
    rm -rf "$TMPDIR"
fi
