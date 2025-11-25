#!/usr/bin/env bash
#
# capture_wrapper.sh - Wrapper script to capture stdout/stderr of a command
#
# Purpose: Executes a command while capturing its stdout and stderr to separate
#          files in real-time using tee and unbuffered output.
#
# Usage: capture_wrapper.sh JOB_ID COMMAND [ARGS...]
#
# Arguments:
#   JOB_ID    Unique identifier for this job (used in output filenames)
#   COMMAND   Command to execute
#   ARGS      Arguments to pass to the command
#
# Output Files:
#   ~/.ansible_async/${JOB_ID}.stdout    Standard output
#   ~/.ansible_async/${JOB_ID}.stderr    Standard error
#
# Features:
#   - Real-time capture using tee
#   - Unbuffered output using stdbuf (line-buffered)
#   - Separate files for stdout and stderr
#   - Preserves command exit code
#
# Requirements:
#   - bash shell (for process substitution)
#   - stdbuf utility (GNU coreutils)
#   - tee command
#
# Example:
#   ./capture_wrapper.sh myjob_123 ./long_running_script.sh --duration 60
#

set -euo pipefail

# Check arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 JOB_ID COMMAND [ARGS...]" >&2
  echo "" >&2
  echo "Executes COMMAND with ARGS, capturing stdout and stderr to files." >&2
  echo "" >&2
  echo "Output files:" >&2
  echo "  ~/.ansible_async/\${JOB_ID}.stdout" >&2
  echo "  ~/.ansible_async/\${JOB_ID}.stderr" >&2
  exit 1
fi

# Extract job ID
JOB_ID="$1"
shift

# Validate job ID (basic check for safety)
if [[ ! "$JOB_ID" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: JOB_ID must contain only alphanumeric characters, underscore, and dash" >&2
  exit 1
fi

# Setup output directory
OUTPUT_DIR="${HOME}/.ansible_async"
mkdir -p "${OUTPUT_DIR}"

# Output file paths
STDOUT_FILE="${OUTPUT_DIR}/${JOB_ID}.stdout"
STDERR_FILE="${OUTPUT_DIR}/${JOB_ID}.stderr"

# Create empty files (so they exist immediately for monitoring)
touch "${STDOUT_FILE}"
touch "${STDERR_FILE}"

# Check if stdbuf is available
if ! command -v stdbuf >/dev/null 2>&1; then
  echo "Warning: stdbuf not found - output may be buffered" >&2
  echo "Consider installing GNU coreutils for real-time output" >&2
  # Fall back to execution without stdbuf
  "$@" \
    2> >(tee "${STDERR_FILE}" >&2) \
    1> >(tee "${STDOUT_FILE}")
else
  # Execute command with unbuffered output and capture
  # stdbuf -oL -eL: Line-buffered for both stdout and stderr
  # Process substitution >(tee): Captures to file while passing through
  stdbuf -oL -eL "$@" \
    2> >(tee "${STDERR_FILE}" >&2) \
    1> >(tee "${STDOUT_FILE}")
fi

# Capture exit code
EXIT_CODE=$?

# Optional: Add completion marker to files
echo "" >> "${STDOUT_FILE}"
echo "[Completed with exit code: ${EXIT_CODE}]" >> "${STDOUT_FILE}"
echo "" >> "${STDERR_FILE}"
echo "[Completed with exit code: ${EXIT_CODE}]" >> "${STDERR_FILE}"

# Exit with the same code as the wrapped command
exit $EXIT_CODE
