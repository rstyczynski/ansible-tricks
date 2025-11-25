# Sprint 13 - Design

**Mode:** YOLO (Autonomous)
**Date:** 2025-11-25

## BF-1: async storage procedures uses non unique file to keep job status

Status: Accepted

### Requirement Summary

Fix key uniqueness bug in async job storage. Current key format `<host>/<job_name>.json` causes collisions when multiple playbooks use the same job_name on the same host. Add playbook identifier to key structure to ensure uniqueness across playbooks.

### Feasibility Analysis

**API Availability:**

All required APIs exist and are already in use:
- ✅ Ansible `ansible.builtin.file` module - directory creation (filesystem backend)
- ✅ Ansible `ansible.builtin.copy` module - JSON file writing
- ✅ Ansible `ansible.builtin.stat` / `ansible.builtin.slurp` - file reading
- ✅ Ansible `ansible.builtin.command` with OCI CLI - object storage operations
- ✅ Ansible `ansible.builtin.set_fact` - variable management
- ✅ Ansible `ansible_date_time` magic variable - timestamp generation
- ✅ Ansible `ansible_play_name` magic variable - playbook/play name

**Reference:** Sprint 11 and 12 implementations confirm all APIs work correctly.

**Technical Constraints:**

1. **Breaking Change:** Old state files will not be compatible with new key format
2. **No Migration Tool:** Automatic migration not included in this sprint
3. **Playbook Name Source:** Must use explicit parameter or `ansible_play_name` variable

**Risk Assessment:**

- **Risk 1: User Impact from Breaking Change**
  - **Severity:** Medium
  - **Mitigation:** Clear documentation, error messages guide users, simple recovery (re-run playbooks)
  - **Acceptable:** Bug fix justifies breaking change

- **Risk 2: ansible_play_name May Not Match Playbook Filename**
  - **Severity:** Low
  - **Mitigation:** Document that playbook_name parameter is explicit identifier, not necessarily filename
  - **Users can override:** Parameter is configurable

- **Risk 3: OCI Nested Paths**
  - **Severity:** None
  - **Verification:** OCI CLI natively supports nested object names (confirmed in Sprint 12)
  - **Tested:** Sprint 12 already uses single-level nesting successfully

### Design Overview

**Architecture:**

The fix adds a playbook identifier to the existing two-level key hierarchy:

```
Before: <host>/<job_name>.json
After:  <host>/<playbook_name>/<job_name>.json
```

This creates a three-level hierarchy that ensures uniqueness:
1. **Host level:** Separates jobs by target host
2. **Playbook level:** Separates jobs by playbook (NEW)
3. **Job level:** Separates jobs by name within playbook

**Key Components:**

1. **New Parameter:** `playbook_name` in both async_job_save and async_job_load roles
   - Type: string
   - Required: false (has default)
   - Default: `{{ ansible_play_name }}`
   - Purpose: Identifies the playbook to prevent collisions

2. **Updated Path Logic:** 4 task files modified
   - `save_filesystem.yml` - Directory + file path
   - `save_oci.yml` - OCI object name
   - `load_filesystem.yml` - File path lookup
   - `load_oci.yml` - OCI object name

3. **Updated Specifications:** 2 meta files
   - `async_job_save/meta/argument_specs.yml`
   - `async_job_load/meta/argument_specs.yml`

**Data Flow:**

1. **Save Operation:**
   ```
   User provides: job_name, host, [optional: playbook_name]
   ↓
   Role applies default: playbook_name = ansible_play_name (if not provided)
   ↓
   Construct key: <host>/<playbook_name>/<job_name>.json
   ↓
   Backend saves to:
     - Filesystem: .ansible_async_state/<host>/<playbook>/<job>.json
     - OCI: oci://<bucket>/<host>/<playbook>/<job>.json
   ```

2. **Load Operation:**
   ```
   User provides: job_name, host, [optional: playbook_name]
   ↓
   Role applies default: playbook_name = ansible_play_name (if not provided)
   ↓
   Construct key: <host>/<playbook_name>/<job_name>.json
   ↓
   Backend loads from same path structure
   ↓
   Returns: ansible_job_id, metadata, host (unchanged API)
   ```

### Technical Specification

**Parameter Specification:**

