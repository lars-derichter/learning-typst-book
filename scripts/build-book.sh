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

# Convert each chapter separately, in reading order (the NN- prefixes sort
# correctly), passing its file name so the filter can label the chapter for
# cross-chapter links. The per-file bodies are concatenated into one.
echo "Converting Markdown chapters to a Typst body ..."
: > "$OUT/body.typ"
for chapter in "$REPO_ROOT"/book/*.md; do
  CHAPTER_NAME="$(basename "$chapter" .md)" pandoc "$chapter" \
    --from gfm+tex_math_dollars \
    --to typst \
    --lua-filter "$PIPE/book-filter.lua" \
    >> "$OUT/body.typ"
  printf '\n\n' >> "$OUT/body.typ"
done

# Wrap the converted body: the head (imports and applies the Chapter 22 book
# template, with the cover) in front, the back matter (About the authors,
# colophon + licence, back cover) after — one document the template styles end
# to end.
echo "Assembling the book ..."
cat "$PIPE/head.typ" "$OUT/body.typ" "$PIPE/back-matter.typ" > "$OUT/learning-typst.typ"

echo "Compiling with Typst ..."
typst compile --root "$REPO_ROOT" "$OUT/learning-typst.typ" "$OUT/learning-typst.pdf"

echo "Done -> $OUT/learning-typst.pdf"
