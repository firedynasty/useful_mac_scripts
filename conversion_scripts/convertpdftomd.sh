on run {input, parameters}
    if (count of input) > 0 then
        set shellScript to ""

        repeat with selectedFile in input
            set filePath to POSIX path of selectedFile
            set dirPath to "\"$(dirname " & quoted form of filePath & ")\""
            set baseName to "\"$(basename " & quoted form of filePath & " .pdf)\""
            set shellScript to shellScript & "getpdftext " & quoted form of filePath & " " & dirPath & " && mv " & dirPath & "/" & baseName & ".txt " & dirPath & "/" & baseName & ".md;" & linefeed
        end repeat

        set shellScript to "zsh -i -c " & quoted form of shellScript

        tell application "Terminal"
            activate
            do script shellScript in front window
        end tell

    else
        display dialog "No PDF files were selected." buttons {"OK"} default button "OK"
    end if
end run
