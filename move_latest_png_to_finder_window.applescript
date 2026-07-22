-- Move the most recently modified PNG on the Desktop
-- (searched recursively, including inside subfolders)
-- into the folder shown in the frontmost Finder window.

-- 1. Get the destination folder from the front Finder window
tell application "Finder"
	if (count of windows) is 0 then
		display dialog "No Finder window is open." buttons {"OK"} default button 1 with icon stop
		return
	end if
	set destFolder to (target of front window) as alias
	set destPath to POSIX path of destFolder
end tell

-- 2. Find the latest modified PNG on the Desktop, searching inside subfolders too
--    (ignoring hidden files/folders like .DS_Store, and never entering .app bundles)
set desktopPath to POSIX path of (path to desktop folder)
set latestFile to do shell script "find " & quoted form of desktopPath & " -type f -iname '*.png' -not -name '.*' -not -path '*/.*' -not -path '*.app/*' -print0 | xargs -0 ls -t 2>/dev/null | head -1"

if latestFile is "" then
	display dialog "No PNG files found on the Desktop or its subfolders." buttons {"OK"} default button 1 with icon caution
	return
end if

-- 3. If the front window is already the Desktop, nothing to do
if destPath is desktopPath then
	display dialog "The front Finder window is already showing the Desktop." buttons {"OK"} default button 1 with icon caution
	return
end if

-- 4. Move the file into the Finder window's folder
tell application "Finder"
	move (POSIX file latestFile) as alias to destFolder
end tell
