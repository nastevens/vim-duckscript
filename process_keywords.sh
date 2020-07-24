#!/bin/sh

# Usage: ./process_keywords.sh duckscript/docs/sdk.md

LINE_HEADER='syntax match duckKeyword display contained'
# All commands are listed on a single line after the "Aliases" heading of each
# function in the SDK docs. `-A1` grabs the heading and one line after it (the
# aliases themselves)
grep -A1 Aliases $1 |
    sort -u             | # Sort and collect duplicates
    grep -v 'Aliases'   | # Remove the `#### Aliases` lines
    grep -v '\-\-'      | # Remove the `--` lines
    tr '\n' ' '         | # Turn newlines into spaces
    tr -d ','           | # Remove commas from commands with multiple aliases
    fold -w60 -s        | # Wrap to 60 columns
    sed 's/ \{2,\}/ /g' | # Compress multiple spaces to one
    sed 's/ *$//'       | # Delete spaces at the end of a line
    tr ' ' '|'          | # Replace spaces with '|'
    sed 's/^/'"${LINE_HEADER}"' "\\v<%(/' | sed 's/$/)>"/' # Add our header/trailer
