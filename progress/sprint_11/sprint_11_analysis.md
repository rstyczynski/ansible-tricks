# Sprint 11 - Analysis

Status: Complete

## Sprint Overview

**Sprint Number:** 11
**Sprint Status:** under_analysis (updated in PROGRESS_BOARD.md)
**Execution Mode:** YOLO (autonomous)

**Sprint Goal:**
Create a new Ansible Collection (`rstyczynski.ansible`) with general-purpose Ansible tools. The first feature is support for long-running tasks with persistence and resumability.

**Strategic Context:**
This Sprint marks a new direction for the project - moving beyond GitHub-specific tooling (rstyczynski.github collection) to provide general-purpose Ansible utilities that solve common operational challenges across any infrastructure automation scenario.

## Backlog Items Analysis

### GHC-15: Long running task

**Requirement Summary:**

Create a new Ansible collection `rstyczynski.ansible` with infrastructure for handling long-running tasks that can:
1. Execute asynchronously using Ansible's `async` and `poll` features
2. Store job state in configurable persistence backends (Ara, local filesystem, object storage)
3. Allow playbook to exit and resume later
4. Handle host crashes gracefully
5. Track job identifiers with host, playbook name, and play identifier

**Detailed Requirements from BACKLOG.md:**

1. **New Collection Structure:**
   - Collection FQCN: `rstyczynski.ansible`
   - Product directory: `$repo_root/ansible_collection`
   - Collection working directory: `$repo_root/ansible_collection/collections/ansible_collections`
   - Test playbook: `$repo_root/ansible_collection/long_running_flow.yml`

2. **Technical Approach:**
   - Use Ansible's native `task` with `async` (don't reinvent the wheel)
   - Store job identifier in a map with: host, playbook name, play identifier
   - Flush state to persistent storage
   - Configurable persistence: Ara, local filesystem, or object storage

3. **Test Coverage Required:**
   - Test 1: Controller playbook waits for result
   - Test 2: Controller playbook exits after task invocation
   - Test 3: Controller playbook returns with host and job_id to check result, finishes cleanly when task is done
   - Test 4: Managed host crashes and loses process, controller handles gracefully

**Technical Approach:**

**Phase 1: Collection Setup**
- Initialize new collection structure at `ansible_collection/collections/ansible_collections/rstyczynski/ansible/`
- Create `galaxy.yml` with collection metadata
- Establish directory structure: roles/, plugins/, docs/, tests/
- Create collection README.md

**Phase 2: Core Long-Running Task Role**
- Role name: `async_task` or `long_running_task`
- Wrapper around Ansible's `async` and `poll` mechanisms
- Support for:
  - Starting async tasks
  - Checking async task status
  - Resuming/checking previously started tasks
  - Handling timeouts and failures

**Phase 3: Persistence Layer**
- Abstract persistence interface
- Implementations:
  - Local filesystem (JSON/YAML files in `.ansible_state/` or configurable directory)
  - Ara REST API (if available - leverage Sprint 8 work)
  - Object storage (S3-compatible - future extensibility)
- Job state structure: `{host, playbook_name, play_id, job_id, task_name, start_time, status, result}`

**Phase 4: Controller Logic**
- Role or playbook utilities for:
  - Launching async tasks and recording job identifiers
  - Querying task status from persistence
  - Resuming playbook execution based on stored state
  - Cleanup of completed job records

**Phase 5: Test Playbooks**
- `long_running_flow.yml` demonstrating all test cases
- Simple long-running task for testing (e.g., sleep, file download, data processing)
- Scenarios for each test case requirement

**Dependencies:**

1. **Ansible Core**: Relies on `async_status` module (ansible.builtin)
2. **Python**: For any custom modules or filters (if needed)
3. **Ara (optional)**: Sprint 8 established Ara integration; can leverage for persistence
4. **Existing patterns**: Follow input/output specification pattern from local rules
5. **Collection conventions**: Mirror structure of `rstyczynski.github` collection for consistency

**Testing Strategy:**

