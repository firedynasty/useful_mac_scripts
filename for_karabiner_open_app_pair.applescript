-- App pair launcher
-- F4 (no arg): shows dialog, saves letters to ~/.app_pair_f1, ~/.app_pair_f2, ~/.app_pair_f3
-- F1 (arg "f1"): reads ~/.app_pair_f1, activates that app
-- F2 (arg "f2"): reads ~/.app_pair_f2, activates that app
-- F3 (arg "f3"): reads ~/.app_pair_f3, activates that app
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
	set f1Path to (POSIX path of (path to home folder)) & ".app_pair_f1"
	set f2Path to (POSIX path of (path to home folder)) & ".app_pair_f2"
	set f3Path to (POSIX path of (path to home folder)) & ".app_pair_f3"
	
	-- F1, F2, or F3: read the corresponding file and activate the app
	if (count of argv) > 0 then
		set theArg to item 1 of argv
		
		if theArg is "f1" then
			set thePath to f1Path
		else if theArg is "f2" then
			set thePath to f2Path
		else if theArg is "f3" then
			set thePath to f3Path
		else
			beep 1
			return
		end if
		
		set theLetter to ""
		try
			set theLetter to read POSIX file thePath as Çclass utf8È
		end try
		
		if (length of theLetter) < 1 then
			beep 1
			return
		end if
		
		set theApp to my appForLetter(character 1 of theLetter)
		if theApp is missing value then
			beep 1
			return
		end if
		tell application theApp to activate
		return
	end if
	
	-- F4 (no arg): show dialog and save
	set lastCode to "cte"
	set savedF1 to ""
	set savedF2 to ""
	set savedF3 to ""
	try
		set savedF1 to read POSIX file f1Path as Çclass utf8È
	end try
	try
		set savedF2 to read POSIX file f2Path as Çclass utf8È
	end try
	try
		set savedF3 to read POSIX file f3Path as Çclass utf8È
	end try
	if (length of savedF1) > 0 or (length of savedF2) > 0 or (length of savedF3) > 0 then
		set lastCode to savedF1 & savedF2 & savedF3
	end if
	
	set choice to text returned of (display dialog "Set F1/F2/F3 apps Ñ c:Chrome e:Terminal g:Logos f:Finder l:Claude o:CmdrOne s:Sublime t:Textedit y:Typora" default answer lastCode with title "App pair setter (F4)")
	
	set codeLength to length of choice
	if codeLength < 1 or codeLength > 3 then
		beep 1
		return
	end if
	
	-- Validate letters
	set app1 to my appForLetter(character 1 of choice)
	if app1 is missing value then
		beep 1
		return
	end if
	if codeLength ³ 2 then
		set app2 to my appForLetter(character 2 of choice)
		if app2 is missing value then
			beep 1
			return
		end if
	end if
	if codeLength is 3 then
		set app3 to my appForLetter(character 3 of choice)
		if app3 is missing value then
			beep 1
			return
		end if
	end if
	
	-- Save letter 1 to f1 file
	try
		set fileRef to open for access POSIX file f1Path with write permission
		set eof of fileRef to 0
		write (character 1 of choice) to fileRef as Çclass utf8È
		close access fileRef
	on error
		try
			close access POSIX file f1Path
		end try
	end try
	
	-- Save letter 2 to f2 file (only if provided)
	if codeLength ³ 2 then
		try
			set fileRef to open for access POSIX file f2Path with write permission
			set eof of fileRef to 0
			write (character 2 of choice) to fileRef as Çclass utf8È
			close access fileRef
		on error
			try
				close access POSIX file f2Path
			end try
		end try
	end if
	
	-- Save letter 3 to f3 file (only if provided)
	if codeLength is 3 then
		try
			set fileRef to open for access POSIX file f3Path with write permission
			set eof of fileRef to 0
			write (character 3 of choice) to fileRef as Çclass utf8È
			close access fileRef
		on error
			try
				close access POSIX file f3Path
			end try
		end try
	end if
	
	-- Activate the app(s)
	tell application app1 to activate
	if codeLength ³ 2 then
		delay 0.2
		tell application app2 to activate
	end if
	if codeLength is 3 then
		delay 0.2
		tell application app3 to activate
	end if
end run
