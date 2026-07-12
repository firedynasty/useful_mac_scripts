

```applescript
tell application "Mail"
	activate
	
	-- Loop through all accounts to find the test mailbox
	set testMailboxFound to false
	set theTestMailbox to missing value
	
	repeat with mailAccount in accounts
		set mailboxesList to mailboxes of mailAccount
		repeat with mailboxItem in mailboxesList
			if name of mailboxItem is "test" then
				set theTestMailbox to mailboxItem
				set testMailboxFound to true
				exit repeat
			end if
		end repeat
		if testMailboxFound then exit repeat
	end repeat
	
	-- Check if the test mailbox was found
	if testMailboxFound then
		-- Get the selected messages
		set selectedMessages to selection
		if (count of selectedMessages) > 0 then
			-- Move the selected messages to the test mailbox
			repeat with theMessage in selectedMessages
				move theMessage to theTestMailbox
			end repeat
			display dialog "Selected messages moved to the 'test' mailbox."
		else
			display dialog "No messages selected."
		end if
	else
		display dialog "Test mailbox not found."
	end if
end tell

```
description : this code moves it to test

```applescript

tell application "Mail"
	activate
	
	-- Get the selected messages
	set selectedMessages to selection
	if (count of selectedMessages) > 0 then
		-- Delete the selected messages
		repeat with theMessage in selectedMessages
			delete theMessage
		end repeat
		display dialog "Selected messages deleted."
	else
		display dialog "No messages selected."
	end if
end tell

```
description : this code deletes the selected messages
