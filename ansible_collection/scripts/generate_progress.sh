#!/usr/bin/env bash
#
# generate_progress.sh - Generate progress output for testing async monitoring
#
# Usage: generate_progress.sh [COUNT] [OUTPUT_FILE]
#
# Arguments:
#   COUNT        Number of progress steps (default: 10)
#   OUTPUT_FILE  File to write output to (optional, defaults to stdout)
#
# Example:
#   ./generate_progress.sh 10 /tmp/progress.log
#   ./generate_progress.sh 100  # Outputs to stdout

set -euo pipefail

# Default values
COUNT="${1:-10}"
OUTPUT_FILE="${2:-}"

# Use stdbuf for line-buffered output (closer to real-time)
# If stdbuf not available, command will still work but may be more buffered
if command -v stdbuf >/dev/null 2>&1; then
  if [ -n "$OUTPUT_FILE" ]; then
    stdbuf -oL -eL bash -c "
      for i in \$(seq 1 $COUNT); do
        echo \"Progress: Step \$i of $COUNT\"
        sleep 1
      done
    " > "$OUTPUT_FILE" 2>&1
  else
    stdbuf -oL -eL bash -c "
      for i in \$(seq 1 $COUNT); do
        echo \"Progress: Step \$i of $COUNT\"
        sleep 1
      done
    "
  fi
else
  if [ -n "$OUTPUT_FILE" ]; then
    for i in $(seq 1 "$COUNT"); do
      echo "Progress: Step $i of $COUNT"
      sleep 1
    done > "$OUTPUT_FILE" 2>&1
  else
    for i in $(seq 1 "$COUNT"); do
      echo "Progress: Step $i of $COUNT"
      sleep 1
    done
  fi
fi

