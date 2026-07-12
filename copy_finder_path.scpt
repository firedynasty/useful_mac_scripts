tell application "Finder"
	try
		set currentFolder to (target of front window) as alias
		set targetPath to POSIX path of currentFolder
	on error
		set targetPath to POSIX path of (path to desktop)
	end try
end tell

if targetPath ends with "/" then
	set targetPath to text 1 thru -2 of targetPath
end if

set the clipboard to targetPath
display notification targetPath with title "Path Copied to Clipboard"
