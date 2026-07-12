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

# 1. Convert each chapter's Markdown to Typst, in order, passing the file name
#    so the filter can label the chapter (for cross-chapter links). The Lua
#    filter turns GitHub alerts into the template's #note/#warning calls, passes
#    Typst-syntax math through verbatim, rewrites in-repo links, drops the
#    <!-- SOLUTIONS --> comments, and leaves front/back matter unnumbered.
echo "Converting Markdown -> Typst ..."
: > "$OUT/body.typ"
for chapter in "$REPO_ROOT"/book/*.md; do
  CHAPTER_NAME="$(basename "$chapter" .md)" pandoc "$chapter" \
    --from gfm+tex_math_dollars \
    --to typst \
    --lua-filter "$HERE/book-filter.lua" \
    >> "$OUT/body.typ"
  printf '\n\n' >> "$OUT/body.typ"
done

# 2. Prepend head.typ, which imports and applies the Chapter 22 book template
#    (examples/115), to the converted body, making one document the template
#    styles from cover to index.
echo "Assembling ..."
cat "$HERE/head.typ" "$OUT/body.typ" > "$OUT/learning-typst.typ"

# 3. Compile to PDF. --root points at the repo so any absolute paths resolve.
echo "Compiling ..."
typst compile --root "$REPO_ROOT" "$OUT/learning-typst.typ" "$OUT/learning-typst.pdf"

echo "Done -> $OUT/learning-typst.pdf"
