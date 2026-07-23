-- App pair launcher: type a 1- or 2-letter code, each letter maps to an app.
-- One letter just activates that app. With two letters, app1 is activated
-- first (goes second in Cmd+Tab), app2 ends up frontmost.
-- c=Chrome  t=TextEdit  s=Sublime Text  f=Finder  o=Commander One  y=Typora  w=Word  l=Claude  e=Terminal

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
	return missing value
end appForLetter

-- Last used code is stored in ~/.app_pair_last_code and offered as the default
set prefsPath to (POSIX path of (path to home folder)) & ".app_pair_last_code"
set lastCode to "ct"
try
	set savedCode to read POSIX file prefsPath as «class utf8»
	if (length of savedCode) is 1 or (length of savedCode) is 2 then
		set lastCode to savedCode
	end if
end try

set choice to text returned of (display dialog "App code (1 letter = single app) — c:Chrome t:TextEdit s:Sublime f:Finder o:CmdrOne y:Typora w:Word l:Claude" default answer lastCode with title "Open app pair")

set codeLength to length of choice

if codeLength is not 1 and codeLength is not 2 then
	beep 1
	return
end if

set app1 to my appForLetter(character 1 of choice)
if app1 is missing value then
	beep 1
	return
end if

tell application app1 to activate

if codeLength is 2 then
	set app2 to my appForLetter(character 2 of choice)
	if app2 is missing value then
		beep 1
		return
	end if
	delay 0.2
	tell application app2 to activate
end if

-- Code worked — remember it for next time
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
