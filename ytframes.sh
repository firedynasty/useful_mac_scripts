#!/usr/bin/env bash
# ytframes.sh — download a YouTube video and extract frames at timestamps
# Usage: bash ytframes.sh <timestamps.txt>
# The txt file must have:
#   Line 1:  comma-separated timestamps  (e.g. 02:39,05:12,08:34)
#   ...
#   https:// URL line
#   Video title line
#   (optional notes below)

set -eu

txtFile="$1"

# ── parse txt file ────────────────────────────────────────────────────────────

tsLine=$(head -1 "$txtFile")
[[ -z "$tsLine" ]] && { echo "Error: no timestamps on line 1"; exit 1; }

url=$(grep -m1 '^https://' "$txtFile")
[[ -z "$url" ]] && { echo "Error: no URL found in $txtFile"; exit 1; }

urlLineNum=$(grep -n '^https://' "$txtFile" | head -1 | cut -d: -f1)
title=$(awk -v n="$urlLineNum" 'NR==n+1' "$txtFile")
notes=$(awk -v n="$urlLineNum" 'NR>n+1' "$txtFile" | sed '/./,$!d')

# ── output directory ──────────────────────────────────────────────────────────

dir="${txtFile%/*}"
dateStr=$(date +%m%d)
safeTitle=$(echo "${title:-video}" | sed 's/[^a-zA-Z0-9 _-]//g' | tr -s ' ' | sed 's/ /_/g' | cut -c1-50)
outDir="${dir}/${dateStr}-${safeTitle}_frames"
mkdir -p "$outDir"

# ── download video ────────────────────────────────────────────────────────────

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Downloading video (no-playlist)..."
/Users/stanleytan/anaconda3/bin/yt-dlp --no-playlist \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
    --merge-output-format mp4 \
    -o "$tmpdir/video.%(ext)s" \
    "$url"

videoFile=$(find "$tmpdir" -maxdepth 1 -name "video.*" | head -1)
[[ -z "$videoFile" ]] && { echo "Error: download failed"; exit 1; }

# ── write info.txt ────────────────────────────────────────────────────────────

echo "Writing info.txt..."
/Users/stanleytan/anaconda3/bin/yt-dlp --no-playlist --skip-download \
    --print 'Title: %(title)s' \
    --print 'Channel: %(channel)s' \
    --print 'Upload Date: %(upload_date>%Y-%m-%d)s' \
    --print 'Duration: %(duration_string)s' \
    --print 'View Count: %(view_count)s' \
    --print 'URL: %(webpage_url)s' \
    --print '' \
    --print 'Description:' \
    --print '%(description)s' \
    "$url" > "$outDir/info.txt" 2>/dev/null

if [[ -n "$notes" ]]; then
    printf '\n\nNotes:\n%s\n' "$notes" >> "$outDir/info.txt"
fi

# ── extract frames ────────────────────────────────────────────────────────────

echo "Extracting frames..."
n=1
echo "$tsLine" | tr ',' '\n' | while IFS= read -r ts || [[ -n "$ts" ]]; do
    ts=$(echo "$ts" | tr -d '[:space:]')
    [[ -z "$ts" ]] && continue
    secs=$(echo "$ts" | awk -F: '{if(NF==3) print $1*3600+$2*60+$3; else print $1*60+$2}')
    while [[ -e "${outDir}/frame_${n}.jpg" ]]; do n=$((n+1)); done
    /opt/homebrew/bin/ffmpeg -nostdin -ss "$secs" -i "$videoFile" -frames:v 1 -q:v 2 \
        "${outDir}/frame_${n}.jpg" 2>/dev/null
    echo "  frame_${n}.jpg  @ $ts"
    n=$((n+1))
done

echo ""
echo "Done! -> $outDir/"
open "$outDir"
