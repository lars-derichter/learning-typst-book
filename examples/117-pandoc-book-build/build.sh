#!/usr/bin/env bash
#
# build.sh — the Markdown-to-PDF pipeline for the whole book, self-contained in
# this example folder. It is the same pipeline the repository's
# scripts/build-book.sh runs; it lives here too so the example is a complete,
# copyable thing you can read in one place (this is Chapter 24's subject).
#
# From this folder:  ./build.sh   ->  out/learning-typst.pdf
#
# Requirements: pandoc 3.x and typst on your PATH.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"
OUT="$HERE/out"
mkdir -p "$OUT"

for tool in pandoc typst; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "error: $tool is not on PATH." >&2; exit 127; }
done

# 1. Convert every chapter's Markdown to a single Typst body. The Lua filter
#    turns GitHub alerts into #admonition() calls, passes Typst-syntax math
#    through verbatim, drops the <!-- SOLUTIONS --> comments, and leaves the
#    Preface and Appendices unnumbered.
echo "Converting Markdown -> Typst ..."
pandoc "$REPO_ROOT"/book/*.md \
  --from gfm+tex_math_dollars \
  --to typst \
  --lua-filter "$HERE/github-alerts.lua" \
  --output "$OUT/body.typ"

# 2. Prepend the Typst book design (page setup, admonition function, title page,
#    table of contents) to the converted body, making one standalone document.
echo "Assembling ..."
cat "$HERE/book-preamble.typ" "$OUT/body.typ" > "$OUT/learning-typst.typ"

# 3. Compile to PDF. --root points at the repo so any absolute paths resolve.
echo "Compiling ..."
typst compile --root "$REPO_ROOT" "$OUT/learning-typst.typ" "$OUT/learning-typst.pdf"

echo "Done -> $OUT/learning-typst.pdf"
