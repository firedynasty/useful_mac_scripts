-- Stop Screenshot Reader / TTS playback
-- Kills mpg123 and gtts-cli processes
-- Karabiner: Command+Shift+9

do shell script "killall mpg123 2>/dev/null; killall gtts-cli 2>/dev/null; rm -f /tmp/screenshot_tts.mp3"
display notification "Stopped" with title "Screenshot Reader"
