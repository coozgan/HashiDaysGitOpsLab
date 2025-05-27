#! /usr/bin/env bash

set -eEuo pipefail

PATHS="$1"
EVENT="$2"
HEAD_SHA="$3"
COMMIT_SHA="$4"

if [ $EVENT = "pull_request" ]; then
    # Pull requests compares to the base commit of the compared branch
    CHANGED_FILES=$(git diff --name-only $HEAD_SHA $COMMIT_SHA)
else
    # A commit to main compares one commit back
    CHANGED_FILES=$(git diff --name-only HEAD^ HEAD)
fi

echo "Changed files:"
echo $CHANGED_FILES

# Check if any changed files match our paths
FILES_CHANGED=false
for path in $PATHS; do
    echo "Checking against regex: $path"
    if echo "$CHANGED_FILES" | grep -q "^${path}"; then
        FILES_CHANGED=true
        echo "File changed: $path"
    break
    fi
done

echo "changed=$FILES_CHANGED" >> $GITHUB_OUTPUT