**Test 1: Controller Waits for Result**
- Start async task with `poll > 0`
- Verify task completes
- Check result is captured correctly
- Validate persistence stores final state

**Test 2: Controller Exits After Invocation**
- Start async task with `poll = 0`
- Record job_id to persistence
- Playbook exits immediately
- Verify job_id and metadata persisted correctly

**Test 3: Controller Resumes and Checks Result**
- Load job_id from persistence
- Use `async_status` to check completion
- Handle still-running vs completed scenarios
- Clean exit when task completes
- Test multiple resume attempts

**Test 4: Managed Host Crash Handling**
- Simulate host crash (kill process, stop container)
- Controller attempts to check status
- Gracefully handle "job not found" or connection failure
- Mark job as failed in persistence
- Provide clear error messaging

**Test Artifacts:**
- Molecule tests for role(s) where applicable
- Integration test playbooks for all 4 scenarios
- Test with Podman containers as managed hosts (following Ansible best practices)
- Idempotency tests

**Risks/Concerns:**

**Risk 1: Persistence Complexity**
- **Issue**: Supporting multiple backends (filesystem, Ara, S3) adds complexity
- **Mitigation**: Start with filesystem-only, design abstract interface for future backends
- **YOLO Decision**: Implement filesystem persistence first; document extension points

**Risk 2: Ara Integration Stability**
- **Issue**: Sprint 8 noted Ansible 2.20.0 + Ara 1.7.3 compatibility issues
- **Mitigation**: Make Ara optional; default to filesystem persistence
- **YOLO Decision**: Filesystem is primary; Ara is bonus feature if time permits

**Risk 3: Host Crash Detection**
- **Issue**: Distinguishing "still running" from "host crashed" is non-trivial
- **Mitigation**: Use timeouts, connection checks, and explicit failure markers
- **YOLO Decision**: Use async_status failures + timeouts as crash detection

**Risk 4: Concurrent Playbook Execution**
- **Issue**: Multiple playbooks might access same persistence store
- **Mitigation**: Use unique play identifiers, implement basic locking or append-only writes
- **YOLO Decision**: Use timestamp + random UUID for play identifiers to avoid collisions

**Risk 5: State File Corruption**
- **Issue**: Interrupted writes could corrupt filesystem persistence
- **Mitigation**: Write to temporary file, then atomic rename
- **YOLO Decision**: Use JSON/YAML with atomic writes; document backup recommendations

**Compatibility Notes:**

**Integration with Existing Collections:**
- New collection (`rstyczynski.ansible`) is independent from `rstyczynski.github`
- Both collections can coexist in same environment
- Can be used together in playbooks (e.g., GitHub workflow with long-running tasks)
- No code dependencies between collections

**Ara Integration (Sprint 8):**
- Ara provides playbook audit trail and run tracking
- Could serve as persistence backend for job state
- Ara REST API allows storing/retrieving custom data
- Sprint 8's environment variable approach is compatible with this Sprint

**Collection Standards:**
- Follow same structure as `rstyczynski.github`:
  - `meta/argument_specs.yml` for all roles
  - Input/output specification pattern from local rules
  - `ansible.builtin.validate_argument_spec` for validation
  - Variable prefixing (role name prefix)
  - FQCN usage throughout
  - README.md for collection and roles

**Ansible Best Practices Alignment:**
- Uses native `async`/`poll` (not reinventing the wheel ✓)
- Idempotent operations (checking status is idempotent ✓)
- No shell/command unless necessary ✓
- Proper error handling ✓
- Documentation with copy-paste examples ✓

**Test Environment:**
- Use Podman for creating test targets (per Ansible best practices)
- Molecule for role testing
- Integration tests in main `long_running_flow.yml`

## Overall Sprint Assessment

**Feasibility:** High

This Sprint is technically feasible using native Ansible capabilities:
- Ansible's `async` and `async_status` provide core functionality
- Filesystem persistence is straightforward (JSON/YAML files)
- Ara integration is optional (reduces critical path)
- Test scenarios are achievable with Podman containers

