-- Screenshot Float Toggle
-- Select a region to float it as always-on-top overlay
-- Cancel (Esc) to dismiss all existing floats
-- Delegates to the shell script which already has screen recording permission

do shell script "/Users/stanleytan/bin/screenshot_float.sh &> /dev/null &"
