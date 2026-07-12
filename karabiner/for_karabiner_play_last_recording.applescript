-- Play Last Recording (Toggle)
-- Press once to PLAY the most recent recording, press again to STOP
-- Looks in ~/Downloads/spokenMp3Files/ for the latest MP3
-- Automator Quick Action

on run {input, parameters}
	try
		set latestFile to do shell script "ls -t \"$HOME/Downloads/spokenMp3Files/\"*.mp3 2>/dev/null | head -n1"

		if latestFile is "" then
			display notification "No recordings found in spokenMp3Files" with title "Recording Player"
			return input
		end if

		set fileName to do shell script "basename " & quoted form of latestFile
		display notification "Playing: " & fileName with title "Recording Player"

		do shell script "open " & quoted form of latestFile

	on error errMsg
		display notification errMsg with title "Recording Player Error"
	end try
	return input
end run
