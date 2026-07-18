#!/bin/bash
# Split clipboard into chunks of N lines and open each in a new Terminal tab
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

LINES_PER_CHUNK=32

CLIP=$(pbpaste)
if [ -z "$CLIP" ]; then
    osascript -e 'display notification "Clipboard is empty" with title "Clipboard Chunk"'
    exit 0
fi

TMPDIR=$(mktemp -d /tmp/clip_chunks.XXXXXX)
TOTAL_LINES=$(echo "$CLIP" | wc -l | tr -d ' ')

# Split into files of N lines each
echo "$CLIP" | split -l "$LINES_PER_CHUNK" - "$TMPDIR/chunk_"

# Rename to .txt for readability
COUNT=0
for f in "$TMPDIR"/chunk_*; do
    COUNT=$((COUNT + 1))
    mv "$f" "$f.txt"
done

if [ "$COUNT" -eq 0 ]; then
    osascript -e 'display notification "Nothing to split" with title "Clipboard Chunk"'
    rm -rf "$TMPDIR"
    exit 0
fi

# Open all chunks as tabs in Sublime Text
/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl "$TMPDIR"/chunk_*.txt

osascript -e "display notification \"${COUNT} tabs (${TOTAL_LINES} lines, ${LINES_PER_CHUNK} per chunk)\" with title \"Clipboard Chunk\""
