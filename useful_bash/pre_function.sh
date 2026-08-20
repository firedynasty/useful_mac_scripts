# pre() — numbered file navigation with fzf picker
# Usage:
#   pre        — fzf picker (Enter opens item, stays open; Esc to quit)
#   pre 3      — open item #3
#   pre 1 10   — open items 1–10
#
# Companion app: pre_in_finder_window.applescript
#   Opens Terminal at the front Finder window and runs pre()

_pre_open() {
    local n="$1"
    local selected
    selected=$(ls | sed -n "${n}p")
    [[ -z "$selected" ]] && { echo "✗ Nothing at position $n"; return 1; }

    if [[ -d "$selected" ]]; then
        local full_path
        full_path="$(cd "$selected" && pwd)"
        echo "[$n] → Opening new tab: $selected"
        osascript -e "
            tell application \"Terminal\"
                activate
                do script \"cd '$full_path' && clear && ls | nl -n ln -w2\"
            end tell
        "
    elif [[ -f "$selected" ]]; then
        echo "[$n] → Opening: $selected"
        open "$selected" 2>/dev/null || xdg-open "$selected" 2>/dev/null
    else
        echo "✗ Unknown item type: $selected"
        return 1
    fi
}

## Quick navigation by position number — single item or a range.
pre() {
    local a="$1" b="$2"

    # No argument: fzf picker — Enter opens item, stays open; Esc to quit
    if [[ -z "$a" ]]; then
        local tmpf
        tmpf=$(mktemp /tmp/pre_open_XXXXXX.sh)
        cat > "$tmpf" << 'HELPER'
#!/bin/zsh
item="$1"
if [[ -d "$item" ]]; then
    full="$(cd "$item" && pwd)"
    osascript \
        -e 'tell application "Terminal" to activate' \
        -e "tell application \"Terminal\" to do script \"cd '$full' && clear && ls | nl -n ln -w2\""
elif [[ -f "$item" ]]; then
    open "$item" 2>/dev/null
fi
HELPER
        chmod +x "$tmpf"
        ls | fzf --ansi \
            --preview 'f={}; if [[ -d "$f" ]]; then ls -la "$f"; elif [[ "$f" == *.docx ]]; then pandoc -t plain "$f" 2>/dev/null | head -200 || echo "[pandoc not found]"; else head -100 "$f" 2>/dev/null || echo "[binary]"; fi' \
            --preview-window 'right:50%:wrap' \
            --bind "enter:execute($tmpf {})"
        rm -f "$tmpf"
        return 0
    fi

    # Validate first arg
    if ! [[ "$a" =~ ^[0-9]+$ ]]; then
        echo "✗ Usage:"
        echo "  pre        — show numbered listing"
        echo "  pre 3      — open item #3"
        echo "  pre 1 10   — open items 1–10"
        return 1
    fi

    # Second arg optional; defaults to a single item
    local start="$a" end="$a"
    if [[ -n "$b" ]]; then
        if ! [[ "$b" =~ ^[0-9]+$ ]]; then
            echo "✗ End must be a number: pre $a [end]"
            return 1
        fi
        end="$b"
    fi

    # Allow reversed ranges (pre 10 1)
    if (( start > end )); then
        local tmp="$start"; start="$end"; end="$tmp"
    fi

    local total
    total=$(ls | wc -l | tr -d '[:space:]')
    if (( start < 1 || end > total )); then
        echo "✗ Range out of bounds (1-$total)"
        return 1
    fi

    local n
    for (( n = start; n <= end; n++ )); do
        _pre_open "$n"
        # sleep 0.3   # uncomment if Terminal opens windows instead of tabs
    done
}
