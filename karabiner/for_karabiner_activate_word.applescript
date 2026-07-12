try
	set partnerApp to do shell script "cat ~/.word_partner_app"
on error
	set partnerApp to "Google Chrome"
end try

tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

if frontApp is not "Google Chrome" then
	tell application "Google Chrome" to activate
else
	tell application partnerApp to activate
end if
