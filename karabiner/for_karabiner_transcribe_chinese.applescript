-- Transcribe Chinese (Mandarin) Audio to Text
-- Right-click Quick Action: "workflow receives audio files in any application"
-- Uses whisper-cpp to transcribe Mandarin Chinese, saves .txt next to the original file
-- Supports: mp3, wav, flac, ogg

on run {input, parameters}
	try
		set whisperModel to "/opt/homebrew/share/whisper-cpp/ggml-large-v3.bin"

		repeat with audioFile in input
			set filePath to POSIX path of audioFile
			set fileName to do shell script "basename " & quoted form of filePath
			display notification "Transcribing (中文): " & fileName with title "Whisper Transcribe"

			-- whisper-cli outputs to <input>.txt with -otxt flag
			do shell script "/opt/homebrew/bin/whisper-cli -m " & quoted form of whisperModel & " -f " & quoted form of filePath & " --no-timestamps -otxt -l zh 2>/dev/null"

			-- Rename from <file>.mp3.txt to <file>.txt
			set txtFileOld to filePath & ".txt"
			set txtFile to do shell script "echo " & quoted form of filePath & " | sed 's/\\.[^.]*$/.txt/'"
			do shell script "mv " & quoted form of txtFileOld & " " & quoted form of txtFile
			set txtName to do shell script "basename " & quoted form of txtFile
			display notification "Saved: " & txtName with title "Whisper Transcribe"
		end repeat

	on error errMsg
		display notification errMsg with title "Whisper Transcribe Error"
	end try
	return input
end run
