-- Record Microphone to MP3 (Toggle)
-- Press once to START recording, press again to STOP and save
-- Saves MP3 to ~/Downloads/spokenMp3Files/
-- Dependencies: sox (records directly to MP3, no ffmpeg needed)
-- Keyboard shortcut via Automator Quick Action
-- Uses Terminal.app + exec (shell replaced by sox = zero overhead, no buzz)
-- Matches working re/reco zsh functions: sox -t coreaudio "MacBook Air Microphone" output.mp3

on run {input, parameters}
	try
		set pidFile to "/tmp/mic_recorder.pid"
		set outputDir to "/Users/stanleytan/Downloads/spokenMp3Files"
		set mp3File to "/tmp/mic_recording_temp.mp3"

		-- Check if sox is already recording
		set isRecording to do shell script "
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

		if isRecording is "yes" then
			-- STOP recording: send INT signal to sox (same as Ctrl+C)
			set recPid to do shell script "cat " & quoted form of pidFile
			do shell script "kill -INT " & recPid & " 2>/dev/null; rm -f " & quoted form of pidFile

			-- Wait for sox to finish writing MP3
			delay 1.5

			-- Close the recorder Terminal window
			tell application "Terminal"
				set windowList to every window
				repeat with w in windowList
					if name of w contains "MIC_RECORDER" or name of w contains "sox" then
						close w
					end if
				end repeat
			end tell

			-- Move MP3 to final destination with timestamp
			do shell script "
				mkdir -p " & quoted form of outputDir & "
				timestamp=$(date '+Recording %Y-%m-%d at %I.%M.%S %p')
				mv " & quoted form of mp3File & " \"" & outputDir & "/${timestamp}.mp3\"
			"

			display notification "Recording saved!" with title "Mic Recorder"
		else
			-- START recording: open Terminal, exec sox to record directly to MP3
			-- exec replaces shell with sox (no shell overhead during recording)
			-- This matches how re/reco work: sox -t coreaudio "MacBook Air Microphone" output.mp3
			tell application "Terminal"
				do script "echo '\\033]0;MIC_RECORDER\\007'; echo 'Recording... press shortcut again to stop.'; echo $$ > " & pidFile & "; exec /opt/homebrew/bin/sox -t coreaudio \"MacBook Air Microphone\" " & mp3File
			end tell

			delay 0.5
			display notification "Recording started... press again to stop" with title "Mic Recorder"
		end if

	on error errMsg
		do shell script "rm -f /tmp/mic_recorder.pid /tmp/mic_recording_temp.mp3 2>/dev/null; killall sox 2>/dev/null"
		display notification errMsg with title "Mic Recorder Error"
	end try
	return input
end run
