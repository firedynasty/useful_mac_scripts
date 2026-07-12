-- Read Clipboard Aloud (Toggle App)
-- Save as Application in Script Editor, then add to Dock
-- Click once: reads clipboard text aloud using macOS TTS
-- Click again: stops reading
-- Clipboard contents remain intact for highlight-and-read workflow

on run
	try
		set pidFile to "/tmp/clipboard_reader.pid"

		-- Check if say is already running
		set isReading to do shell script "
if [ -f " & quoted form of pidFile & " ]; then
    pid=$(cat " & quoted form of pidFile & ")
    if kill -0 $pid 2>/dev/null; then
        echo 'yes'
    else
        rm -f " & quoted form of pidFile & "
        echo 'no'
    fi
else
    echo 'no'
fi
"

		if isReading is "yes" then
			-- STOP reading
			set readerPid to do shell script "cat " & quoted form of pidFile
			do shell script "kill " & readerPid & " 2>/dev/null; rm -f " & quoted form of pidFile
			display notification "Stopped reading." with title "Read Clipboard"
		else
			-- START reading clipboard contents
			set clipText to the clipboard as text

			if clipText is "" then
				display notification "Clipboard is empty." with title "Read Clipboard"
				return
			end if

			-- Write clipboard text to temp file using AppleScript (safe for any content)
			set tmpTextFile to "/tmp/clipboard_reader_text.txt"
			set fileRef to open for access POSIX file tmpTextFile with write permission
			set eof fileRef to 0
			write clipText to fileRef as «class utf8»
			close access fileRef

			-- Start say in background, save PID
			do shell script "/usr/bin/say -f " & quoted form of tmpTextFile & " > /dev/null 2>&1 & echo $! > " & quoted form of pidFile

			display notification "Reading clipboard aloud..." with title "Read Clipboard" subtitle "Click again to stop"
		end if

	on error errMsg
		do shell script "rm -f /tmp/clipboard_reader.pid 2>/dev/null; killall say 2>/dev/null"
		display dialog "Error: " & errMsg buttons {"OK"} default button "OK" with title "Read Clipboard Error" with icon stop
	end try
end run
