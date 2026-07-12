set appList to {"Sublime Text", "Claude", "Terminal", "TextEdit", "Typora", "Finder", "Preview", "VS Code", "Notion", "Safari", "Microsoft Word"}

set chosen to choose from list appList with prompt "Switch Chrome with:" default items {"Sublime Text"}
if chosen is false then return
set partnerApp to item 1 of chosen

do shell script "echo " & quoted form of partnerApp & " > ~/.word_partner_app"

tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

if frontApp is not "Google Chrome" then
	tell application "Google Chrome" to activate
else
	tell application partnerApp to activate
end if
