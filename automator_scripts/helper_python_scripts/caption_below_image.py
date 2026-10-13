#!/usr/bin/env python3
"""Append a wrapped text caption in a white strip underneath an image.

Usage: caption_below_image.py IMAGE "caption text" [--font-size N]
Output: <name>_captioned.<ext> next to the image (auto-incremented if it exists).
Font size defaults to ~4% of the image width so captions scale with the image.
"""
import argparse, os
from PIL import Image, ImageDraw, ImageFont

FONT = "/System/Library/Fonts/Helvetica.ttc"


def wrap_text(text, font, draw, max_width):
    """Wrap text to fit within max_width pixels, honoring explicit newlines."""
    lines = []
    for para in text.splitlines() or [""]:
        current = ""
        for word in para.split():
            test = (current + " " + word).strip()
            if draw.textbbox((0, 0), test, font=font)[2] <= max_width:
                current = test
            else:
                if current:
                    lines.append(current)
                current = word
        lines.append(current)
    return lines


def output_path(image_path):
    name, ext = os.path.splitext(image_path)
    out, n = f"{name}_captioned{ext}", 1
    while os.path.exists(out):
        n += 1
        out = f"{name}_captioned_{n}{ext}"
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("image")
    ap.add_argument("caption")
    ap.add_argument("--font-size", type=int)
    a = ap.parse_args()

    img = Image.open(a.image).convert("RGB")
    width, height = img.size
    size = a.font_size or max(18, width // 25)
    try:
        font = ImageFont.truetype(FONT, size)
    except Exception:
        font = ImageFont.load_default()

    margin = size // 2
    draw = ImageDraw.Draw(img)
    lines = wrap_text(a.caption, font, draw, width - margin * 2)
    line_h = int(size * 1.3)
    strip = margin * 2 + line_h * len(lines)

    out = Image.new("RGB", (width, height + strip), "white")
    out.paste(img, (0, 0))
    draw = ImageDraw.Draw(out)
    y = height + margin
    for line in lines:
        w = draw.textbbox((0, 0), line, font=font)[2]
        draw.text(((width - w) // 2, y), line, fill="black", font=font)
        y += line_h

    path = output_path(a.image)
    out.save(path)
    print(f"Done: {path}")


if __name__ == "__main__":
    main()
