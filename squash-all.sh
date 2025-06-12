#!/bin/bash

# This script squashes all commits on the current branch since the given base branch
# into a single commit with a custom message, then force-pushes it to origin.
#
# Usage:
#   ./squash-and-push.sh "Your commit message" base-branch-name

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./squash-and-push.sh \"Commit message\" base-branch"
  echo "Example: ./squash-and-push.sh \"ENG-3867: Clean Explore UI\" dev"
  exit 1
fi

COMMIT_MSG="$1"
BASE_BRANCH="origin/$2"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Finding common ancestor with $BASE_BRANCH..."
BASE_COMMIT=$(git merge-base "$BASE_BRANCH" HEAD)

echo "Soft resetting to $BASE_COMMIT..."
git reset --soft "$BASE_COMMIT"

echo "Creating new commit..."
git commit -m "$COMMIT_MSG"

echo "Force pushing to origin/$CURRENT_BRANCH..."
git push -u origin "$CURRENT_BRANCH" --force

echo "Done! Branch '$CURRENT_BRANCH' now has a single clean commit on top of '$2'."
