# Sprint 13 - Analysis

**Status:** Complete
**Date:** 2025-11-25
**Mode:** YOLO (Autonomous)

## Sprint Overview

Sprint 13 addresses bug BF-1: async storage procedures use non-unique keys for job status storage. The current implementation uses `host:job_name` format which causes collisions when different playbooks use the same job_name on the same host.

## Backlog Items Analysis

### BF-1: async storage procedures uses non unique file to keep job status

**Requirement Summary:**

Fix the key uniqueness issue in async job storage. Currently the key format `<host>/<job_name>.json` is insufficient because:
- Multiple playbooks can use the same job_name
- Running playbook A with job_name="deploy" and playbook B with job_name="deploy" on the same host causes state file collision
- State files overwrite each other, breaking job tracking

**Solution Required:**
Add playbook name/identifier to the key structure to ensure uniqueness across different playbooks.

**Technical Approach:**

1. **Add playbook_name parameter** to both async_job_save and async_job_load roles
2. **Update key format** from `<host>/<job_name>.json` to `<host>/<playbook_name>/<job_name>.json`
3. **Modify 4 task files**:
   - `async_job_save/tasks/save_filesystem.yml`
   - `async_job_save/tasks/save_oci.yml`
   - `async_job_load/tasks/load_filesystem.yml`
   - `async_job_load/tasks/load_oci.yml`
4. **Update argument specifications** in `meta/argument_specs.yml` for both roles
5. **Update defaults** if needed
6. **Test both backends** (filesystem and OCI)

**Dependencies:**

- Built on Sprint 11 (GHC-15) and Sprint 12 (GHC-16) implementations
- No external dependencies
- Requires updating both roles in sync to maintain compatibility

**Testing Strategy:**

1. **Unit tests**: Verify key format changes in both backends
2. **Integration tests**:
   - Run two different playbooks with same job_name
   - Verify each playbook has its own state file
   - Verify no collision/overwriting
3. **Backward compatibility test**: Document breaking change if no backward compat possible
4. **OCI backend test**: Verify OCI object naming works with nested structure

**Risks/Concerns:**

**Risk 1: Backward Compatibility**
- **Issue**: Existing state files use old key format
- **Impact**: Existing jobs won't be found after upgrade
- **YOLO Decision**: Accept breaking change, document clearly
- **Rationale**: Bug fix is more important than backward compat; users can re-run playbooks
- **Mitigation**: Clear documentation in README and migration notes

**Risk 2: Playbook Name Detection**
- **Issue**: How to automatically detect playbook name?
- **YOLO Decision**: Make it a required parameter (explicit is better than implicit)
- **Rationale**:
  - Ansible doesn't provide reliable built-in variable for playbook name
  - `ansible_playbook_python` exists but not the playbook file name
  - Requiring explicit parameter ensures clarity and correctness
- **Alternative**: Could use `ansible_play_name` but that's the play name, not playbook name
- **Final Approach**: Optional parameter with sensible default using `ansible_play_name`

**Risk 3: OCI Object Naming**
- **Issue**: OCI object names with multiple slashes
- **YOLO Decision**: Use nested path format `<host>/<playbook>/<job>.json`
- **Rationale**: OCI supports nested paths, mirrors filesystem structure
- **Risk Level**: Low - OCI CLI handles nested paths natively

**Compatibility Notes:**

- **Breaking change**: Existing state files will need new key format
- **Migration path**: Users can delete old state files and re-run playbooks
- **No code dependencies**: Only internal role changes
- **API change**: New required/optional parameter added

## Overall Sprint Assessment

**Feasibility:** High

This is a straightforward bug fix with clear implementation path:
- Problem is well-defined and reproducible
- Solution is clear (add playbook identifier to key)
- Code changes are localized to 4 task files + 2 meta files
- Testing is straightforward

**Estimated Complexity:** Simple

- **Code changes**: 6 files total (4 task files, 2 argument_specs.yml)
- **Lines changed**: ~20 lines across all files
- **New functionality**: None - just parameter addition and path modification
- **Testing**: Standard role testing patterns established in Sprint 11/12

**Prerequisites Met:** Yes

