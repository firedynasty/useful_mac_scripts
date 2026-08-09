-- App pair launcher
-- F3 (no arg): shows dialog, saves the 2-letter code to ~/.app_pair_last_code
-- F1 (arg "f1"): reads 1st letter from saved file, activates that app
-- F2 (arg "f2"): reads 2nd letter from saved file, activates that app
--
-- c=Chrome  t=TextEdit  s=Sublime Text  f=Finder  o=Commander One
-- y=Typora  w=Word  l=Claude  e=Terminal  g=Logos

on appForLetter(theLetter)
    if theLetter is "c" then return "Google Chrome"
    if theLetter is "t" then return "TextEdit"
    if theLetter is "s" then return "Sublime Text"
    if theLetter is "f" then return "Finder"
    if theLetter is "o" then return "Commander One"
    if theLetter is "y" then return "Typora"
    if theLetter is "w" then return "Microsoft Word"
    if theLetter is "l" then return "Claude"
    if theLetter is "e" then return "Terminal"
    if theLetter is "g" then return "Logos"
    return missing value
end appForLetter

on run argv
    set prefsPath to (POSIX path of (path to home folder)) & ".app_pair_last_code"

    -- F1 or F2: read saved code and activate the corresponding app
    if (count of argv) > 0 then
        set theArg to item 1 of argv

        set savedCode to ""
        try
            set savedCode to read POSIX file prefsPath as «class utf8»
        end try

        if (length of savedCode) < 1 then
            beep 1
            return
        end if

        if theArg is "f1" then
            set theLetter to character 1 of savedCode
        else if theArg is "f2" then
            if (length of savedCode) < 2 then
                beep 1
                return
            end if
            set theLetter to character 2 of savedCode
        else
            beep 1
            return
        end if

        set theApp to my appForLetter(theLetter)
        if theApp is missing value then
            beep 1
            return
        end if
        tell application theApp to activate
        return
    end if

    -- F3 (no arg): show dialog and save the code
    set lastCode to "ct"
    try
        set savedCode to read POSIX file prefsPath as «class utf8»
        if (length of savedCode) is 1 or (length of savedCode) is 2 then
            set lastCode to savedCode
        end if
    end try

    set choice to text returned of (display dialog "Set F1/F2 apps — c:Chrome e:Terminal g:Logos f:Finder l:Claude o:CmdrOne s:Sublime t:Textedit y:Typora" default answer lastCode with title "App pair setter (F3)")

    set codeLength to length of choice
    if codeLength is not 1 and codeLength is not 2 then
        beep 1
        return
    end if

    -- Validate letters before saving
    set app1 to my appForLetter(character 1 of choice)
    if app1 is missing value then
        beep 1
        return
    end if
    if codeLength is 2 then
        set app2 to my appForLetter(character 2 of choice)
        if app2 is missing value then
            beep 1
            return
        end if
    end if

    -- Save to file
    try
        set fileRef to open for access POSIX file prefsPath with write permission
        set eof of fileRef to 0
        write choice to fileRef as «class utf8»
        close access fileRef
    on error
        try
            close access POSIX file prefsPath
        end try
    end try

    -- Also activate the apps immediately (original behaviour)
    tell application app1 to activate
    if codeLength is 2 then
        delay 0.2
        tell application app2 to activate
    end if
end run
