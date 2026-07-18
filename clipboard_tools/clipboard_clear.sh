#!/bin/bash
# Cmd+2: Show + clear collected clipboard  |  Cmd+3: Quick Look peek
FILE="$HOME/.clipboard_collect.md"
if [ -f "$FILE" ]; then
    CHARS=$(wc -m < "$FILE" | tr -d ' ')
    COUNT=$(grep -c "^---$" "$FILE" 2>/dev/null || echo 0)
    echo "=== Clipboard Collect ($COUNT entries, $CHARS chars) ==="
    echo ""
    cat "$FILE"
    echo ""
    echo "(Cmd+3 to Quick Look peek)"
    echo ""
    read -p "(y=copy+clear/n=keep/a=accumulator): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        cat "$FILE" | pbcopy
        pbpaste | pandoc --from markdown-tex_math_dollars --to plain --no-highlight | pbcopy
        rm "$FILE"
        echo "Converted to plain text, copied to clipboard, and cleared."
    elif [[ "$choice" == "a" || "$choice" == "A" ]]; then
        cat "$FILE" | pbcopy
        pbpaste | pandoc --from markdown-tex_math_dollars --to plain --no-highlight | pbcopy
        rm "$FILE"
        open "https://clipboard-manager-three.vercel.app/accumulator?import=1"
        echo "Copied to clipboard, cleared, and opened accumulator. Paste with auto-split."
    else
        echo "Kept."
    fi
else
    echo "Nothing collected yet."
    echo "(Use clipboard_collect_split.sh to open clipboard_collect.md chunks in Sublime tabs)"
fi
echo ""
echo "Workflow: accumulate with 1/2 → use '4' (clipboard_collect_split) to open chunks in Sublime tabs"
