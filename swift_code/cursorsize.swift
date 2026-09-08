import Foundation
import ApplicationServices
import AppKit

// ============================================================
// cursorsize.swift
//
// Programmatically sets the macOS pointer/cursor size by
// driving the actual slider in System Settings > Accessibility
// > Display > Pointer size, via the Accessibility (AX) API.
//
// This is necessary because `defaults write
// com.apple.universalaccess.plist mouseDriverCursorSize <n>`
// updates the stored preference but does NOT cause the system
// to redraw the cursor — no process reliably picks up the
// change without a restart/logout. Driving the real UI slider
// is the only way that reliably works without logging out.
//
// USAGE:
//   swiftc cursorsize.swift -o cursorsize
//   ./cursorsize 4          # set pointer size directly to 4.0
//   ./cursorsize --toggle 1 4   # flip between 1.0 and 4.0 each run
//
// REQUIRES:
//   The terminal app (or compiled binary) you run this from
//   must be granted Accessibility permissions:
//   System Settings > Privacy & Security > Accessibility
//
// NOTE:
//   This depends on System Settings' internal view hierarchy
//   and identifiers, which Apple can change between OS
//   versions. Tested lineage traces back to a Ventura-era
//   community script; you may need to adjust
//   `sliderIdentifier` below if Apple renames it.
// ============================================================

let sliderIdentifier = "AX_CURSOR_SIZE"
let stateFile = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".cursorsize_state")

// MARK: - Argument parsing

enum Mode {
    case setValue(Float)
    case toggle(Float, Float)
}

func parseArguments() -> Mode? {
    let args = CommandLine.arguments

    if args.count == 4, args[1] == "--toggle" {
        guard let a = Float(args[2]), let b = Float(args[3]) else {
            print("Toggle values must be numbers, e.g. --toggle 1 4")
            return nil
        }
        return .toggle(a, b)
    }

    if args.count == 2, let value = Float(args[1]) {
        return .setValue(value)
    }

    print("""
    Usage:
      cursorsize <value>            Set pointer size directly (e.g. 1.0–4.0)
      cursorsize --toggle A B       Flip between size A and size B each run
    """)
    return nil
}

// MARK: - Toggle state persistence

func nextToggleValue(_ a: Float, _ b: Float) -> Float {
    guard let saved = try? String(contentsOf: stateFile, encoding: .utf8),
          let lastValue = Float(saved.trimmingCharacters(in: .whitespacesAndNewlines))
    else {
        // No prior state — start with `a`
        try? String(a).write(to: stateFile, atomically: true, encoding: .utf8)
        return a
    }

    let next = (lastValue == a) ? b : a
    try? String(next).write(to: stateFile, atomically: true, encoding: .utf8)
    return next
}

// MARK: - Open the Pointer Size pane

func openPointerSizePane() {
    let script = """
    tell application "System Settings"
        activate
        reveal anchor "\(sliderIdentifier)" of pane id "com.apple.Accessibility-Settings.extension"
    end tell
    """

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    process.arguments = ["-e", script]
    process.standardOutput = Pipe()
    process.standardError = Pipe()

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        print("Failed to open System Settings: \(error.localizedDescription)")
    }
}

// MARK: - Accessibility tree helpers

func findPIDForSystemSettings() -> pid_t? {
    NSWorkspace.shared.runningApplications.first {
        $0.bundleIdentifier == "com.apple.systempreferences"
    }?.processIdentifier
}

func findElement(with identifier: String, in elements: [AXUIElement]) -> AXUIElement? {
    for element in elements {
        var idRef: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXIdentifierAttribute as CFString, &idRef)
        if let idStr = idRef as? String, idStr == identifier {
            return element
        }

        var childrenRef: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &childrenRef)
        if let children = childrenRef as? [AXUIElement],
           let found = findElement(with: identifier, in: children) {
            return found
        }
    }
    return nil
}

/// Polls for the System Settings AX tree to contain the slider,
/// retrying briefly since the pane can take a moment to load.
func waitForSlider(pid: pid_t, timeout: TimeInterval = 5.0) -> AXUIElement? {
    let appElement = AXUIElementCreateApplication(pid)
    let deadline = Date().addingTimeInterval(timeout)

    while Date() < deadline {
        var childrenRef: CFTypeRef?
        AXUIElementCopyAttributeValue(appElement, kAXChildrenAttribute as CFString, &childrenRef)
        if let elements = childrenRef as? [AXUIElement],
           let slider = findElement(with: sliderIdentifier, in: elements) {
            return slider
        }
        Thread.sleep(forTimeInterval: 0.3)
    }
    return nil
}

// MARK: - Slider adjustment

func adjustSlider(to targetValue: Float, element: AXUIElement) {
    var valueRef: CFTypeRef?
    AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef)

    guard var currentValue = valueRef as? Float else {
        print("Unable to read current slider value.")
        return
    }

    let direction: Int = currentValue < targetValue ? 1 : -1
    var guardCounter = 0
    let maxSteps = 200 // safety cap so a mismatched step size can't loop forever

    while abs(currentValue - targetValue) > 0.001, guardCounter < maxSteps {
        if direction == 1 {
            guard currentValue < targetValue else { break }
            AXUIElementPerformAction(element, kAXIncrementAction as CFString)
        } else {
            guard currentValue > targetValue else { break }
            AXUIElementPerformAction(element, kAXDecrementAction as CFString)
        }

        AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef)
        currentValue = (valueRef as? Float) ?? currentValue
        guardCounter += 1
    }

    if abs(currentValue - targetValue) <= 0.001 {
        print("Cursor size set to \(currentValue).")
    } else {
        print("Stopped near \(currentValue) (target \(targetValue)) — slider may use different step increments.")
    }
}

// MARK: - Main

guard let mode = parseArguments() else {
    exit(1)
}

let targetValue: Float
switch mode {
case .setValue(let v):
    targetValue = v
case .toggle(let a, let b):
    targetValue = nextToggleValue(a, b)
    print("Toggling to \(targetValue)")
}

openPointerSizePane()

guard let pid = findPIDForSystemSettings() else {
    print("System Settings is not running.")
    exit(1)
}

guard let slider = waitForSlider(pid: pid) else {
    print("""
    Cursor size slider not found. Possible causes:
      - Accessibility permission not granted to this terminal/binary
        (System Settings > Privacy & Security > Accessibility)
      - Apple changed the pane's internal identifier in this macOS version
    """)
    exit(1)
}

adjustSlider(to: targetValue, element: slider)
