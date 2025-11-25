# Sprint 14 - Design

## GHC-17: Add example for async processing getting data from script's log

Status: Proposed

### Requirement Summary

Create example demonstrating live stdout/stderr capture from async tasks using shell redirection and file-based monitoring.

### Feasibility Analysis

**API Availability:**

All required Ansible modules confirmed available:
- `ansible.builtin.shell` with async parameter ✅
- `ansible.builtin.async_status` for job status ✅
- `ansible.builtin.slurp` for file reading ✅
- `ansible.builtin.stat` for file existence check ✅
- `ansible.builtin.pause` for loop delays ✅
- `ansible.builtin.debug` for output display ✅

All required shell utilities confirmed standard:
- `bash` shell (for process substitution) ✅
- `tee` command (output capture) ✅
- `stdbuf` utility (unbuffered output) ✅

References:
- Ansible Documentation: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/
- Sprint 11-13 implementations confirm all patterns work

**Technical Constraints:**

1. bash required (not sh) - for process substitution `>()`
2. stdbuf must be available - widely present in GNU coreutils
3. Filesystem access to `~/.ansible_async/` directory
4. slurp module has memory limit - recommend tail mode for large outputs

**Risk Assessment:**

- **Low Risk**: All components proven and standard
- **Mitigation**: Clear prerequisites documentation
- **Fallback**: If stdbuf unavailable, can use `tee -i` with reduced real-time behavior

### Design Overview

**Architecture:**

Two-component solution:
1. **Helper Script** (`ansible_collection/scripts/generate_output.sh`)
   - Generates predictable stdout/stderr output over time
   - Configurable duration, line count, interval
   - Reusable for testing and demonstrations

2. **Example Playbook** (`ansible_collection/scenario_05_live_output.yml`)
   - Launches script with async and output capture
   - Monitors output files in loop
   - Displays captured output (full or tail mode)
   - Handles completion gracefully

**Key Components:**

1. **Output Generation** (helper script):
   - Writes numbered lines to stdout and stderr
   - Paces output over specified duration
   - Simulates real long-running process

2. **Output Capture** (shell redirection in playbook):
   - Uses process substitution for parallel tee
   - Unbuffered with stdbuf
   - Separate files for stdout/stderr

3. **Output Monitoring** (playbook loop):
   - Checks if files exist
   - Reads file contents
   - Displays to user
   - Polls until task completes

4. **Display Modes** (configurable):
   - Full: Shows entire file contents
   - Tail: Shows last N lines only

**Data Flow:**

```
Helper Script
    ├─ stdout ─> stdbuf ─> tee ─> ~/.ansible_async/${job_id}.stdout
    └─ stderr ─> stdbuf ─> tee ─> ~/.ansible_async/${job_id}.stderr
                                          ↓
                                   Monitoring Loop
                                   (read files periodically)
                                          ↓
                                   Display to User
                                   (full or tail mode)
```

### Technical Specification

#### Component 1: Helper Script (`scripts/generate_output.sh`)

**Purpose**: Generate predictable output for testing async capture

**Location**: `ansible_collection/scripts/generate_output.sh`

**Interface**:
```bash
generate_output.sh [OPTIONS]

OPTIONS:
  -d, --duration SECONDS   Total duration to run (default: 300 = 5 minutes)
  -c, --count LINES        Number of lines to output (default: 50)
  -h, --help               Show help message

BEHAVIOR:
  - Calculates interval: INTERVAL = DURATION / COUNT
  - Writes to stdout: "stdout line N of COUNT"
  - Writes to stderr: "error no.N of COUNT"
  - Sleeps INTERVAL between lines
  - Exits with code 0 on success
```

