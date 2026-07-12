# Automator Scripts for macOS Quick Actions

This directory contains AppleScript text files that are pasted into Automator's "Run AppleScript" action to create right-click Quick Actions in Finder.

## Existing Scripts

### `automator_script_from_mp3.txt`
- **Input**: MP3 audio file(s) via right-click in Finder
- **What it does**: Sends MP3 directly to Groq's Whisper API for transcription
- **Prompts**: "Include timestamps?" (Yes/No)
- **Output**: `.txt` file next to the input file
- **Python dependency**: `/Users/stanleytan/documents/technical/python/textToSpeech/transcribe_groq.py`

### `automator_script_create_subtitles.txt`
- **Input**: MP4 video file(s) via right-click in Finder
- **What it does**: Extracts audio with ffmpeg (16kHz mono 32kbps mp3), sends to Groq Whisper, cleans up temp audio
- **Prompts**: "Include timestamps?" (Yes/No)
- **Output**: `.txt` file next to the input file
- **Python dependency**: `/Users/stanleytan/documents/technical/python/textToSpeech/transcribe_groq.py`

## How to Create a New Automator Quick Action

1. Open **Automator** → New → **Quick Action**
2. Set "Workflow receives current" to the file type (e.g., `movie files`, `audio files`, `image files`, `files or folders`) in **Finder**
3. Add a **Run AppleScript** action
4. Paste the script contents from the `.txt` file
5. Save with a descriptive name (this becomes the right-click menu item)

## Script Pattern

All scripts follow this structure:

```applescript
on run {input, parameters}
    -- Guard: no files selected
    if (count of input) is 0 then
        display dialog "No files were selected." buttons {"OK"} default button "OK"
        return
    end if

    -- Optional: prompt user for options via display dialog
    -- set someChoice to button returned of (display dialog "..." buttons {"Cancel", "No", "Yes"} default button "Yes")

    set shellScript to ""

    repeat with selectedFile in input
        set filePath to POSIX path of selectedFile

        -- Build shell commands
        -- Use quoted form of filePath for paths with spaces
        -- Chain with && (fail-fast) or ; (continue on error)
        set shellScript to shellScript & "echo '=== Processing ===' && "
        set shellScript to shellScript & "YOUR_COMMAND_HERE " & quoted form of filePath & " ; "
    end repeat

    tell application "Terminal"
        activate
        do script shellScript in front window
    end tell
end run
```

## Key Conventions

- **Python path**: `/Users/stanleytan/anaconda3/bin/python3`
- **ffmpeg path**: `/opt/homebrew/bin/ffmpeg`
- **API keys**: Stored as env vars in `~/.zshrc` (e.g., `$GROQ_API_KEY`, `$OPENAI_API_KEY`)
- **Output location**: Same directory as input file, same base name with new extension
- **File naming**: `automator_script_<description>.txt`
- **User prompts**: Use `display dialog` with `buttons` for choices, `default answer` for text input — keep prompts minimal
- **Shell execution**: Commands run in Terminal so user can see progress; use `quoted form of` for paths with spaces
- **Multi-file support**: `repeat with selectedFile in input` handles batch processing
- **Python scripts**: Store reusable Python in `/Users/stanleytan/documents/technical/python/textToSpeech/` and call from AppleScript

## Common Patterns for New Scripts

### Calling a Python script on each file
```applescript
set shellScript to shellScript & "/Users/stanleytan/anaconda3/bin/python3 /path/to/script.py " & quoted form of filePath & " ; "
```

### Generating output path with new extension
```applescript
set baseName to do shell script "f=" & quoted form of filePath & "; echo \"${f%.*}\""
set outputPath to quoted form of (baseName & ".new_ext")
```

### Auto-incrementing output name (_1, _2, etc.)
```applescript
set outputPath to do shell script "f=" & quoted form of filePath & "; name=\"${f%.*}\"; ext=\"${f##*.}\"; n=1; while [ -e \"${name}_${n}.${ext}\" ]; do n=$((n+1)); done; echo \"${name}_${n}.${ext}\""
```

### Extracting audio from video before processing
```applescript
set shellScript to shellScript & "/opt/homebrew/bin/ffmpeg -y -i " & quoted form of filePath & " -vn -ar 16000 -ac 1 -b:a 32k " & audioPath & " && "
```
