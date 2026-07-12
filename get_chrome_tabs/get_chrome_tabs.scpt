tell application "Google Chrome"
	set output to ""
	set winIndex to 1
	repeat with w in windows
		set output to output & "--- Window " & winIndex & " ---" & linefeed
		set tabIndex to 1
		repeat with t in tabs of w
			set output to output & tabIndex & ". " & (title of t) & linefeed & "   " & (URL of t) & linefeed
			set tabIndex to tabIndex + 1
		end repeat
		set winIndex to winIndex + 1
		set output to output & linefeed
	end repeat
end tell

set outFile to (POSIX file "/Users/stanleytan/Desktop/admin_code/tabs.txt")
set fh to open for access outFile with write permission
set eof of fh to 0
write output to fh as «class utf8»
close access fh
return output
