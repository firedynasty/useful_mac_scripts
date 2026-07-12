on run {input, parameters}
	set output to ""
	
	-- Get the parent folder name from the first selected file
	if (count of input) > 0 then
		set firstFile to item 1 of input as alias
		tell application "Finder"
			set parentFolder to (container of firstFile) as alias
			set folderName to name of parentFolder
		end tell
	else
		display notification "No files selected" with title "Images to MD Paths"
		return input
	end if
	
	-- Process each selected image file
	repeat with selectedFile in input
		set filePath to POSIX path of selectedFile
		set fileName to do shell script "basename " & quoted form of filePath
		
		-- Build markdown image link: ![name](./folder/filename)
		set nameWithoutExt to do shell script "echo " & quoted form of fileName & " | sed 's/\\.[^.]*$//'"
		set output to output & "![" & nameWithoutExt & "](./" & folderName & "/" & fileName & ")" & linefeed
		set output to output & fileName & ":" & linefeed
	end repeat
	
	-- Copy to clipboard
	set the clipboard to output
	
	-- Show notification with count
	set fileCount to count of input
	display notification (fileCount as string) & " image path(s) copied to clipboard" with title "Images to MD Paths (with folder)"
	
	return input
end run
