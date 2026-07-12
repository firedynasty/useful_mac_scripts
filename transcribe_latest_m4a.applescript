-- Transcribe Latest .m4a from Desktop (Cantonese)
-- Save as Application in Script Editor, then add to Dock
-- Finds latest .m4a on Desktop → converts → transcribes Cantonese with whisper-cpp → copies text to clipboard
-- Dependencies: whisper-cpp (brew install whisper-cpp)
-- Model: ggml-large-v3.bin required for Cantonese (yue) support

on run
	try
		set desktopPath to (POSIX path of (path to desktop folder))
		set whisperModel to "/opt/homebrew/share/whisper-cpp/ggml-large-v3.bin"
		set tempWav to "/tmp/transcribe_temp.wav"

		-- Find the latest .m4a file on Desktop
		set latestM4a to do shell script "ls -t " & quoted form of desktopPath & "*.m4a 2>/dev/null | head -1"

		if latestM4a is "" then
			display dialog "No .m4a files found on Desktop." buttons {"OK"} default button "OK" with title "Transcribe M4A" with icon stop
			return
		end if

		set fileName to do shell script "basename " & quoted form of latestM4a

		display notification "Converting & transcribing (粵語): " & fileName with title "Transcribe M4A"

		-- Convert .m4a to .wav using macOS built-in afconvert
		do shell script "/usr/bin/afconvert -f WAVE -d LEI16@16000 -c 1 " & quoted form of latestM4a & " " & quoted form of tempWav

		-- Transcribe with whisper-cpp (Cantonese)
		set transcription to do shell script "/opt/homebrew/bin/whisper-cli -m " & quoted form of whisperModel & " -f " & quoted form of tempWav & " --no-timestamps -l yue 2>/dev/null"

		-- Trim whitespace
		set transcription to do shell script "echo " & quoted form of transcription & " | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'"

		-- Copy to clipboard
		set the clipboard to transcription

		-- Clean up temp file
		do shell script "rm -f " & quoted form of tempWav

		display notification "Copied to clipboard!" with title "Transcribe M4A" subtitle fileName

	on error errMsg
		do shell script "rm -f /tmp/transcribe_temp.wav 2>/dev/null"
		display dialog "Error: " & errMsg buttons {"OK"} default button "OK" with title "Transcribe M4A Error" with icon stop
	end try
end run
