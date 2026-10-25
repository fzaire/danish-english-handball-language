#!/usr/bin/env bash
# Build HTML and PDF versions of Markdown documents into docs/.
#
# Usage: scripts/build-docs.sh [file.md ...]
# Defaults to the vocabulary phrasebook. Requires pandoc and Chrome/Chromium.
# Set CHROME=/path/to/chrome to choose the browser used for PDF output.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/docs"
CSS="$ROOT/scripts/docs.css"
DEFAULT_SOURCES=("Danish_english_vocabulary_for_Handball.md")

fail() { echo "error: $*" >&2; exit 1; }

command -v pandoc >/dev/null || fail "pandoc is not installed (https://pandoc.org/installing.html)."

find_chrome() {
  if [[ -n "${CHROME:-}" ]]; then echo "$CHROME"; return; fi
  local c
  for c in google-chrome google-chrome-stable chromium chromium-browser chrome; do
    if command -v "$c" >/dev/null; then command -v "$c"; return; fi
  done
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Chromium.app/Contents/MacOS/Chromium" \
           "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"; do
    if [[ -x "$c" ]]; then echo "$c"; return; fi
  done
}
CHROME_BIN="$(find_chrome)"
[[ -n "$CHROME_BIN" ]] || fail "Chrome or Chromium not found. Install it or set CHROME=/path/to/chrome."

if [[ $# -gt 0 ]]; then SOURCES=("$@"); else SOURCES=("${DEFAULT_SOURCES[@]}"); fi

mkdir -p "$OUT"
PROFILE="$(mktemp -d)"
trap 'rm -rf "$PROFILE"' EXIT

for src in "${SOURCES[@]}"; do
  [[ "$src" = /* ]] || src="$ROOT/$src"
  [[ -f "$src" ]] || fail "source not found: $src"
  name="$(basename "$src" .md)"
  html="$OUT/$name.html"
  pdf="$OUT/$name.pdf"
  title="$(grep -m1 '^# ' "$src" | sed 's/^# //')"
  title="${title:-$name}"

  pandoc "$src" \
    --from gfm --to html5 --standalone --embed-resources \
    --css "$CSS" \
    --metadata pagetitle="$title" \
    --metadata lang=en \
    --output "$html"
  echo "built $html"

  "$CHROME_BIN" --headless=new --disable-gpu --no-sandbox --no-first-run \
    --user-data-dir="$PROFILE" --no-pdf-header-footer \
    --print-to-pdf="$pdf" "file://$html" >/dev/null 2>&1 \
    || fail "PDF generation failed for $html"
  [[ -s "$pdf" ]] || fail "PDF is empty: $pdf"
  echo "built $pdf"
done