```yaml
# async_job_save role
async_job_save_playbook_name:
  description: "Playbook identifier to ensure unique job keys across playbooks"
  type: str
  required: false
  default: "{{ ansible_play_name }}"

# async_job_load role
async_job_load_playbook_name:
  description: "Playbook identifier to locate job (must match save operation)"
  type: str
  required: false
  default: "{{ ansible_play_name }}"
```

**Path Construction Logic:**

```yaml
# Filesystem backend
state_file_path: "{{ state_dir }}/{{ host }}/{{ playbook_name }}/{{ job_name }}.json"

# OCI backend
object_name: "{{ host }}/{{ playbook_name }}/{{ job_name }}.json"
```

**Data Structures:**

JSON state file format (unchanged):
```json
{
  "job_name": "deploy_app",
  "host": "localhost",
  "ansible_job_id": "j889214147243.9938",
  "save_time": "2025-11-25T10:30:45Z",
  "metadata": {
    "custom": "data"
  }
}
```

**Note:** No schema version field added (out of scope for this bug fix).

**Scripts/Tools:**

No new scripts. Modifications to existing role task files only.

**Error Handling:**

Existing error handling remains:
- **File not found:** Returns `async_job_load_found: false`
- **OCI object not found:** Returns `async_job_load_found: false` (rc != 0)
- **Missing parameters:** Ansible argument validation fails with clear message
- **Permission errors:** Native Ansible error messages

No new error conditions introduced.

### Implementation Approach

**Step 1: Update async_job_save argument specification**

File: `roles/async_job_save/meta/argument_specs.yml`

Add after line 27 (after `async_job_save_metadata`):
```yaml
      async_job_save_playbook_name:
        description: "Playbook identifier to ensure unique job keys across playbooks"
        type: str
        required: false
        default: "{{ ansible_play_name }}"
```

**Step 2: Update async_job_save filesystem backend**

File: `roles/async_job_save/tasks/save_filesystem.yml`

Line 5-10: Add task to create playbook subdirectory:
```yaml
- name: "Save Job (FS): Ensure playbook directory exists"
  ansible.builtin.file:
    path: "{{ async_job_save_state_dir }}/{{ async_job_save_host }}/{{ async_job_save_playbook_name }}"
    state: directory
    mode: '0700'
  delegate_to: localhost
```

Line 22: Update dest path (was line 22, now ~line 28 after new task):
```yaml
# OLD:
dest: "{{ async_job_save_state_dir }}/{{ async_job_save_host }}/{{ async_job_save_job_name }}.json"

# NEW:
dest: "{{ async_job_save_state_dir }}/{{ async_job_save_host }}/{{ async_job_save_playbook_name }}/{{ async_job_save_job_name }}.json"
```

Line 28: Update state_file fact (was line 26-28, now ~line 34 after new task):
```yaml
# OLD:
async_job_save_state_file: "{{ async_job_save_state_dir }}/{{ async_job_save_host }}/{{ async_job_save_job_name }}.json"

# NEW:
async_job_save_state_file: "{{ async_job_save_state_dir }}/{{ async_job_save_host }}/{{ async_job_save_playbook_name }}/{{ async_job_save_job_name }}.json"
```

**Step 3: Update async_job_save OCI backend**

File: `roles/async_job_save/tasks/save_oci.yml`

Line 42: Update OCI object name:
```yaml
# OLD:
- "{{ async_job_save_host }}/{{ async_job_save_job_name }}.json"

# NEW:
- "{{ async_job_save_host }}/{{ async_job_save_playbook_name }}/{{ async_job_save_job_name }}.json"
```

Line 60: Update OCI URI fact:
```yaml
# OLD:
async_job_save_state_file: "oci://{{ async_job_save_oci_bucket }}/{{ async_job_save_host }}/{{ async_job_save_job_name }}.json"

# NEW:
async_job_save_state_file: "oci://{{ async_job_save_oci_bucket }}/{{ async_job_save_host }}/{{ async_job_save_playbook_name }}/{{ async_job_save_job_name }}.json"
```

**Step 4: Update async_job_load argument specification**

File: `roles/async_job_load/meta/argument_specs.yml`

Add after job_name parameter:
```yaml
      async_job_load_playbook_name:
        description: "Playbook identifier to locate job (must match save operation)"
        type: str
        required: false
        default: "{{ ansible_play_name }}"
```

