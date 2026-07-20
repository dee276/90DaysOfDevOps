#!/bin/bash
set -euo pipefail

# undefined variable will fail
# echo "$UNDEFINED_VAR"

# failing command will stop the script
# false

# pipefail example: grep on non-existent file
# cat missing.txt | grep foo

echo "This script is running strict mode."
