{
    "description": "New Rule (change left_shift+caps_lock to page_down, right_shift+caps_lock to left_command+mission_control)",
    "manipulators": [
        {
            "from": {
                "key_code": "s",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [
                {
                    "key_code": "s",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "q",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [
                {
                    "key_code": "q",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "v",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [
                {
                    "key_code": "v",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "8",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "open -a 'Numbers' /Users/stanleytan/desktop/admin_code/backup_tracking_time/tracking_time.csv" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "9",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "osascript /Users/stanleytan/desktop/admin_code/for_karabiner_open_tracking_time_folder.scpt" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.google\\.Chrome$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "non_us_pound" },
            "to": [
                {
                    "key_code": "3",
                    "modifiers": ["shift"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.google\\.Chrome$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "p",
                "modifiers": { "mandatory": ["command", "option"] }
            },
            "to": [{ "key_code": "return_or_enter" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.microsoft\\.edgemac$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "p",
                "modifiers": { "mandatory": ["command", "option"] }
            },
            "to": [
                {
                    "key_code": "open_bracket",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^net\\.ankiweb\\.dtop$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "non_us_pound" },
            "to": [{ "key_code": "spacebar" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^net\\.ankiweb\\.dtop$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "up_arrow" },
            "to": [{ "key_code": "1" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^net\\.ankiweb\\.dtop$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "page_down" },
            "to": [{ "key_code": "4" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "backslash" },
            "to": [
                {
                    "key_code": "down_arrow",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "quote" },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_navigate_open_finder.scpt" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.sublimetext\\.4$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "down_arrow",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "key_code": "page_down" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.sublimetext\\.4$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "up_arrow",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "key_code": "page_up" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^abnerworks\\.Typora$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "down_arrow",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "key_code": "page_down" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^abnerworks\\.Typora$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "up_arrow",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "key_code": "page_up" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "p",
                "modifiers": { "mandatory": ["command", "option"] }
            },
            "to": [
                {
                    "key_code": "open_bracket",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "a",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [
                {
                    "key_code": "a",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.Terminal$",
                        "^com\\.googlecode\\.iterm2$",
                        "^io\\.alacritty$"
                    ],
                    "type": "frontmost_application_unless"
                }
            ],
            "from": {
                "key_code": "c",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [
                {
                    "key_code": "c",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "left_arrow",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [
                {
                    "key_code": "open_bracket",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "down_arrow",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [
                {
                    "key_code": "down_arrow",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "up_arrow",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [
                {
                    "key_code": "open_bracket",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.Terminal$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "open_bracket",
                "modifiers": { "mandatory": ["command"] }
            },
            "to": [
                {
                    "key_code": "open_bracket",
                    "modifiers": ["control"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "1",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_master.scpt 1" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "2",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_master.scpt 2" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "3",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_master.scpt 3" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "4",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_master.scpt 4" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "6",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_master.scpt 6" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "5",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [{ "shell_command": "open /Users/stanleytan/Desktop/admin_code/karabiner_mappings.json" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "slash",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [{ "shell_command": "open -a 'Script Editor' /Users/stanleytan/Desktop/admin_code/languages/switching_with_period.scpt" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "down_arrow",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [{ "key_code": "page_down" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "up_arrow",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [{ "key_code": "page_up" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^abnerworks\\.Typora$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "escape" },
            "to": [
                {
                    "key_code": "w",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.sublimetext\\.4$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "escape" },
            "to": [
                {
                    "key_code": "w",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "spacebar",
                "modifiers": { "mandatory": ["option"] }
            },
            "to": [{ "shell_command": "open -a 'Commander One'" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "l",
                "modifiers": { "mandatory": ["right_command"] }
            },
            "to": [
                {
                    "key_code": "l",
                    "modifiers": ["left_shift", "left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "l",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [
                {
                    "key_code": "l",
                    "modifiers": ["left_shift", "left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "c",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [
                {
                    "key_code": "c",
                    "modifiers": ["left_control", "left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "delete_or_backspace",
                "modifiers": { "mandatory": ["right_command"] }
            },
            "to": [
                {
                    "key_code": "6",
                    "modifiers": ["left_shift", "left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "delete_or_backspace",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [
                {
                    "key_code": "8",
                    "modifiers": ["left_option", "left_command", "left_shift"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "close_bracket",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [
                {
                    "key_code": "6",
                    "modifiers": ["left_command", "left_shift", "left_option"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "backslash" },
            "to": [{ "key_code": "tab" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "spacebar",
                "modifiers": { "mandatory": ["right_command", "right_option"] }
            },
            "to": [
                {
                    "key_code": "e",
                    "modifiers": ["left_command", "left_shift"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "n",
                "modifiers": { "mandatory": ["command"] }
            },
            "to": [
                {
                    "key_code": "8",
                    "modifiers": ["left_command", "left_shift", "left_option"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "period",
                "modifiers": { "mandatory": ["command"] }
            },
            "to": [
                {
                    "key_code": "6",
                    "modifiers": ["left_option", "left_command", "left_shift"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "delete_or_backspace",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [
                {
                    "key_code": "6",
                    "modifiers": ["left_shift", "left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "spacebar",
                "modifiers": { "mandatory": ["command"] }
            },
            "to": [{ "key_code": "return_or_enter" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "f11" },
            "to": [{ "key_code": "volume_decrement" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "f11",
                "modifiers": { "mandatory": ["shift"] }
            },
            "to": [{ "key_code": "volume_increment" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "left_arrow",
                "modifiers": { "mandatory": ["right_option"] }
            },
            "to": [
                {
                    "key_code": "e",
                    "modifiers": ["left_shift", "left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "spacebar" },
            "to": [{ "key_code": "down_arrow" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": {
                "key_code": "2",
                "modifiers": { "mandatory": ["command", "shift"] }
            },
            "to": [
                {
                    "key_code": "n",
                    "modifiers": ["shift", "command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.TextEdit$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "open_bracket" },
            "to": [{ "key_code": "delete_or_backspace" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.TextEdit$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "close_bracket" },
            "to": [{ "key_code": "delete_or_backspace" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "f13" },
            "to": [{ "key_code": "a" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.sublimetext\\.4$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "f1" },
            "to": [{ "key_code": "page_down" }],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "f1" },
            "to": [
                {
                    "key_code": "o",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.finder$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "f2" },
            "to": [
                {
                    "key_code": "open_bracket",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.eltima\\.cmd1\\.mas$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "f2" },
            "to": [{ "key_code": "period" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "f2" },
            "to": [
                {
                    "key_code": "q",
                    "modifiers": ["command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": { "key_code": "f3" },
            "to": [{ "key_code": "mission_control" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "spacebar",
                "modifiers": { "mandatory": ["left_control"] }
            },
            "to": [
                {
                    "key_code": "8",
                    "modifiers": ["command", "option"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.TextEdit$"
                    ],
                    "type": "frontmost_application_if"
                }
            ],
            "from": { "key_code": "f1" },
            "to": [{ "key_code": "page_down" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "1",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "apple_vendor_keyboard_key_code": "mission_control" }],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "2",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [
                {
                    "key_code": "c",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "3",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [
                {
                    "key_code": "v",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "d",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "pointing_button": "button1" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "grave_accent_and_tilde" },
            "to": [
                {
                    "key_code": "8",
                    "modifiers": ["command", "option"]
                }
            ],
            "type": "basic"
        },
        {
            "conditions": [
                {
                    "bundle_identifiers": [
                        "^com\\.apple\\.Terminal$",
                        "^com\\.googlecode\\.iterm2$",
                        "^io\\.alacritty$"
                    ],
                    "type": "frontmost_application_unless"
                }
            ],
            "from": {
                "key_code": "down_arrow",
                "modifiers": { "mandatory": ["left_command"] }
            },
            "to": [{ "key_code": "return_or_enter" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "f5" },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_quicktime_start.scpt" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "f6" },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_quicktime_stop_save.scpt" }],
            "type": "basic"
        },
        {
            "from": { "key_code": "f7" },
            "to": [{ "shell_command": "osascript /Users/stanleytan/Desktop/admin_code/for_karabiner_transcribe_then_chrome.scpt &" }],
            "type": "basic"
        }
    ]
}
