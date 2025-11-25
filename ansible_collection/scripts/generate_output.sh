#!/usr/bin/env bash
#
# generate_output.sh - Generate predictable stdout/stderr output over time
#
# Purpose: Simulate a long-running process that generates output to both
#          stdout and stderr. Useful for testing async task monitoring.
#
# Usage: generate_output.sh [-d duration] [-c count]
#
# Options:
#   -d, --duration SECONDS   Total duration to run (default: 300 = 5 minutes)
#   -c, --count LINES        Number of lines to output (default: 50)
#   -h, --help               Show this help message
#
# Behavior:
#   - Calculates interval: INTERVAL = DURATION / COUNT
#   - Writes to stdout: "stdout line N of COUNT"
#   - Writes to stderr: "error no.N of COUNT"
#   - Sleeps INTERVAL between lines
#   - Exits with code 0 on success
#
# Example:
#   ./generate_output.sh --duration 60 --count 20
#   (Generates 20 lines over 60 seconds, one line every 3 seconds)
#

set -euo pipefail

# Defaults
DURATION=300  # 5 minutes
COUNT=50

# Show usage
show_usage() {
  echo "Usage: $0 [-d|--duration SECONDS] [-c|--count LINES] [-h|--help]"
  echo ""
  echo "Generate predictable stdout/stderr output over specified duration."
  echo ""
  echo "Options:"
  echo "  -d, --duration SECONDS   Total duration (default: 300)"
  echo "  -c, --count LINES        Number of lines (default: 50)"
  echo "  -h, --help               Show this help"
  echo ""
  echo "Example:"
  echo "  $0 --duration 60 --count 20"
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--duration)
      DURATION="$2"
      shift 2
      ;;
    -c|--count)
      COUNT="$2"
      shift 2
      ;;
    -h|--help)
      show_usage
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      echo "Run with --help for usage information" >&2
      exit 1
      ;;
  esac
done

# Validate inputs
if ! [[ "$DURATION" =~ ^[0-9]+$ ]]; then
  echo "Error: Duration must be a positive integer" >&2
  exit 1
fi

if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
  echo "Error: Count must be a positive integer" >&2
  exit 1
fi

if [ "$COUNT" -eq 0 ]; then
  echo "Error: Count must be greater than 0" >&2
  exit 1
fi

# Calculate interval (using awk for floating point)
INTERVAL=$(awk "BEGIN {printf \"%.2f\", $DURATION / $COUNT}")

# Start message (to stderr, so it doesn't interfere with stdout capture)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting output generation" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Configuration: $COUNT lines over $DURATION seconds" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Interval: $INTERVAL seconds per line" >&2
echo "" >&2

# Generate output
for i in $(seq 1 $COUNT); do
  # Write to stdout
  echo "stdout line $i of $COUNT"

  # Write to stderr
  echo "error no.$i of $COUNT" >&2

  # Don't sleep after the last line
  if [ $i -lt $COUNT ]; then
    sleep $INTERVAL
  fi
done

# Completion message
echo "" >&2
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Output generation completed successfully" >&2

exit 0
