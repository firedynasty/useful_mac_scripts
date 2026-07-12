# Quick Action: Convert XLSX to CSVs

## Setup

1. Open **Automator** → **File → New** → **Quick Action**
2. Set **"Workflow receives current"** to **files or folders** in **Finder**
3. Add a **Run AppleScript** action
4. Paste the script below
5. Save as **convert_xlsx_to_csvs**

## AppleScript

```applescript
on run {input, parameters}
	if (count of input) > 0 then
		set shellScript to ""
		
		repeat with selectedFile in input
			set filePath to POSIX path of selectedFile
			set shellScript to shellScript & "~/bin/xlsx2csvs.sh " & quoted form of filePath & ";" & linefeed
		end repeat
		
		set shellScript to "zsh -i -c " & quoted form of shellScript
		
		tell application "Terminal"
			activate
			do script shellScript in front window
		end tell
		
	else
		display dialog "No XLSX files were selected." buttons {"OK"} default button "OK"
	end if
end run
```

## Helper script

The AppleScript calls `~/bin/xlsx2csvs.sh` which is already installed. It:

- Auto-installs `openpyxl` on first run
- Converts each sheet to a separate CSV
- Outputs CSVs to the same folder as the `.xlsx`
- Naming: `MyData.xlsx` → `MyData__Sheet1.csv`, `MyData__Sheet2.csv`, etc.

## Usage

Right-click any `.xlsx` file in Finder → **Quick Actions** → **convert_xlsx_to_csvs**
