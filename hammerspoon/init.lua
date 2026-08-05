hs.hotkey.bind({"cmd", "ctrl", "shift"}, "m", function()
    local output = hs.audiodevice.defaultOutputDevice()
    output:setMuted(not output:muted())
end)

-- Dictation: F5 to start/stop recording → transcribe with whisper → AI cleanup → clipboard
local recording = false
local wavFile = "/tmp/mic_dictation_temp.wav"
local textFile = "/tmp/mic_dictation_text.tmp"
local recordJob = nil
local whisperModel = "/opt/homebrew/share/whisper-cpp/ggml-base.bin"

hs.hotkey.bind({}, "F5", function()
  local output = hs.audiodevice.defaultOutputDevice()
  if not recording then
    recording = true
    output:setMuted(true)
    hs.alert.show("🎙 Recording...")
    recordJob = hs.task.new("/opt/homebrew/bin/sox", nil,
      {"-t", "coreaudio", "MacBook Air Microphone", "-r", "16000", "-c", "1", "-b", "16", wavFile})
    recordJob:start()
  else
    recording = false
    output:setMuted(false)
    hs.alert.show("⏳ Transcribing...")
    recordJob:terminate()

    hs.timer.doAfter(1.5, function()
      -- Step 1: Whisper transcription (F5 flow)
      hs.task.new("/bin/sh", function(code, stdout, stderr)
        local text = (stdout or ""):match("^%s*(.-)%s*$")
        if text and #text > 0 then
          -- Write text to temp file so Python can read it safely (avoids shell escaping issues)
          local f = io.open(textFile, "w")
          f:write(text)
          f:close()

          -- Step 2: AI cleanup via Groq llama-3.3-70b-versatile
          local pyScript = [[
import json, urllib.request, os, sys

text = open(']] .. textFile .. [[').read().strip()
data = json.dumps({
  'model': 'llama-3.3-70b-versatile',
  'messages': [
    {'role': 'system', 'content': 'You are a transcription corrector. Fix only obvious speech-to-text errors such as wrong words that sound similar (e.g. "tick" instead of "take"). Do not rephrase or add anything. Return only the corrected text.'},
    {'role': 'user', 'content': text}
  ]
}).encode()

req = urllib.request.Request(
  'https://api.groq.com/openai/v1/chat/completions',
  data=data,
  headers={
    'Authorization': 'Bearer ' + os.environ['GROQ_API_KEY'],
    'Content-Type': 'application/json'
  }
)
resp = json.loads(urllib.request.urlopen(req).read())
print(resp['choices'][0]['message']['content'], end='')
]]

          hs.task.new("/bin/sh", function(code2, stdout2, stderr2)
            local cleaned = (stdout2 or ""):match("^%s*(.-)%s*$")
            if cleaned and #cleaned > 0 and cleaned ~= "null" then
              hs.pasteboard.setContents(cleaned)
            else
              hs.pasteboard.setContents(text)  -- fallback to original whisper text
            end
            hs.eventtap.keyStroke({"cmd"}, "v")
            os.remove(wavFile)
            os.remove(textFile)
          end, {"-c", "source ~/.zshrc && python3 -c '" .. pyScript:gsub("'", "'\\''") .. "'"}):start()

        else
          hs.alert.show("❌ No transcription")
          os.remove(wavFile)
        end
      end, {"-c", "/opt/homebrew/bin/whisper-cli -m '" .. whisperModel .. "' -f '" .. wavFile .. "' --no-timestamps -l auto 2>/dev/null"}):start()
    end)
  end
end)

-- Type-to-TextEdit: ctrl+option+` → prompt → append to front TextEdit doc
hs.hotkey.bind({"ctrl", "alt"}, "`", function()
  local ok, result = hs.osascript.applescript([[
    set dialogResult to display dialog "Append to TextEdit:" default answer "" buttons {"Cancel", "Append"} default button "Append" with title "TextEdit Input"
    return text returned of dialogResult
  ]])
  if ok and result and #result > 0 then
    hs.pasteboard.setContents(result)
    hs.osascript.applescript([[
      tell application "TextEdit"
        if (count of documents) > 0 then
          set text of document 1 to (text of document 1) & return & (the clipboard) & return
        else
          make new document
          set text of document 1 to (the clipboard)
        end if
      end tell
    ]])
    hs.alert.show("✅ Added to TextEdit")
  end