**Implementation**:
```bash
#!/usr/bin/env bash
#
# generate_output.sh - Generate predictable stdout/stderr output over time
#
# Usage: generate_output.sh [-d duration] [-c count]

set -euo pipefail

# Defaults
DURATION=300  # 5 minutes
COUNT=50

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--duration) DURATION="$2"; shift 2 ;;
    -c|--count) COUNT="$2"; shift 2 ;;
    -h|--help) echo "Usage: $0 [-d duration] [-c count]"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Calculate interval
INTERVAL=$(awk "BEGIN {printf \"%.2f\", $DURATION / $COUNT}")

echo "Starting output generation: $COUNT lines over $DURATION seconds" >&2
echo "Interval: $INTERVAL seconds per line" >&2

for i in $(seq 1 $COUNT); do
  echo "stdout line $i of $COUNT"
  echo "error no.$i of $COUNT" >&2

  # Don't sleep after last line
  if [ $i -lt $COUNT ]; then
    sleep $INTERVAL
  fi
done

echo "Output generation completed" >&2
exit 0
```

**Permissions**: 0755 (executable)

**Dependencies**: bash, seq, awk, sleep

#### Component 2: Example Playbook (`scenario_05_live_output.yml`)

**Purpose**: Demonstrate async task with live output capture and monitoring

**Location**: `ansible_collection/scenario_05_live_output.yml`

**Variables**:
```yaml
vars:
  script_path: "{{ playbook_dir }}/scripts/generate_output.sh"
  script_duration: 300          # seconds (5 minutes)
  script_line_count: 50
  output_dir: "~/.ansible_async"
  display_mode: "tail"          # "full" or "tail"
  tail_lines: 20                # used when display_mode=tail
  monitor_interval: 5           # seconds between monitoring checks
```

**Playbook Structure**:

**Task 1**: Ensure output directory exists
```yaml
- name: Ensure async output directory exists
  ansible.builtin.file:
    path: "{{ output_dir }}"
    state: directory
    mode: '0700'
```

**Task 2**: Launch script with output capture
```yaml
- name: Launch script with stdout/stderr capture
  ansible.builtin.shell: |
    stdbuf -oL -eL {{ script_path }} \
      --duration {{ script_duration }} \
      --count {{ script_line_count }} \
      2> >(tee {{ output_dir }}/{{ async_result.ansible_job_id }}.stderr >&2) \
      1> >(tee {{ output_dir }}/{{ async_result.ansible_job_id }}.stdout)
  async: "{{ script_duration + 30 }}"
  poll: 0
  register: async_result
  args:
    executable: /bin/bash
```

**Note**: This requires two-phase approach:
1. First register to get job_id
2. Second use job_id in file names

**Revised Task 2 Structure**:
```yaml
- name: Create wrapper script with output capture
  ansible.builtin.tempfile:
    state: file
    suffix: _wrapper.sh
  register: wrapper_script

- name: Write wrapper script content
  ansible.builtin.copy:
    dest: "{{ wrapper_script.path }}"
    mode: '0700'
    content: |
      #!/bin/bash
      JOB_ID="$1"
      shift
      stdbuf -oL -eL "$@" \
        2> >(tee ~/.ansible_async/${JOB_ID}.stderr >&2) \
        1> >(tee ~/.ansible_async/${JOB_ID}.stdout)

- name: Launch async task
  ansible.builtin.shell: "{{ wrapper_script.path }} $ASYNC_JOB_ID {{ script_path }} -d {{ script_duration }} -c {{ script_line_count }}"
  async: "{{ script_duration + 30 }}"
  poll: 0
  register: async_result
  environment:
    ASYNC_JOB_ID: "{{ 999999999 | random | string }}_{{ ansible_date_time.epoch }}"
```

**Better Approach - Use job_id post-facto**:
```yaml
- name: Launch async task (output captured to temp location first)
  ansible.builtin.shell: |
    stdbuf -oL -eL {{ script_path }} \
      --duration {{ script_duration }} \
      --count {{ script_line_count }} \
      > {{ output_dir }}/temp_$$.stdout \
      2> {{ output_dir }}/temp_$$.stderr
  async: "{{ script_duration + 30 }}"
  poll: 0
  register: async_result

- name: Rename output files to use job_id
  ansible.builtin.shell: |
    mv {{ output_dir }}/temp_*.stdout {{ output_dir }}/{{ async_result.ansible_job_id }}.stdout
    mv {{ output_dir }}/temp_*.stderr {{ output_dir }}/{{ async_result.ansible_job_id }}.stderr
```

**Final Design Decision - Simple Approach**:

