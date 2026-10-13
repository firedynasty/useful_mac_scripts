#!/usr/bin/env python3
"""Read the QR code(s) in image file(s) and copy the contents to the clipboard.

Usage: read_qr_to_clipboard.py IMAGE [IMAGE ...]
- Clipboard-manager bridge links (<site>/qr#<base64>) are decoded back to the original text.
- Any other QR content (e.g. a dropboxImageLoader URL) is copied as is.
- Multiple results are joined with newlines. Prints the result and exits 1 if nothing was found.
"""
import base64, re, subprocess, sys

import cv2


def decode_image(path):
    img = cv2.imread(path)
    if img is None:
        return []
    det = cv2.QRCodeDetector()
    ok, texts, _, _ = det.detectAndDecodeMulti(img)
    found = [t for t in (texts if ok else []) if t]
    if not found:  # single-code detector is sometimes more forgiving
        t, _, _ = det.detectAndDecode(img)
        if t:
            found = [t]
    return found


def unwrap_bridge(text):
    """<site>/qr#<base64> -> original text; anything else unchanged."""
    m = re.match(r"https?://[^#]+/qr(?:_bridge(?:\.html)?)?#([A-Za-z0-9+/=]+)$", text)
    if m:
        try:
            return base64.b64decode(m[1]).decode("utf-8")
        except Exception:
            pass
    return text


def main():
    results = []
    for path in sys.argv[1:]:
        results += [unwrap_bridge(t) for t in decode_image(path)]
    if not results:
        print("No QR code found.")
        sys.exit(1)
    out = "\n".join(results)
    subprocess.run(["pbcopy"], input=out.encode("utf-8"), check=True)
    print(out)


if __name__ == "__main__":
    main()
