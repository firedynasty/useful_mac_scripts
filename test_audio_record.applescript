-- Test Audio Recorder (Toggle)
-- Run once to START (opens Terminal), run again to STOP and save MP3
-- Open in Script Editor and click Play to test
-- Uses Terminal.app so sox runs in a real session (no buzz)

on run
	try
		set pidFile to "/tmp/mic_recorder.pid"
		set wavFile to "/tmp/clipboard_recording.wav"
		
		-- Check if a recording is running via PID file
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
			-- STOP recording: send Ctrl+C (INT signal) to sox
			set recPid to do shell script "cat " & quoted form of pidFile
			do shell script "kill -INT " & recPid & " 2>/dev/null; rm -f " & quoted form of pidFile
			
			-- Wait for sox to finish writing
			delay 1.5
			
			-- Close the recorder Terminal window
			tell application "Terminal"
				set windowList to every window
				repeat with w in windowList
					if name of w contains "MIC_RECORDER" then
						close w
					end if
				end repeat
			end tell
			
			-- Convert WAV to MP3 and save with timestamp
			set savedPath to do shell script "
				timestamp=$(date '+Recording %Y-%m-%d at %I.%M.%S %p')
				destination=\"/Users/stanleytan/Downloads/spokenMp3Files/${timestamp}.mp3\"
				/opt/homebrew/bin/ffmpeg -i " & quoted form of wavFile & " -codec:a libmp3lame -qscale:a 2 \"$destination\" -y 2>/dev/null
				rm -f " & quoted form of wavFile & "
				echo \"$destination\"
			"
			
			display notification "Recording saved!" with title "Mic Recorder"
			display dialog "Recording stopped and saved to:" & return & savedPath buttons {"Open Folder", "OK"} default button "OK"
			
			if button returned of result is "Open Folder" then
				do shell script "open /Users/stanleytan/Downloads/spokenMp3Files/"
			end if
		else
			-- START recording: open Terminal and run sox in the FOREGROUND (no backgrounding = no buzz)
			-- Uses exec so the shell PID becomes the sox PID (written to pidFile before exec)
			tell application "Terminal"
				set recWindow to do script "echo '\\033]0;MIC_RECORDER\\007'; echo 'Recording... run script again to stop.'; echo $$ > " & pidFile & "; exec /opt/homebrew/bin/sox -t coreaudio \"MacBook Air Microphone\" " & wavFile
			end tell
			
			delay 0.5
			display notification "Recording started... run script again to stop" with title "Mic Recorder"
			display dialog "Recording in progress..." & return & "Click Play again in Script Editor to STOP and save." buttons {"OK"} default button "OK"
		end if
		
	on error errMsg
		-- Clean up on error
		do shell script "rm -f /tmp/mic_recorder.pid 2>/dev/null; killall sox 2>/dev/null"
		display notification errMsg with title "Mic Recorder Error"
		display dialog "Error: " & errMsg buttons {"OK"} default button "OK"
	end try
end run
