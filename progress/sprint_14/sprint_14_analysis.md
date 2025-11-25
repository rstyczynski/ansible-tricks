# Sprint 14 - Requirements Analysis

**Sprint**: 14
**Status**: under_analysis
**Backlog Item**: GHC-17
**Date**: 2025-11-25
**Mode**: YOLO

## Sprint Overview

Sprint 14 adds a new example demonstrating how to capture live stdout/stderr output from async tasks. This addresses the limitation that `ansible.builtin.async_status` only returns output after task completion, not during execution.

**Goal**: Create copy-paste-able example showing real-time output capture pattern.

## Backlog Item Analysis: GHC-17

### Requirement Summary

**What**: Add example for async processing getting data from script's log

**Why**: Ansible's native async mechanism (`async_status`) doesn't provide live output stream during task execution. Users need a pattern to monitor long-running tasks in real-time.

**Context**: Complements Sprint 11-13 async infrastructure with practical usage pattern.

### Detailed Requirements

From BACKLOG.md GHC-17:

1. **Playbook runs a script** that is provided as parameter
   - Script path should be configurable
   - Script is a separate file (not inline)

2. **Script generates predictable output**:
   - Runs for 5 minutes
   - stdout: writes in loop `stdout line 1 of 50`, `stdout line 2 of 50`, etc.
   - stderr: writes in loop `error no.1 of 50`, `error no.2 of 50`, etc.
   - Output is time-spaced to simulate real work

3. **Playbook captures output using tee**:
   - Redirects stdout to `~/.ansible_async/{{ job_id }}.stdout`
   - Redirects stderr to `~/.ansible_async/{{ job_id }}.stderr`
   - Uses tee command for capture
   - Shell redirection structure required

4. **tee works in unbuffered mode**:
   - Each line flushed immediately
   - Use `stdbuf` or tee options
   - Ensures real-time file updates

5. **Playbook monitors output files**:
   - Shows full contents of stdout/stderr files
   - Demonstrates monitoring while task runs
   - Uses standard Ansible file reading

6. **Alternative tail display**:
   - Parameter controls full vs tail display
   - Tail shows last N lines only
   - Useful for very long output

### Technical Approach

**Implementation Strategy**:

1. **Create helper script** (`scripts/generate_output.sh`):
   - Accepts parameters: duration, line_count
   - Writes to stdout and stderr in loop
   - Timing controlled to spread over duration
   - Exits cleanly with status code

2. **Create scenario playbook** (`scenario_05_live_output.yml`):
   - Launches script with async
   - Uses shell redirection: `script 2> >(tee stderr) 1> >(tee stdout)`
   - Captures job_id for file naming
   - Monitors files in loop
   - Displays content (full or tail)

3. **Output capture mechanism**:
   ```bash
   stdbuf -oL -eL script.sh 2> >(tee ~/.ansible_async/${job_id}.stderr) 1> >(tee ~/.ansible_async/${job_id}.stdout)
   ```
   - `stdbuf -oL -eL`: Line-buffered stdout/stderr
   - Process substitution `>()` for parallel tee
   - tee writes to file and passes through

4. **Monitoring approach**:
   - Use `async_status` to check if task running
   - Use `slurp` or `command: cat` to read output files
   - Loop with delay (e.g., every 5 seconds)
   - Stop when task completes

### Dependencies

**Depends On**:
- Sprint 11 (GHC-15): async_job_save/load roles (will use for metadata)
- Sprint 13 (BF-1): Fixed key uniqueness (ensures proper file isolation)

**Does NOT depend on**:
- No new roles needed
- No external tools beyond standard shell utilities
- No OCI or external storage

**Ansible Capabilities Required**:
- ansible.builtin.shell (with async) ✅ Available
- ansible.builtin.async_status ✅ Available
- ansible.builtin.slurp ✅ Available
- ansible.builtin.stat ✅ Available
- ansible.builtin.pause (for monitoring loop delay) ✅ Available

### Testing Strategy

**Functional Tests**:

1. **Test 1: Script execution and output generation**
   - Run helper script standalone
   - Verify stdout/stderr format
   - Verify timing and line count

2. **Test 2: Output capture during execution**
   - Run playbook
   - While task running, verify files are created
   - Verify files update in real-time (use `tail -f` manually)
   - Verify tee unbuffered behavior

3. **Test 3: Output monitoring**
   - Run playbook with monitoring enabled
   - Verify playbook displays live output
   - Verify display updates each loop iteration

4. **Test 4: Full vs tail display**
   - Run with `display_mode: full`
   - Run with `display_mode: tail` and `tail_lines: 10`
   - Verify appropriate content displayed

5. **Test 5: Completion handling**
   - Verify monitoring stops when task completes
   - Verify final output captured completely
   - Verify job status reported correctly

**Edge Cases**:

1. Script fails/crashes mid-execution
2. Output files already exist (cleanup needed)
3. Very large output (memory considerations for slurp)
4. Task completes before first monitoring check

### Risks/Concerns

**Risk 1: Shell complexity**
- **Description**: Process substitution `>()` syntax is bash-specific
- **Mitigation**: Document bash requirement, test on target systems
- **Severity**: Low (bash is standard)

**Risk 2: File buffering**
- **Description**: Output may not flush immediately without stdbuf
- **Mitigation**: Use stdbuf with line buffering, document requirements
- **Severity**: Low (stdbuf widely available)