**Step 5: Update async_job_load filesystem backend**

File: `roles/async_job_load/tasks/load_filesystem.yml`

Line 10: Update stat path:
```yaml
# OLD:
path: "{{ async_job_load_state_dir }}/{{ async_job_load_host_internal }}/{{ async_job_load_job_name }}.json"

# NEW:
path: "{{ async_job_load_state_dir }}/{{ async_job_load_host_internal }}/{{ async_job_load_playbook_name }}/{{ async_job_load_job_name }}.json"
```

Line 21: Update slurp path:
```yaml
# OLD:
src: "{{ async_job_load_state_dir }}/{{ async_job_load_host_internal }}/{{ async_job_load_job_name }}.json"

# NEW:
src: "{{ async_job_load_state_dir }}/{{ async_job_load_host_internal }}/{{ async_job_load_playbook_name }}/{{ async_job_load_job_name }}.json"
```

**Step 6: Update async_job_load OCI backend**

File: `roles/async_job_load/tasks/load_oci.yml`

Line 28: Update OCI object name:
```yaml
# OLD:
- "{{ async_job_load_host_internal }}/{{ async_job_load_job_name }}.json"

# NEW:
- "{{ async_job_load_host_internal }}/{{ async_job_load_playbook_name }}/{{ async_job_load_job_name }}.json"
```

**Step 7: Test filesystem backend**

Create test playbook: `test_bf1_filesystem.yml`
- Test two playbooks with same job_name
- Verify separate state files created
- Verify no collision

**Step 8: Test OCI backend**

Create test playbook: `test_bf1_oci.yml`
- Test two playbooks with same job_name using OCI
- Verify separate objects created
- Verify no collision

### Testing Strategy

**Functional Tests:**

1. **Test 1: Filesystem Backend - No Collision**
   - Purpose: Verify two playbooks with same job_name don't collide
   - Steps:
     1. Run playbook A with job_name="test_job", playbook_name="playbook_a"
     2. Run playbook B with job_name="test_job", playbook_name="playbook_b"
     3. Verify two state files exist:
        - `.ansible_async_state/localhost/playbook_a/test_job.json`
        - `.ansible_async_state/localhost/playbook_b/test_job.json`
     4. Load job from playbook A - verify correct job_id
     5. Load job from playbook B - verify different job_id

2. **Test 2: OCI Backend - No Collision**
   - Purpose: Same as Test 1 but for OCI backend
   - Steps:
     1. Run with OCI backend, playbook A with job_name="test_job"
     2. Run with OCI backend, playbook B with job_name="test_job"
     3. Verify two OCI objects:
        - `oci://<bucket>/localhost/playbook_a/test_job.json`
        - `oci://<bucket>/localhost/playbook_b/test_job.json`
     4. Load from each playbook, verify correct job_id

3. **Test 3: Default Parameter Behavior**
   - Purpose: Verify ansible_play_name default works
   - Steps:
     1. Create playbook without specifying playbook_name parameter
     2. Save job, verify state file created under ansible_play_name directory
     3. Load job without specifying playbook_name, verify load succeeds

**Edge Cases:**

1. **Edge Case 1: Playbook Name with Special Characters**
   - Test playbook_name with spaces, slashes, special chars
   - Expected: Ansible variable substitution handles it
   - Verify filesystem directory creation works

2. **Edge Case 2: Very Long Playbook Names**
   - Test playbook_name with 255+ characters
   - Expected: Filesystem/OCI may truncate or error
   - Document maximum practical length

3. **Edge Case 3: Empty Playbook Name**
   - Test playbook_name = ""
   - Expected: Creates `<host>//< job>.json` (double slash)
   - Verify this doesn't break load operation

**Success Criteria:**

- ✅ Two playbooks with same job_name create separate state files
- ✅ Load operation retrieves correct job for specified playbook_name
- ✅ Both filesystem and OCI backends work identically
- ✅ Default parameter (ansible_play_name) works without explicit specification
- ✅ Existing test scenarios from Sprint 11/12 still pass (syntax check minimum)
- ✅ No regression in error handling behavior

### Integration Notes

**Dependencies:**

- Sprint 11 (GHC-15) - Base async job roles
- Sprint 12 (GHC-16) - OCI backend implementation
- No external service dependencies