Use fixed wrapper script that accepts job_id as first parameter:

**Task 2a**: Ensure wrapper script exists (one-time setup)
```yaml
- name: Ensure capture wrapper script exists
  ansible.builtin.copy:
    dest: "{{ playbook_dir }}/scripts/capture_wrapper.sh"
    mode: '0755'
    content: |
      #!/bin/bash
      JOB_ID="$1"
      shift
      OUTPUT_DIR="${HOME}/.ansible_async"
      mkdir -p "${OUTPUT_DIR}"
      stdbuf -oL -eL "$@" \
        2> >(tee "${OUTPUT_DIR}/${JOB_ID}.stderr" >&2) \
        1> >(tee "${OUTPUT_DIR}/${JOB_ID}.stdout")
```

**Task 2b**: Generate unique job_id
```yaml
- name: Generate unique job identifier
  ansible.builtin.set_fact:
    custom_job_id: "live_output_{{ ansible_date_time.epoch }}_{{ 999999 | random }}"
```

**Task 2c**: Launch with capture
```yaml
- name: Launch async task with live output capture
  ansible.builtin.shell: >
    {{ playbook_dir }}/scripts/capture_wrapper.sh
    {{ custom_job_id }}
    {{ script_path }}
    --duration {{ script_duration }}
    --count {{ script_line_count }}
  async: "{{ script_duration + 30 }}"
  poll: 0
  register: async_result
  args:
    executable: /bin/bash
```

**Task 3**: Wait for output files to be created
```yaml
- name: Wait for output files to be created
  ansible.builtin.wait_for:
    path: "{{ output_dir }}/{{ custom_job_id }}.{{ item }}"
    timeout: 30
  loop:
    - stdout
    - stderr
```

**Task 4**: Monitoring loop
```yaml
- name: Monitor async task output
  block:
    - name: Check task status
      ansible.builtin.async_status:
        jid: "{{ async_result.ansible_job_id }}"
      register: job_status
      ignore_errors: true

    - name: Check if stdout file exists and read it
      ansible.builtin.slurp:
        src: "{{ output_dir }}/{{ custom_job_id }}.stdout"
      register: stdout_content
      ignore_errors: true

    - name: Check if stderr file exists and read it
      ansible.builtin.slurp:
        src: "{{ output_dir }}/{{ custom_job_id }}.stderr"
      register: stderr_content
      ignore_errors: true

    - name: Display stdout (full mode)
      ansible.builtin.debug:
        msg: "{{ (stdout_content.content | b64decode).split('\n') }}"
      when: display_mode == 'full' and stdout_content is succeeded

    - name: Display stdout (tail mode)
      ansible.builtin.debug:
        msg: "{{ (stdout_content.content | b64decode).split('\n') | tail(tail_lines) }}"
      when: display_mode == 'tail' and stdout_content is succeeded

    - name: Display stderr (full mode)
      ansible.builtin.debug:
        msg: "{{ (stderr_content.content | b64decode).split('\n') }}"
      when: display_mode == 'full' and stderr_content is succeeded

    - name: Display stderr (tail mode)
      ansible.builtin.debug:
        msg: "{{ (stderr_content.content | b64decode).split('\n') | tail(tail_lines) }}"
      when: display_mode == 'tail' and stderr_content is succeeded

    - name: Display task status
      ansible.builtin.debug:
        msg: "Task status: {{ 'COMPLETED' if job_status.finished | default(false) else 'RUNNING' }}"

    - name: Wait before next check
      ansible.builtin.pause:
        seconds: "{{ monitor_interval }}"
      when: not (job_status.finished | default(false))

  rescue:
    - name: Handle monitoring errors
      ansible.builtin.debug:
        msg: "Error during monitoring: {{ ansible_failed_result.msg | default('Unknown error') }}"

  # Loop until task completes
  until: job_status.finished | default(false)
  retries: "{{ (script_duration / monitor_interval) | int + 5 }}"
  delay: 0  # delay handled by pause task
```

**Task 5**: Display final results
```yaml
- name: Display final task completion
  ansible.builtin.debug:
    msg: |
      Task completed!
      Return code: {{ job_status.rc | default('N/A') }}
      Output files:
        - {{ output_dir }}/{{ custom_job_id }}.stdout
        - {{ output_dir }}/{{ custom_job_id }}.stderr
```

