on run {input, parameters}
	set output to ""
	
	-- Sort and process each selected image file
	repeat with selectedFile in input
		set filePath to POSIX path of selectedFile
		set fileName to do shell script "basename " & quoted form of filePath
		
		-- Build markdown image link: ![name](filename)
		set nameWithoutExt to do shell script "echo " & quoted form of fileName & " | sed 's/\\.[^.]*$//'"
		set output to output & "![" & nameWithoutExt & "](" & fileName & ")" & linefeed
		set output to output & fileName & ":" & linefeed
	end repeat
	
	-- Copy to clipboard
	set the clipboard to output
	
	-- Show notification with count
	set fileCount to count of input
	display notification (fileCount as string) & " image path(s) copied to clipboard" with title "Images to MD Paths"
	
	return input
end run