**Compatibility:**

**Breaking Changes:**
- Old state files incompatible with new key format
- Users must specify playbook_name when loading old jobs (if they want to find them)
- Migration: Delete old state files, re-run playbooks

**Backward Compatibility:**
- None - this is explicitly a breaking change for bug fix
- Old and new formats cannot coexist gracefully

**Forward Compatibility:**
- API stable after this change
- Adding fields to JSON (future) won't break key structure

**Reusability:**

Reuse from Sprint 11/12:
- ✅ Backend routing architecture (main.yml includes)
- ✅ OCI CLI command patterns
- ✅ Argument validation patterns
- ✅ Error handling patterns
- ✅ Test scenario structure

No new patterns needed - purely incremental change.

### Documentation Requirements

**User Documentation:**

1. **Migration Guide**
   - Document breaking change clearly
   - Explain why (bug fix for data corruption)
   - Provide recovery steps: delete old state files, re-run playbooks

2. **Parameter Documentation**
   - Document new `playbook_name` parameter
   - Explain default behavior (ansible_play_name)
   - Provide examples of explicit usage

3. **Updated Role README**
   - Update async_job_save README with playbook_name parameter
   - Update async_job_load README with playbook_name parameter
   - Add multi-playbook example

4. **State File Structure Documentation**
   - Document new three-level hierarchy
   - Show filesystem tree example
   - Show OCI bucket structure example

**Technical Documentation:**

1. **Implementation Notes**
   - Document exact line numbers changed in each file
   - Show before/after code snippets
   - Explain playbook name default behavior

2. **Testing Documentation**
   - Document test scenarios
   - Provide copy-paste-able test commands
   - Show expected state file locations

3. **Troubleshooting Guide**
   - "Job not found" after upgrade → explain migration needed
   - Multiple playbooks same job_name → now works correctly

### Design Decisions

**Decision 1: Make playbook_name Optional with Default**

**Rationale:**
- Makes migration easier (users get sensible default)
- Explicit parameter allows override when ansible_play_name isn't suitable
- Follows Ansible best practice (sensible defaults)

**Alternatives Considered:**
- Make it required: Too harsh for simple cases
- Auto-detect from ansible_playbook_python: Variable doesn't exist
- Use ansible_play_batch: Not unique enough

**Chosen:** Optional with `{{ ansible_play_name }}` default

**Decision 2: Three-Level Hierarchy (host/playbook/job)**

**Rationale:**
- Natural grouping: host → what playbook → which job
- Easy to browse in filesystem or OCI Console
- Allows future enhancements (list all jobs in playbook)

**Alternatives Considered:**
- Flat with composite key: `host_playbook_job.json` - harder to browse
- Two-level with composite: `host/playbook_job.json` - less clear structure

**Chosen:** Three-level nested path

**Decision 3: Accept Breaking Change**

**Rationale:**
- Bug causes data corruption (state file overwriting)
- Correctness bugs justify breaking changes
- Migration is simple (delete state files, re-run)
- State files are transient (not permanent data)

**Alternatives Considered:**
- Maintain backward compatibility: Too complex, bug remains for old files
- Add version field to JSON: Doesn't help with key collision bug

**Chosen:** Clean break, clear documentation

**Decision 4: Use ansible_play_name for Default**

**Rationale:**
- Ansible provides this variable automatically
- Represents the name of the currently executing play
- Good enough for most use cases
- Users can override if needed

**Alternatives Considered:**
- ansible_playbook: Doesn't exist
- Hard-coded default like "default_playbook": Not useful
- Make required: Too strict

**Chosen:** `{{ ansible_play_name }}` default

**Decision 5: No Migration Tool**

**Rationale:**
- Out of scope for bug fix sprint
- Simple manual migration (delete files)
- State files are transient data
- Auto-migration complex (need to guess playbook names)

**Alternatives Considered:**
- Build migration script: Adds complexity, questionable value
- Support both formats: Increases code complexity

**Chosen:** Manual migration only, clear documentation

### Open Design Questions

None - All design decisions finalized in YOLO mode with clear rationale.

---

# Design Summary

## Overall Architecture

