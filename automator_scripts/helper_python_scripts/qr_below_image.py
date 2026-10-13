#!/usr/bin/env python3
"""Append a QR code in a white strip underneath an image.

Usage: qr_below_image.py IMAGE "text or URL" [--base-url URL] [--size N]
- A URL (http/https) is encoded directly into the QR.
- Any other text is encoded the way the clipboard manager's /qr page does
  (BASE_URL/qr#<base64 of utf-8 text>), so scanning opens it in that viewer.
Output: <name>_qr.<ext> next to the image (auto-incremented if it exists).
"""
import argparse, base64, os, sys

import qrcode
from PIL import Image

BASE_URL = "https://clipboard-manager-three.vercel.app/qr"
MAX_URL_LEN = 3500  # same limit as qr_bridge.html


def target_for(content, base_url, raw=False):
    if raw:
        return content
    if content.startswith(("http://", "https://")) and "\n" not in content:
        return content
    return base_url.rstrip("/") + "#" + base64.b64encode(content.encode("utf-8")).decode()


def output_path(image_path):
    name, ext = os.path.splitext(image_path)
    out, n = f"{name}_qr{ext}", 1
    while os.path.exists(out):
        n += 1
        out = f"{name}_qr_{n}{ext}"
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("image")
    ap.add_argument("content")
    ap.add_argument("--base-url", default=BASE_URL)
    ap.add_argument("--raw", action="store_true", help="encode the text exactly as given (no /qr bridge link)")
    ap.add_argument("--size", type=int, help="QR side in pixels (default: 35%% of image width, min 200)")
    a = ap.parse_args()

    content = a.content.strip()
    if not content:
        sys.exit("Nothing to encode.")
    url = target_for(content, a.base_url, a.raw)
    if len(url) > MAX_URL_LEN:
        sys.exit(f"Content too long for a QR code ({len(url)} chars, max {MAX_URL_LEN}).")

    img = Image.open(a.image).convert("RGB")
    width, height = img.size
    qr = qrcode.QRCode(error_correction=qrcode.constants.ERROR_CORRECT_M, border=2)
    qr.add_data(url)
    qr.make(fit=True)
    size = a.size or max(200, int(width * 0.35))
    qr_img = qr.make_image(fill_color="black", back_color="white").convert("RGB")
    qr_img = qr_img.resize((size, size), Image.NEAREST)

    margin = size // 10
    out = Image.new("RGB", (width, height + size + margin * 2), "white")
    out.paste(img, (0, 0))
    out.paste(qr_img, ((width - size) // 2, height + margin))

    path = output_path(a.image)
    out.save(path)
    print(f"Done: {path}")


if __name__ == "__main__":
    main()
