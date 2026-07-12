# useful_mac_scripts

Backup of macOS automation scripts, keyboard shortcuts, and productivity tools.

## Structure

- `karabiner/` — Karabiner-Elements config and all keyboard shortcut AppleScripts
- `automator_scripts/` — Shell commands for rebuilding Automator Quick Actions/Services
- `clipboard_tools/` — Clipboard accumulator system (append, peek, clear)
- `conversion_scripts/` — ffmpeg/pandoc commands for file conversion
- `email_scripts/` — Mail.app AppleScript automation
- `speaking_languages/` — Language switching and dictionary lookup
- `variable_for_reading/` — Per-language TTS scripts
- `current_services/` — Image-to-markdown path generators
- `tracking_time_scripts/` — Time tracking AppleScripts
- `get_chrome_tabs/` — Save/restore Chrome tabs
- `echo_files/` — Variable storage mechanism
- `bash_filePaths/` — Saved directory navigation paths

## Key Tools

- **Karabiner shortcuts**: 130+ keyboard-triggered AppleScripts for app switching, TTS, recording, transcription
- **Clipboard accumulator**: Collect multiple clips, export as plain text
- **Audio/Video**: Trim, extract, overlay classical music, create subtitles via Groq transcription
- **TTS**: Kokoro Python TTS, macOS `say` command, multi-language support
- **Transcription**: whisper-cpp local, Groq API remote
- **File conversion**: PDF to MD, images to MP4, MP4 to images, XLSX to CSV