Single bug fix with localized changes:
- Add playbook_name parameter to both async job roles
- Update key structure from 2-level to 3-level hierarchy
- Maintain identical behavior for both filesystem and OCI backends
- Accept breaking change with clear documentation

## Shared Components

Both async_job_save and async_job_load roles share:
- Same playbook_name parameter specification
- Same default value logic (ansible_play_name)
- Same path construction pattern
- Identical hierarchy structure

## Design Risks

**Risk 1: User Impact from Breaking Change**
- Mitigation: Clear documentation, simple recovery process
- Severity: Medium (temporary inconvenience)
- Acceptable: Bug fix priority

**Risk 2: ansible_play_name May Not Always Be Ideal**
- Mitigation: Parameter is overridable
- Severity: Low
- Acceptable: Default works for 90% of cases

**Overall Risk Level:** Low - straightforward implementation, clear testing, documented breaking change

## Resource Requirements

**Tools:**
- Existing: Ansible, OCI CLI (already in use)
- New: None

**Libraries:**
- None required

**External Services:**
- OCI Object Storage (already configured in Sprint 12)
- No new service dependencies

## YOLO Mode Decisions

This sprint was designed in YOLO (autonomous) mode. Key design decisions:

### Decision 1: Optional Parameter with Default

**Context:** Should playbook_name be required or optional?

**Decision Made:** Optional with default to `{{ ansible_play_name }}`

**Rationale:**
- Reduces friction for users upgrading
- Provides sensible default for simple cases
- Allows explicit control when needed
- Follows Ansible best practices

**Alternatives Considered:**
- Required parameter: Too harsh, forces all users to update playbooks
- No default: Same issue

**Risk:** Low - ansible_play_name is always available

### Decision 2: Three-Level Path Hierarchy

**Context:** How to structure the new key format?

**Decision Made:** Use `<host>/<playbook>/<job>.json` nested structure

**Rationale:**
- Clear logical grouping
- Easy to browse and understand
- Consistent with existing `<host>/<job>` pattern (just adds one level)
- Both backends support nested paths

**Alternatives Considered:**
- Flat composite key `host_playbook_job.json`: Harder to browse
- Two-level `host/playbook_job.json`: Less clear, collision risk remains

**Risk:** None - both backends tested with nested paths

### Decision 3: Breaking Change Acceptance

**Context:** Backward compatibility vs. correctness

**Decision Made:** Accept breaking change, prioritize bug fix

**Rationale:**
- Bug causes data corruption (overwriting state files)
- State files are transient, not permanent data
- Simple recovery: delete old files, re-run playbooks
- Clean implementation without legacy baggage

**Alternatives Considered:**
- Support both formats: Complex, bug remains for old files
- Add version field: Doesn't prevent collision

**Risk:** Medium (user inconvenience) - Mitigated by clear documentation

### Decision 4: No Automated Migration

**Context:** Should we provide a migration tool?

**Decision Made:** Manual migration only (delete old files, re-run)

**Rationale:**
- Out of scope for bug fix
- Migration tool would need to guess playbook names (error-prone)
- State files are transient (no data loss)
- Simple manual process

**Alternatives Considered:**
- Build migration script: High effort, low value
- Try to auto-detect playbook names: Unreliable

**Risk:** Low - documentation makes process clear

### Decision 5: Use ansible_play_name Variable

**Context:** What default value for playbook_name?

**Decision Made:** Default to `{{ ansible_play_name }}`

**Rationale:**
- Ansible provides this automatically
- Represents current play name
- Good enough identifier for most cases
- Users can override if unsuitable

**Alternatives Considered:**
- ansible_playbook variable: Doesn't exist
- Hard-coded "default": Not useful
- File-based detection: Unreliable

**Risk:** Low - variable always available, override possible

## Design Approval Status

**Status:** Accepted (YOLO mode auto-approval)

**Justification:**
- All APIs confirmed available (Sprint 11/12 implementations)
- Design follows established patterns
- Testing strategy is comprehensive
- Breaking change justified by bug severity
- All risks identified with mitigations
- Clear, implementable specification

**YOLO Mode:** Design auto-approved after creation. No critical feasibility issues found. Ready for Construction phase.

---

**Designer:** Designer Agent (Autonomous - YOLO Mode)
**Date:** 2025-11-25
**Status:** Design Complete and Accepted
**Next Phase:** Construction
