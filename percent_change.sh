#!/bin/bash

# For checking dif changes in a file or set of files

# Check if a file name or other arguments were provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file-or-diff-arguments>"
    exit 1
fi

# Capture all arguments passed to the script
diff_args="$@"

# Get added and deleted lines from git diff with the provided arguments
added=$(git diff --numstat $diff_args | awk '{sum += $1} END {print sum}')
deleted=$(git diff --numstat $diff_args | awk '{sum += $2} END {print sum}')

# Calculate total changes
total_changes=$((added + deleted))

# Get the total number of lines in the file(s) after the diff
files=$(git diff --name-only $diff_args)
if [ -z "$files" ]; then
    echo "No files match the specified diff arguments."
    exit 1
fi

total_lines=0
for file in $files; do
    if [ -f "$file" ]; then
        lines=$(wc -l <"$file")
        total_lines=$((total_lines + lines))
    fi
done

# Calculate percentage change
if [ "$total_lines" -eq 0 ]; then
    echo "No lines in the matched files to compare."
else
    percentage=$(echo "scale=2; ($total_changes / $total_lines) * 100" | bc)
    echo "Percentage of change for the specified diff: $percentage%"
fi