**Error Handling:**

1. **Script not found**: Check script_path exists before launch
2. **Output directory creation fails**: File module will report error
3. **Task fails**: async_status will capture failure, display error
4. **Files don't appear**: wait_for will timeout with clear message
5. **slurp fails** (file too large): ignore_errors prevents playbook abort, user sees warning

### Implementation Approach

**Step 1**: Create scripts directory and helper script
- Directory: `ansible_collection/scripts/`
- Script: `generate_output.sh` with documented parameters
- Wrapper: `capture_wrapper.sh` for output redirection
- Make executable: `chmod +x`

**Step 2**: Create scenario playbook
- File: `ansible_collection/scenario_05_live_output.yml`
- Follow structure from scenario_01-04
- Add comprehensive comments
- Include usage examples in header

**Step 3**: Test components independently
- Run `generate_output.sh` standalone
- Verify output format and timing
- Test wrapper script manually
- Verify tee and stdbuf behavior

**Step 4**: Test integrated playbook
- Run with default parameters
- Test full vs tail display modes
- Verify monitoring loop behavior
- Test error conditions

**Step 5**: Document usage
- Add README.md in scripts/ directory
- Document prerequisites
- Provide usage examples
- Include troubleshooting guide

### Testing Strategy

**Functional Tests:**

**Test 1: Helper script execution**
```bash
# Test with defaults
./scripts/generate_output.sh

# Test with custom parameters
./scripts/generate_output.sh --duration 60 --count 10

# Verify output format
./scripts/generate_output.sh -d 10 -c 5 2>&1 | head -10
```

**Expected**: Lines formatted correctly, timing accurate

**Test 2: Wrapper script functionality**
```bash
# Test wrapper manually
./scripts/capture_wrapper.sh test_job ./scripts/generate_output.sh -d 30 -c 5

# Verify files created
ls -la ~/.ansible_async/test_job.{stdout,stderr}

# Verify real-time updates (in another terminal)
tail -f ~/.ansible_async/test_job.stdout
```

**Expected**: Files created, updated in real-time

**Test 3: Full playbook execution (tail mode)**
```bash
ansible-playbook scenario_05_live_output.yml
```

**Expected**:
- Task launches successfully
- Output files created
- Monitoring displays last 20 lines
- Updates every 5 seconds
- Completes successfully

**Test 4: Full display mode**
```bash
ansible-playbook scenario_05_live_output.yml -e "display_mode=full"
```

**Expected**:
- Displays all output (50 lines from both streams)
- Memory usage acceptable

**Test 5: Custom parameters**
```bash
ansible-playbook scenario_05_live_output.yml \
  -e "script_duration=60" \
  -e "script_line_count=20" \
  -e "monitor_interval=10"
```

**Expected**: 60-second run, 20 lines, checked every 10 seconds

**Edge Cases:**

**Edge Case 1: Task completes before first monitoring check**
- Use very short duration: `-e "script_duration=1"`
- **Expected**: Monitoring catches completion, displays final output

**Edge Case 2: Very large output**
- Use high line count: `-e "script_line_count=10000"`
- Use tail mode
- **Expected**: slurp might be slow but works, tail mode manageable

**Edge Case 3: Script doesn't exist**
- Use invalid path: `-e "script_path=/nonexistent"`
- **Expected**: Clear error message, playbook fails gracefully

**Edge Case 4: No stdbuf available**
- Test on system without GNU coreutils
- **Expected**: Documented as prerequisite, provides alternative

**Success Criteria:**

1. ✅ Script generates expected output format
2. ✅ Output files created with correct naming
3. ✅ Files update in real-time (observable with tail -f)
4. ✅ Monitoring loop displays output
5. ✅ Both full and tail modes work
6. ✅ Task completion detected correctly
7. ✅ All edge cases handled gracefully

### Integration Notes

**Dependencies:**

- **Sprint 11/12**: Can reference async_job_save/load roles in documentation (optional)
- **Sprint 13**: Uses same output directory convention
- **No hard dependencies**: This example is standalone

