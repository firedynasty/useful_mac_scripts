tell application "Finder"
    try
        set theFolder to POSIX path of (folder of the front window as alias)
        set theDate to do shell script "date '+%Y-%m-%d at %-l.%M.%S %p'"
        set targetFile to theFolder & "Screenshot " & theDate & ".txt"

        do shell script "pbpaste > " & quoted form of targetFile

        select (POSIX file targetFile as alias)
    on error
        display dialog "No Finder window is open." buttons {"OK"}
    end try
end tell