**Risk 3: File size with slurp**
- **Description**: slurp loads entire file into memory
- **Mitigation**: Recommend tail mode for large outputs, document limit
- **Severity**: Medium (user education needed)

**Risk 4: Cleanup**
- **Description**: Output files accumulate over time
- **Mitigation**: Document manual cleanup, consider adding cleanup task
- **Severity**: Low (example code, user responsibility)

### Compatibility Notes

**Integration with Existing Work**:

1. **async_job_save/load roles**:
   - Will use for job metadata storage (optional)
   - Follows same playbook_name pattern from Sprint 13
   - Output files are separate from job metadata

2. **Existing scenarios**:
   - New scenario_05 doesn't modify existing scenarios
   - Follows same naming/structure pattern
   - Can coexist with all existing scenarios

3. **File conventions**:
   - Uses `~/.ansible_async/` directory (matches Ansible convention)
   - Naming: `${job_id}.stdout` and `${job_id}.stderr`
   - No collision with async_status files (`.ansible_async` dir)

**Reuse Opportunities**:
- Can reference async_job_save/load for metadata
- Can use same test structure as scenario_01-04
- Can reuse documentation patterns from Sprint 11/12

## Overall Sprint Assessment

### Feasibility: High (95%)

**Technical Feasibility**:
- All required Ansible modules available ✅
- Shell features (tee, process substitution) standard ✅
- Pattern proven in many production systems ✅
- No new dependencies required ✅

**Implementation Complexity**: Low-Medium
- Helper script: Simple bash (~30 lines)
- Playbook: Medium complexity (~100 lines)
- No complex logic, mostly shell orchestration
- Well-documented pattern

**Testing Feasibility**: High
- Easy to observe behavior (watch files in real-time)
- Clear success criteria (files update, output displays)
- Quick iteration cycle (5 minute script)

### Estimated Complexity: Moderate

**Why Moderate**:
- Shell redirection requires careful syntax
- Process substitution needs testing
- Monitoring loop adds complexity
- Good documentation needed for copy-paste use

**Why Not Complex**:
- No new roles/modules needed
- Pure example code (not production infrastructure)
- Limited scope (single scenario + script)
- Well-understood problem domain

### Prerequisites Met: Yes ✅

1. ✅ Ansible installed and working
2. ✅ bash shell available
3. ✅ Standard utilities (tee, stdbuf) available
4. ✅ Existing async infrastructure from Sprint 11-13
5. ✅ Test patterns established from prior sprints

**No blockers identified.**

## Open Questions

**None** - All requirements clear in YOLO mode.

**YOLO Mode Decisions** (will be made during design):
1. Exact script parameters (duration, count, interval)
2. Monitoring loop interval (every N seconds)
3. Default tail line count
4. File cleanup strategy (manual vs automatic)
5. Error handling depth

## Recommended Design Focus Areas

1. **Shell redirection syntax**:
   - Test process substitution carefully
   - Document bash requirement
   - Provide clear examples

2. **Unbuffered output**:
   - stdbuf parameters
   - Verify real-time behavior
   - Alternative approaches if stdbuf unavailable

3. **Monitoring loop design**:
   - Polling interval selection
   - Exit condition (task completion)
   - Display formatting

4. **User documentation**:
   - Copy-paste examples are critical
   - Prerequisites must be explicit
   - Expected behavior clearly described

5. **File management**:
   - Cleanup recommendations
   - Large file handling
   - Error scenarios

## Readiness for Design Phase

✅ **Confirmed Ready**

**Checklist**:
- ✅ Requirements fully understood
- ✅ Technical approach identified
- ✅ Dependencies mapped
- ✅ APIs available and sufficient
- ✅ Testing strategy defined
- ✅ Risks assessed and mitigated
- ✅ Compatibility verified
- ✅ No blocking open questions

**Next Phase**: Elaboration (Design)

Design will specify:
- Complete script implementation
- Exact playbook structure
- Shell command syntax
- Monitoring loop logic
- Parameter specifications
- Test case details

## YOLO Mode Decisions

This sprint was analyzed in YOLO (autonomous) mode. The following assumptions were made:

### Assumption 1: Script Duration and Frequency
**Issue**: Exact script behavior not specified in detail
**Assumption Made**: 50 lines over 5 minutes = ~6 seconds per line
**Rationale**: Gives observable real-time behavior without excessive wait
**Risk**: Low - easily adjustable in implementation

### Assumption 2: Directory Location
**Issue**: Exact file location not mandated
**Assumption Made**: Use `~/.ansible_async/` to match Ansible conventions
**Rationale**: Consistent with Ansible's own async file location
**Risk**: Low - standard pattern, well-understood

### Assumption 3: Monitoring Approach
**Issue**: Monitoring mechanism not specified
**Assumption Made**: Use slurp module in loop with pause
**Rationale**: Pure Ansible approach, no external dependencies
**Risk**: Low - well-supported module

### Assumption 4: Full/Tail Parameter
**Issue**: Parameter name and behavior not specified
**Assumption Made**: `display_mode: full|tail` with `tail_lines: N`
**Rationale**: Clear, self-documenting parameter names
**Risk**: Low - naming is arbitrary for example code

### Assumption 5: Script Reusability
**Issue**: Should script be general-purpose or example-specific?
**Assumption Made**: Make it parameterized and reusable
**Rationale**: More useful as learning tool, shows best practices
**Risk**: Low - adds minimal complexity

---

**Analysis Complete**
**Analyst Recommendation**: Proceed to Elaboration phase for detailed design.