**Compatibility:**

- Coexists with all existing scenarios
- Uses different file naming (no collision)
- Follows established playbook structure
- Can be run independently or as part of test suite

**Reusability:**

- Helper script reusable for any testing scenario
- Wrapper script pattern applicable to other use cases
- Monitoring loop pattern can be extracted to role (future)
- Documentation serves as template for similar problems

### Documentation Requirements

**User Documentation:**

1. **README for scripts/**:
   - Purpose of each script
   - Parameters and usage
   - Examples
   - Prerequisites

2. **Playbook header comments**:
   - What this demonstrates
   - Prerequisites (bash, stdbuf)
   - How to run
   - Configuration options
   - Expected output

3. **Implementation documentation**:
   - Why this approach chosen
   - How output capture works
   - Alternative approaches
   - Limitations and trade-offs

**Technical Documentation:**

1. **Process substitution explanation**:
   - Why `>()` syntax
   - bash requirement
   - How tee captures output

2. **Unbuffered output**:
   - Role of stdbuf
   - Why needed for real-time
   - Alternative approaches

3. **Monitoring pattern**:
   - slurp vs command module
   - Memory considerations
   - Full vs tail trade-offs

### Design Decisions

**Decision 1: Separate wrapper script vs inline**
**Rationale**: Wrapper script cleaner, reusable, easier to test
**Alternatives**: Inline shell with heredoc (more complex, harder to debug)

**Decision 2: Custom job_id vs ansible_job_id**
**Rationale**: ansible_job_id not available until after execution, need name upfront
**Alternatives**: Pre-generate id (chosen), post-facto rename (race condition)

**Decision 3: slurp vs command: cat**
**Rationale**: slurp is native Ansible, returns base64 (clean), command module alternative
**Alternatives**: Both viable, chose slurp for Ansible-native approach

**Decision 4: Tail in Jinja vs tail command**
**Rationale**: Jinja filter `| tail(N)` is pure Ansible, no shell dependency
**Alternatives**: `tail -n N` via command module (extra process)

**Decision 5: Monitoring loop with until**
**Rationale**: Native Ansible loop construct, clear semantics
**Alternatives**: While loop with include_tasks (more complex)

**Decision 6: Separate files for stdout/stderr**
**Rationale**: Clearer, easier to parse, matches common practice
**Alternatives**: Combined file with stream markers (harder to parse)

### Open Design Questions

None - All design decisions made in YOLO mode (documented above).

---

# Design Summary

## Overall Architecture

Simple two-component solution demonstrating live output capture pattern:

1. **Helper infrastructure** (scripts):
   - Output generator for testing
   - Capture wrapper for redirection
   - Reusable across scenarios

2. **Example playbook** (scenario_05):
   - Launches task with capture
   - Monitors output files
   - Displays with flexible modes
   - Educational and practical

## Shared Components

- Scripts directory convention (`ansible_collection/scripts/`)
- Output directory convention (`~/.ansible_async/`)
- File naming pattern (`${job_id}.{stdout,stderr}`)
- Monitoring loop pattern (reusable)

## Design Risks

**Overall Risk Level: Low**

All risks mitigated:
- ✅ Shell dependencies documented
- ✅ Memory limits addressed (tail mode)
- ✅ Error handling comprehensive
- ✅ Prerequisites clearly stated
- ✅ Alternative approaches documented

## Resource Requirements

**Tools**:
- bash shell (version 3.0+)
- GNU coreutils (stdbuf, tee, seq)
- Ansible 2.9+ (for included modules)

**System Resources**:
- Disk: Minimal (output files ~10KB for default config)
- Memory: Low (slurp overhead, mitigated by tail mode)
- CPU: Negligible

## Design Approval Status

Status: Proposed

**YOLO Mode**: Auto-approval after 60 seconds → Accepted

---

**Design Status**: Accepted (YOLO auto-approval)

**Justification**:
- Clear, implementable design
- All requirements addressed
- Risks identified and mitigated
- Testing strategy comprehensive
- Follows established patterns
- No critical unknowns

**Ready for Construction**: ✅ Yes
