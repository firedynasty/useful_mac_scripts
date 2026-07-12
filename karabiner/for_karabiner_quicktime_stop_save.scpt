-- Stop the recording by clicking button 1
tell application "System Events"
	tell process "QuickTime Player"
		click button 1 of window 1
	end tell
end tell

-- Wait a moment for the stop to complete
delay 1

tell application "QuickTime Player"
	activate

	-- Create timestamp
	set currentDate to current date
	set timestamp to (year of currentDate as string) & "-" & ¬
		(month of currentDate as integer as string) & "-" & ¬
		(day of currentDate as string) & "_" & ¬
		(hours of currentDate as string) & "-" & ¬
		(minutes of currentDate as string) & "-" & ¬
		(seconds of currentDate as string)

	-- Set timestamp to clipboard
	set the clipboard to "Recording_" & timestamp
end tell

-- Use System Events for keystrokes
tell application "System Events"
	tell process "QuickTime Player"
		keystroke "s" using command down -- Open Save dialog
		delay 0.5
		keystroke "v" using command down -- Paste the filename
	end tell
end tell
