import sys
import urllib.parse
import subprocess

def main():
    if len(sys.argv) < 2:
        print("Usage: python google_translate.py <text>")
        sys.exit(1)

    text = sys.argv[1]
    encoded = urllib.parse.quote(text)
    url = f"https://translate.google.com/?sl=yue&tl=en&text={encoded}&op=translate"

    subprocess.run(["open", "-a", "Google Chrome", url])

if __name__ == "__main__":
    main()