**Estimated Complexity:** Moderate

Complexity factors:
- **Low complexity**: Collection setup, basic async task execution
- **Moderate complexity**: Persistence layer design and implementation
- **Moderate complexity**: Resume/check logic and state management
- **Moderate-high complexity**: Test case 4 (host crash simulation and handling)

Overall: Moderate complexity due to state management and edge case handling, but well within Ansible's capabilities.

**Prerequisites Met:** Yes

All prerequisites are satisfied:
- Ansible installed and working (used in previous Sprints)
- Understanding of `async`/`poll` mechanisms
- Collection structure patterns established in Sprint 2
- Testing patterns established in previous Sprints
- Podman available for test targets
- Ara available (optional) from Sprint 8

**Open Questions:**

None - All requirements are sufficiently clear for YOLO mode execution.

**YOLO Mode Assumptions:**
Since this Sprint is in YOLO mode, the following assumptions are reasonable and will be documented in design:

1. **Assumption**: Filesystem persistence is the primary implementation; Ara/S3 are documented extension points
   - **Rationale**: Simplest, most reliable, no external dependencies
   - **Risk**: Low

2. **Assumption**: Play identifier will use `ansible_date_time.epoch` + random UUID suffix
   - **Rationale**: Ensures uniqueness without coordination
   - **Risk**: Low

3. **Assumption**: Persistence location defaults to `.ansible_async_state/` in playbook directory
   - **Rationale**: Follows Ansible conventions, easily discoverable
   - **Risk**: Low

4. **Assumption**: Host crash detection uses `async_status` failures + configurable timeout
   - **Rationale**: Leverages Ansible's built-in mechanisms
   - **Risk**: Low - may have false positives on slow networks (acceptable trade-off)

5. **Assumption**: Initial implementation supports single async task per role invocation
   - **Rationale**: Simpler logic, covers stated requirements
   - **Risk**: Low - can be extended later if batch async tasks needed

## Recommended Design Focus Areas

1. **Persistence Layer Architecture**
   - Abstract interface design for pluggable backends
   - Filesystem implementation with atomic writes
   - State schema definition (JSON structure)
   - Migration path for future backends

2. **Role Interface Design**
   - Input parameters: task command/script, timeout, poll interval, persistence config
   - Output attributes: job_id, status, result
   - Mode selection: "start", "check", "wait"

3. **State Management Logic**
   - Job ID generation and uniqueness
   - State file organization (per-host, per-playbook, or flat)
   - Cleanup strategies (TTL, explicit cleanup tasks)

4. **Error Handling**
   - Connection failures vs task failures
   - Timeout handling
   - Corrupted state files
   - Missing job IDs

5. **Test Scenario Implementation**
   - Realistic long-running task (e.g., 30-second sleep)
   - Podman container setup/teardown
   - Host crash simulation (container stop)
   - Multiple resume attempts

## Readiness for Design Phase

**Status:** Confirmed Ready

**Reasoning:**
- Requirements are clear and technically feasible
- Dependencies identified and available
- Test scenarios well-defined
- Risks identified with reasonable mitigations
- YOLO mode assumptions documented
- Compatible with existing work (Sprint 8 Ara, existing collection patterns)

**Design Phase Priorities:**
1. Design collection structure and role architecture
2. Define persistence layer interface and filesystem implementation
3. Specify role input/output with argument_specs.yml
4. Detail state schema and job lifecycle
5. Plan test implementation with Podman

**No Blockers:** Proceed to Elaboration phase.

## YOLO Mode Decisions

This Sprint was analyzed in YOLO (autonomous) mode. The following assumptions were made:

### Assumption 1: Filesystem-Primary Persistence

**Issue:** Backlog mentions "Ara, local file system, object storage" as options without specifying priority
**Assumption Made:** Filesystem persistence is primary implementation; Ara/S3 are extension points documented for future
**Rationale:**
- Filesystem requires zero external dependencies
- Most reliable and portable across environments
- Ara integration (Sprint 8) had compatibility issues noted
- Meets all test case requirements without external services
**Risk:** Low - All test scenarios achievable with filesystem; other backends are additive enhancements

