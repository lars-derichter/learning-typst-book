#!/usr/bin/env bash
#
# build-examples.sh — compile and render every example in examples/.
#
# For each examples/NN-*/ folder that contains a main.typ, this renders:
#   - out.pdf              (the full document)
#   - out.png              (a 144-ppi preview of page 1)
#
# The script is the enforcement behind the book's promise that every example
# actually compiles with the pinned Typst version. It fails loudly (non-zero
# exit) if any example that should compile does not.
#
# Special markers you can drop into an example folder:
#   .expect-error   -> this example is SUPPOSED to fail compilation (it teaches
#                      an error message). The script asserts it fails and does
#                      not render it. If it unexpectedly compiles, that's a
#                      failure.
#   .skip-build     -> skip this folder entirely (e.g. the Pandoc pipeline
#                      example, which has its own build script).
#
# Usage:
#   scripts/build-examples.sh            # build all examples
#   scripts/build-examples.sh 07 12      # build only examples whose folder
#                                        # name starts with 07- or 12-
#
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXAMPLES_DIR="$REPO_ROOT/examples"
PPI=144

if ! command -v typst >/dev/null 2>&1; then
  echo "error: typst is not on PATH. Install it from https://typst.app." >&2
  exit 127
fi

# Optional filters: only build folders whose basename starts with one of these.
FILTERS=("$@")

matches_filter() {
  local name="$1"
  [ "${#FILTERS[@]}" -eq 0 ] && return 0
  local f
  for f in "${FILTERS[@]}"; do
    case "$name" in
      "$f"-*) return 0 ;;
    esac
  done
  return 1
}

ok=0
failed=0
skipped=0
declare -a failures=()

for dir in "$EXAMPLES_DIR"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"

  matches_filter "$name" || continue

  if [ -f "$dir/.skip-build" ]; then
    echo "SKIP   $name (.skip-build)"
    skipped=$((skipped + 1))
    continue
  fi

  entry="$dir/main.typ"
  if [ ! -f "$entry" ]; then
    echo "SKIP   $name (no main.typ)"
    skipped=$((skipped + 1))
    continue
  fi

  if [ -f "$dir/.expect-error" ]; then
    # This example must FAIL to compile.
    if typst compile --root "$REPO_ROOT" "$entry" "$dir/out.pdf" >/dev/null 2>&1; then
      echo "FAIL   $name (expected a compile error, but it compiled)"
      failures+=("$name")
      failed=$((failed + 1))
    else
      echo "OK     $name (failed as expected)"
      ok=$((ok + 1))
    fi
    continue
  fi

  # Normal example: must compile to PDF, then render page 1 to PNG.
  if ! typst compile --root "$REPO_ROOT" "$entry" "$dir/out.pdf" 2> "$dir/.build.log"; then
    echo "FAIL   $name (PDF)"
    sed 's/^/         | /' "$dir/.build.log"
    failures+=("$name")
    failed=$((failed + 1))
    continue
  fi

  if ! typst compile --root "$REPO_ROOT" --pages 1 --ppi "$PPI" \
        "$entry" "$dir/out.png" 2> "$dir/.build.log"; then
    echo "FAIL   $name (PNG)"
    sed 's/^/         | /' "$dir/.build.log"
    failures+=("$name")
    failed=$((failed + 1))
    continue
  fi

  rm -f "$dir/.build.log"
  echo "OK     $name"
  ok=$((ok + 1))
done

echo
echo "-----------------------------------------------------------------------"
echo "examples: $ok ok, $failed failed, $skipped skipped"
if [ "$failed" -gt 0 ]; then
  echo "failed:"
  printf '  - %s\n' "${failures[@]}"
  exit 1
fi
