-- Run transcribe app and wait for it to finish, then activate Chrome
do shell script "open -W /Users/stanleytan/Desktop/admin_code/transcribe_latest_to_english_clip.app"

tell application "Google Chrome"
	activate
end tell