### Assumption 2: Collection Scope Limited to Async Task Management

**Issue:** "Collection with ansible tools" could imply broader scope beyond long-running tasks
**Assumption Made:** Initial collection focuses solely on async task management; other tools added in future Sprints
**Rationale:**
- Backlog explicitly calls out long-running task as focus
- Better to deliver one feature well than many features poorly
- Establishes collection structure for future additions
- Aligns with Sprint goal
**Risk:** Low - Product Owner can add more tools via new Backlog Items

### Assumption 3: Simple Job ID Format

**Issue:** Play identifier format not specified
**Assumption Made:** Use `<playbook_name>_<epoch_timestamp>_<uuid4>` format
**Rationale:**
- Playbook name provides human context
- Epoch timestamp provides chronological ordering
- UUID ensures global uniqueness
- No coordination required between playbooks
**Risk:** Low - Format is extensible and human-readable

### Assumption 4: No Distributed Lock Implementation

**Issue:** Concurrent playbook access to same persistence could cause conflicts
**Assumption Made:** Use append-only + unique identifiers instead of locking
**Rationale:**
- Locking adds significant complexity
- Append-only with unique IDs avoids most conflicts
- File-per-job approach eliminates concurrent write conflicts
- Acceptable trade-off for first implementation
**Risk:** Low-Medium - May need locking for future features (cleanup, aggregation)

### Assumption 5: Test Case 4 Uses Container Stop

**Issue:** "Managed host crashed" simulation method not specified
**Assumption Made:** Use `podman stop <container>` or `podman kill <container>` to simulate crash
**Rationale:**
- Clean, repeatable test scenario
- Matches real-world host failure from controller perspective
- Controllable and automatable
- Standard approach in container-based testing
**Risk:** Low - Simulates real crash effectively for testing purposes

## Compatibility Check

**Integration with existing code:** ✅ Confirmed
- New collection is independent, no conflicts with `rstyczynski.github`
- Can be used together in playbooks without interference
- Both collections follow same standards and patterns

**API consistency:** ✅ Confirmed
- Follows established input/output specification pattern
- Uses `meta/argument_specs.yml` like existing roles
- Variable prefixing conventions maintained
- FQCN usage throughout

**Test pattern alignment:** ✅ Confirmed
- Follows Molecule + Podman pattern from best practices
- Copy-paste-able test sequences as established in Sprint 10
- No `exit` commands in documentation examples
- Functional test documentation structure matches previous Sprints

**Documentation consistency:** ✅ Confirmed
- README.md for collection and roles
- User documentation with prerequisites and examples
- Copy-paste-able code samples
- Standard format from previous Sprints

## Next Steps

**Proceed to Elaboration Phase:**
1. Design collection directory structure
2. Design persistence layer architecture and state schema
3. Design role(s) interface with full argument specifications
4. Design test playbooks for all 4 test cases
5. Plan implementation tasks and order

**Estimated Phase Duration:**
- Elaboration (design): Moderate complexity, comprehensive design required
- Construction: Moderate-high complexity, implementation + 4 test scenarios
- Documentation: Standard complexity, collection + role docs

**Success Criteria for Elaboration:**
- Complete collection structure design
- Detailed persistence layer specification
- Full role interface specifications (argument_specs.yml format)
- Test scenario implementations designed
- All designs feasible against Ansible APIs

## LLM Token Usage Statistics

**Inception Phase Token Consumption:**
- Input tokens: ~66,000
- Output tokens: ~3,000
- Total: ~69,000 tokens
- Model: Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)
- Context: Read BACKLOG, PLAN, previous Sprint artifacts, existing collection structure, Ara implementation details

**Cumulative Token Usage (Phases 1-2):**
- Contracting: ~50,000 tokens
- Inception: ~69,000 tokens
- Total: ~119,000 tokens
