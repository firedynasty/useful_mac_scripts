-- Speak Latest Screenshot (Toggle)
-- Press once to OCR + speak, press again to stop
-- Dependencies: tesseract, gtts-cli, mpg123
-- Karabiner: Command+Shift+8

on run
	try
	-- Check if mpg123 is currently playing
	set isPlaying to do shell script "pgrep mpg123 > /dev/null 2>&1 && echo 'yes' || echo 'no'"

	if isPlaying is "yes" then
		-- Stop playback
		do shell script "killall mpg123 2>/dev/null; killall gtts-cli 2>/dev/null; rm -f /tmp/screenshot_tts.mp3"
		display notification "Stopped" with title "Screenshot Reader"
	else
		-- Find the latest PNG file on Desktop
		set latestFile to do shell script "ls -t ~/Desktop/*.png 2>/dev/null | head -n1"

		if latestFile is "" then
			display notification "No PNG screenshots found on Desktop" with title "Screenshot Reader"
			return
		end if

		-- Show which file we're reading
		set fileName to do shell script "basename " & quoted form of latestFile
		display notification "Reading: " & fileName with title "Screenshot Reader"

		-- Run OCR with tesseract
		set ocrText to do shell script "/opt/homebrew/bin/tesseract " & quoted form of latestFile & " stdout 2>/dev/null"

		-- Trim whitespace
		set ocrText to do shell script "echo " & quoted form of ocrText & " | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'"

		if ocrText is "" then
			display notification "No text found in screenshot" with title "Screenshot Reader"
			return
		end if

		-- Copy extracted text to clipboard
		set the clipboard to ocrText

		-- Generate MP3 with gtts-cli and play with mpg123 in background
		do shell script "/Users/stanleytan/anaconda3/bin/gtts-cli " & quoted form of ocrText & " --output /tmp/screenshot_tts.mp3 2>/dev/null"
		do shell script "/opt/homebrew/bin/mpg123 /tmp/screenshot_tts.mp3 2>/dev/null &"
		do shell script "rm -f /tmp/screenshot_tts.mp3"
	end if

	on error errMsg
		display notification errMsg with title "Screenshot Reader Error"
	end try
end run