end)

-- Accumulator editor: ctrl+option+9 → pull from Dropbox → edit in modal → save back
local accumulatorView = nil
local accDropboxPath = "dropbox:/vercel/imageNotes(flashcards)/notes.txt"
local accTmpFile = "/tmp/imageNotes_hammerspoon.txt"

local function htmlEncode(s)
  return s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

hs.hotkey.bind({"ctrl", "alt"}, "9", function()
  if accumulatorView and accumulatorView:isVisible() then
    accumulatorView:delete()
    accumulatorView = nil
    return
  end

  hs.alert.show("⏳ Loading accumulator...")

  hs.task.new("/bin/sh", function(code, stdout, stderr)
    local content = stdout or ""
    local encodedContent = htmlEncode(content)

    local html = string.format([[<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: #1e1e1e; color: #d4d4d4; font-family: monospace; display: flex; flex-direction: column; height: 100vh; }
  #toolbar { padding: 8px 12px; background: #252526; display: flex; gap: 8px; align-items: center; border-bottom: 1px solid #3c3c3c; }
  #toolbar span { flex: 1; font-size: 12px; color: #888; }
  button { padding: 5px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 500; }
  #saveBtn { background: #0e7a0d; color: white; }
  #saveBtn:hover { background: #12a010; }
  #closeBtn { background: #444; color: #ccc; }
  #closeBtn:hover { background: #555; }
  textarea { flex: 1; width: 100%%; background: #1e1e1e; color: #d4d4d4; border: none; border-top: 2px solid transparent; padding: 12px 16px; font-family: 'SF Mono', monospace; font-size: 13px; resize: none; outline: none; line-height: 1.6; }
  textarea:focus { border-top: 2px solid #0e7a0d; }
</style>
</head>
<body>
<div id="toolbar">
  <span>imageNotes — Dropbox</span>
  <button id="saveBtn" onclick="save()">Save to Dropbox</button>
  <button id="closeBtn" onclick="closeModal()">Close</button>
</div>
<textarea id="editor" spellcheck="false">%s</textarea>
<script>
  document.getElementById('editor').focus();
  function save() {
    webkit.messageHandlers.accumulator.postMessage({action: 'save', content: document.getElementById('editor').value});
  }
  function closeModal() {
    webkit.messageHandlers.accumulator.postMessage({action: 'close'});
  }
  document.addEventListener('keydown', function(e) {
    if ((e.metaKey || e.ctrlKey) && e.key === 's') {
      e.preventDefault();
      save();
    }
    if (e.key === 'Escape') { closeModal(); }
  });
</script>
</body>
</html>]], encodedContent)

    local userscript = hs.webview.usercontent.new("accumulator")
    userscript:setCallback(function(msg)
      local body = msg.body
      if body.action == "close" then
        accumulatorView:delete()
        accumulatorView = nil
      elseif body.action == "save" then
        local f = io.open(accTmpFile, "w")
        if f then
          f:write(body.content)
          f:close()
          hs.task.new("/bin/sh", function(c, o, e)
            if c == 0 then
              hs.notify.new({title="imageNotes", informativeText="Saved to Dropbox ✓"}):send()
            else
              hs.alert.show("❌ Save failed")
            end
          end, {"-c", "/opt/homebrew/bin/rclone copyto '" .. accTmpFile .. "' '" .. accDropboxPath .. "'"}):start()
        end
        accumulatorView:delete()
        accumulatorView = nil
      end
    end)

    local screen = hs.screen.mainScreen():frame()
    local w, h = 720, 540
    accumulatorView = hs.webview.new(
      {x = screen.x + (screen.w - w)/2, y = screen.y + (screen.h - h)/2, w = w, h = h},
      {developerExtrasEnabled = true},
      userscript
    )
    accumulatorView:windowStyle({"titled", "closable", "resizable"})
    accumulatorView:windowTitle("imageNotes")
    accumulatorView:allowTextEntry(true)
    accumulatorView:html(html)
    accumulatorView:show()
    accumulatorView:bringToFront(true)

  end, {"-c", "/opt/homebrew/bin/rclone cat '" .. accDropboxPath .. "'"}):start()
end)