- Sprint 11 and 12 implementations are complete and tested
- Code structure is clean and well-documented
- Backend routing architecture is in place
- Testing patterns established

**Open Questions:**

None in YOLO mode - reasonable assumptions documented above.

## YOLO Mode Decisions

This sprint was analyzed in YOLO (autonomous) mode. The following assumptions were made:

### Assumption 1: Breaking Change Acceptable

**Issue**: Backward compatibility with existing state files
**Assumption Made**: Breaking change is acceptable for bug fix
**Rationale**:
- Bug causes data corruption (state file overwriting)
- Security/correctness bugs justify breaking changes
- Users can easily recover by re-running playbooks
- State files are transient by nature (not permanent data)

**Risk**: Low - Users will see clear error messages and documentation

### Assumption 2: Playbook Name as Optional Parameter

**Issue**: How to identify playbook uniquely
**Assumption Made**: Add optional `playbook_name` parameter with default to `ansible_play_name`
**Rationale**:
- Ansible doesn't provide reliable automatic playbook name detection
- Explicit parameter gives users full control
- Default to `ansible_play_name` provides reasonable fallback
- Users running multiple playbooks can specify unique names

**Risk**: Low - Standard Ansible pattern for role parameters

### Assumption 3: Key Format - Nested Path

**Issue**: How to structure the new key format
**Assumption Made**: Use `<host>/<playbook_name>/<job_name>.json`
**Rationale**:
- Clear hierarchy: host → playbook → job
- Mirrors filesystem directory structure
- Easy to browse in OCI Console
- Allows future grouping by playbook

**Risk**: None - Both backends support nested paths

### Assumption 4: Parameter Name

**Issue**: What to call the new parameter
**Assumption Made**: Name it `async_job_save_playbook_name` and `async_job_load_playbook_name`
**Rationale**:
- Follows existing naming convention (role prefix)
- Clear and descriptive
- Matches pattern: `async_job_save_job_name`, `async_job_save_host`, etc.

**Risk**: None - Consistent with existing conventions

## Recommended Design Focus Areas

1. **Parameter Design**: Decide on required vs optional with default
2. **Key Format**: Finalize `<host>/<playbook>/<job>.json` structure
3. **Error Messages**: Update error messages to mention playbook_name in paths
4. **Documentation**: Clear migration guide for users with existing state files
5. **Test Coverage**: Ensure tests cover multi-playbook scenarios

## Readiness for Design Phase

**Status**: Confirmed Ready

All requirements are clear:
- Problem well understood
- Solution approach defined
- Risks identified with mitigation strategies
- Testing strategy established
- YOLO decisions documented

**No blockers** - Ready to proceed to Elaboration (Design) phase.

## Code Review Notes

**Files to be modified:**

1. `roles/async_job_save/tasks/save_filesystem.yml` - Line 22: Update dest path
2. `roles/async_job_save/tasks/save_oci.yml` - Line 42: Update OCI object name
3. `roles/async_job_load/tasks/load_filesystem.yml` - Line 10, 21: Update path references
4. `roles/async_job_load/tasks/load_oci.yml` - Line 28: Update OCI object name
5. `roles/async_job_save/meta/argument_specs.yml` - Add playbook_name parameter
6. `roles/async_job_load/meta/argument_specs.yml` - Add playbook_name parameter

**Current key locations identified:**
- save_filesystem.yml:22 - `{{ async_job_save_host }}/{{ async_job_save_job_name }}.json`
- save_oci.yml:42 - `{{ async_job_save_host }}/{{ async_job_save_job_name }}.json`
- load_filesystem.yml:10,21 - `{{ async_job_load_host_internal }}/{{ async_job_load_job_name }}.json`
- load_oci.yml:28 - `{{ async_job_load_host_internal }}/{{ async_job_load_job_name }}.json`

All locations use consistent format - easy to update uniformly.

## Analysis Summary

Bug BF-1 is a clear correctness issue requiring a straightforward fix. The solution adds a playbook identifier to the key structure, ensuring uniqueness across different playbooks. Implementation is simple (6 files, ~20 lines changed), testing is straightforward, and the design is ready for approval.

**Confidence Level**: High - This is a well-understood bug with a clear fix.
