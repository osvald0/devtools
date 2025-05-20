#!/usr/bin/env bash

#
# A helper that digs into the files you added, modified or renamed in a given Git commit and either:
# Search mode: Prints only the new lines that contain your search text, prefixing each with path/to/file:
# Replace mode: Looks for the first occurrence of your search text in each changed file and swaps it out for your replacement, reporting where it happened.
#
# Usage:
#   1) ./get-git-changes-with-text.sh <commit> <search text…>
#   2) ./get-git-changes-with-text.sh <repo-path> <commit> <search text…>
#   3) ./get-git-changes-with-text.sh <commit> <search text…> <replacement text…>
#   4) ./get-git-changes-with-text.sh <repo-path> <commit> <search text…> <replacement text…>
#

usage() {
  echo "Usage:"
  echo "  $0 <commit> <search text…> [replacement text…]"
  echo "  $0 <repo-path> <commit> <search text…> [replacement text…]"
  exit 1
}

(($# < 2)) && usage

if [[ -d "$1" ]] && (($# >= 3)); then
  REPO="$1"
  COMMIT="$2"
  shift 2
else
  REPO='.'
  COMMIT="$1"
  shift
fi

if (($# == 1)); then
  MODE='search'
  PATTERN="$1"
elif (($# == 2)); then
  MODE='replace'
  PATTERN="$1"
  REPLACEMENT="$2"
else
  usage
fi

PARENT="${COMMIT}^"

case "$MODE" in
search)
  git -C "$REPO" diff --name-only --diff-filter=AMR "$PARENT" "$COMMIT" | while IFS= read -r file; do
    git -C "$REPO" diff "$PARENT" "$COMMIT" --unified=0 -- "$file" |
      grep -E '^\+[^+]' |
      grep -F -- "$PATTERN" |
      sed "s|^+|$file: |"
  done
  ;;

replace)
  git -C "$REPO" diff --name-only --diff-filter=AMR "$PARENT" "$COMMIT" | while IFS= read -r file; do
    fullpath="$REPO/$file"
    line=$(grep -nF -- "$PATTERN" "$fullpath" | head -n1 | cut -d: -f1)
    if [[ -n "$line" ]]; then
      sed -i '' "${line}s|$PATTERN|$REPLACEMENT|" "$fullpath"
      echo "Replaced in $file at line $line: $PATTERN -> $REPLACEMENT"
    fi
  done
  ;;

*)
  usage
  ;;
esac
