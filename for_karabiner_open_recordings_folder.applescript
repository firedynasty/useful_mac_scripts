-- Open Recordings Folder
-- Opens ~/Downloads/spokenMp3Files/ in a new Finder window
-- Automator Quick Action

on run {input, parameters}
	try
		tell application "Finder"
			activate
			make new Finder window
			delay 0.5
			set target of front Finder window to (POSIX file "/Users/stanleytan/Downloads/spokenMp3Files/" as alias)
		end tell
	on error errMsg
		display notification errMsg with title "Open Recordings Folder Error"
	end try
	return input
end run
