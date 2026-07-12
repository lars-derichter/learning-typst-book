#!/usr/bin/env bash
#
# build-book.sh — typeset the whole book from its Markdown source.
#
# This is Chapter 24 made real: it runs every chapter in book/ through Pandoc
# (Markdown -> Typst), applies a Lua filter that turns GitHub-style alerts into
# admonition boxes, wraps the result in a Typst book template, and compiles the
# lot to a single PDF with Typst.
#
# Requirements: pandoc 3.x and typst on your PATH.
#
# Usage:
#   scripts/build-book.sh            # -> build/learning-typst.pdf
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PIPE="$REPO_ROOT/examples/117-pandoc-book-build"
OUT="$REPO_ROOT/build"
mkdir -p "$OUT"

for tool in pandoc typst; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "error: $tool is not on PATH." >&2; exit 127; }
done

# Chapters in reading order. The NN- prefixes sort correctly, so the shell's
# glob expansion is already in reading order.
echo "Converting Markdown chapters to a Typst body ..."
pandoc "$REPO_ROOT"/book/*.md \
  --from gfm+tex_math_dollars \
  --to typst \
  --lua-filter "$PIPE/github-alerts.lua" \
  --output "$OUT/body.typ"

# Prepend the Typst book design to the converted body to make one document.
echo "Assembling the book ..."
cat "$PIPE/book-preamble.typ" "$OUT/body.typ" > "$OUT/learning-typst.typ"

echo "Compiling with Typst ..."
typst compile --root "$REPO_ROOT" "$OUT/learning-typst.typ" "$OUT/learning-typst.pdf"

echo "Done -> $OUT/learning-typst.pdf"
