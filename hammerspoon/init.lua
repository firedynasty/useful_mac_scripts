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
      -- Step 1: Whisper transcription
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

local accumulatorLocal = "/tmp/accumulator.txt"
local accumulatorRemote = "dropbox:blob_vercel_replacement/blob_clipboard_accumulator.txt"

-- ctrl+option+2 → Cmd+S the open TextEdit file, then push /tmp/accumulator.txt back to Dropbox
hs.hotkey.bind({"ctrl", "alt"}, "2", function()
  hs.eventtap.keyStroke({"cmd"}, "s")
  hs.timer.doAfter(0.5, function()
    hs.task.new("/bin/sh", function(code, _, _)
      if code == 0 then
        hs.notify.new({title="Accumulator", informativeText="Saved to Dropbox"}):send()
      else
        hs.alert.show("❌ rclone upload failed")
      end
    end, {"-c", "/opt/homebrew/bin/rclone copyto " .. accumulatorLocal .. " " .. accumulatorRemote}):start()
  end)
end)

-- ctrl+option+grave → fetch accumulator from Dropbox and open in TextEdit
hs.hotkey.bind({"ctrl", "alt"}, "`", function()
  local result = hs.dialog.blockAlert(
    "Fetch Accumulator from Dropbox?",
    "⚠️ This will overwrite your local copy and replace what you have open in TextEdit.",
    "Fetch",
    "Cancel"
  )
  if result == "Fetch" then
    hs.alert.show("⬇️ Fetching accumulator...")
    hs.task.new("/bin/sh", function(code, _, _)
      if code == 0 then
        hs.execute("open -a TextEdit " .. accumulatorLocal)
        hs.alert.show("ctrl+alt+2 = save", 3)
      else
        hs.alert.show("❌ rclone fetch failed")
      end
    end, {"-c", "/opt/homebrew/bin/rclone cat " .. accumulatorRemote .. " > " .. accumulatorLocal}):start()
  else
    hs.execute("open -a TextEdit " .. accumulatorLocal)
  end
end)
