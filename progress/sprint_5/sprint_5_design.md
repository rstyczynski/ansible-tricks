# Sprint 5 - Design

Status: Accepted

---

## GHC-7: Roles uses argument specification at meta

Status: Accepted

### Requirement Summary

Make sure that all roles use argument specification at meta directory. Do not keep argument specification for rules inline.

**Goal**: Remove redundant inline `validate_argument_spec` tasks from all roles, relying exclusively on `meta/argument_specs.yml` for argument validation.

### Feasibility Analysis

**API Availability:**

✅ Ansible `meta/argument_specs.yml` - Supported in Ansible 2.11+
- Documentation: https://docs.ansible.com/ansible/latest/dev_guide/developing_roles.html#role-argument-validation
- Purpose: Defines role interface for automatic validation and ansible-doc
- **Automatic Validation**: When a role has `meta/argument_specs.yml`, Ansible automatically validates arguments when the role is invoked via `include_role`
- **Documentation**: Automatically read by `ansible-doc` command

✅ Ansible `validate_argument_spec` module - Available in Ansible Core 2.11+
- Documentation: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/validate_argument_spec_module.html
- **Current Usage**: Used inline in 15 roles' `tasks/main.yml` files
- **Redundancy**: When `meta/argument_specs.yml` exists, inline validation is redundant

**Technical Constraints:**

1. **Ansible Version**: Requires Ansible Core 2.11+ (already satisfied)
2. **Automatic Validation**: Ansible validates from `meta/argument_specs.yml` automatically when role is invoked
3. **No Breaking Changes**: Removing inline validation does not affect functionality
4. **Documentation**: `ansible-doc` reads from `meta/argument_specs.yml` automatically

**Risk Assessment:**

- **Very Low Risk**: Removing inline validation when meta specs exist
  - **Mitigation**: Ansible automatically validates from meta specs
  - **Testing**: Verify roles reject invalid arguments correctly
  - **Verification**: Test with intentionally invalid arguments

- **Very Low Risk**: Breaking existing playbooks
  - **Mitigation**: No API changes, only internal validation mechanism changes
  - **Testing**: Run flow.yml end-to-end to verify compatibility
  - **Verification**: All existing playbooks should work without modification

- **Very Low Risk**: Documentation breaking
  - **Mitigation**: `ansible-doc` reads from meta specs, not inline tasks
  - **Testing**: Run `ansible-doc` on all roles before and after changes
  - **Verification**: Documentation should remain identical

### Design Overview

**Architecture:**

Single validation approach using only meta specification:

1. **Meta Specification** (`meta/argument_specs.yml`):
   - Defines complete role interface
   - Automatically validates arguments when role is invoked
   - Feeds ansible-doc for documentation
   - Serves as single source of truth

2. **Removed Inline Validation** (`tasks/main.yml`):
   - Remove `validate_argument_spec` tasks from all roles
   - First task in each role becomes the actual functional task
   - Cleaner, more maintainable code

**Key Components:**

1. **Role Task Files**: Remove inline validation tasks from 15 roles
2. **Meta Specification Files**: Keep existing `meta/argument_specs.yml` files (already correct)
3. **Testing**: Verify automatic validation works correctly

**Data Flow:**

```
Role Invocation (include_role)
    ↓
Ansible automatically reads meta/argument_specs.yml
    ↓
[Automatic validation passes/fails]
    ↓
Role execution continues OR error raised
    ↓
Output attributes set via register/set_fact
    ↓
Documented in meta/argument_specs.yml with [OUTPUT] prefix
```

### Technical Specification

**Roles to Modify:**

15 roles need inline validation tasks removed:

1. branch_checkout - Remove lines 22-40 (validate_argument_spec task)
2. branch_delete - Remove validate_argument_spec task (around line 23)
3. branch_pull - Remove validate_argument_spec task (around line 16)
4. branch_push - Remove validate_argument_spec task (around line 12)
5. branch_switch - Remove validate_argument_spec task (around line 14)
6. github_auth - Remove validate_argument_spec task (around line 17)
7. github_logout - Remove validate_argument_spec task (around line 13)
8. pr_comment - Remove validate_argument_spec task (around line 16)
9. pr_create - Remove lines 21-47 (validate_argument_spec task)
10. pr_merge - Remove validate_argument_spec task (around line 21)
11. pr_status_check - Remove validate_argument_spec task (around line 22)
12. pr_status_check_pause - Remove validate_argument_spec task (around line 14)
13. repo_clone - Remove validate_argument_spec task (around line 18)
14. repo_commit - Remove validate_argument_spec task (around line 16)
15. repo_file_add - Remove validate_argument_spec task (around line 18)

**Role Already Correct:**

1. github_precheck - No inline validation (already correct)

**Modification Pattern:**

For each role, locate the `validate_argument_spec` task and remove it entirely:

```yaml
# REMOVE THIS ENTIRE TASK:
- name: "[Role Name]: Validate arguments"
  ansible.builtin.validate_argument_spec:
    argument_spec:
      param1:
        type: str
        required: true
        description: "..."
      # ... more parameters
```

**Preserve:**
- INPUT/OUTPUT variable tables (comments at top of file)
- All other tasks
- File structure and formatting

### Implementation Approach

**Step 1:** Review each role's `tasks/main.yml` to identify exact validation task location

**Step 2:** For each of the 15 roles:
   - Remove the entire `validate_argument_spec` task
   - Ensure first task after removal is properly formatted
   - Preserve all comments and variable tables

**Step 3:** Verify `meta/argument_specs.yml` exists for all 16 roles (already confirmed)

**Step 4:** Test automatic validation:
   - Invoke each role with invalid arguments
   - Verify Ansible rejects invalid arguments automatically
   - Confirm error messages are clear

**Step 5:** Test documentation:
   - Run `ansible-doc rstyczynski.github.{role_name}` for all roles
   - Verify documentation is complete and accurate
   - Compare before/after to ensure no regression

**Step 6:** Test end-to-end workflow:
   - Run `ansible-playbook --syntax-check` on flow.yml
   - Execute flow.yml end-to-end
   - Verify all roles work correctly
   - Test idempotency (run twice)

### Testing Strategy

**Functional Tests:**

1. **Argument Validation Test**:
   - Invoke each role with missing required arguments
   - Verify Ansible automatically rejects with clear error message
   - Test with invalid argument types
   - Confirm validation works without inline task

2. **Documentation Test**:
   - Run `ansible-doc` on all 16 roles
   - Verify all parameters documented
   - Verify OUTPUT attributes documented with [OUTPUT] prefix
   - Compare output with previous version (should be identical)

3. **End-to-End Test**:
   - Execute `flow.yml` playbook
   - Verify all roles execute successfully
   - Test idempotency (run flow.yml twice)
   - Verify no errors or warnings

4. **Syntax Validation**:
   - Run `ansible-playbook --syntax-check` on flow.yml
   - Verify no syntax errors
   - Verify all role references valid

**Edge Cases:**

1. **Role with no inputs** (github_precheck):
   - Verify role still works correctly
   - Verify ansible-doc still generates documentation

2. **Role with many parameters** (pr_create):
   - Verify all parameters validated correctly
   - Verify documentation complete

3. **Role with optional parameters**:
   - Verify optional parameters work correctly
   - Verify default values applied when not provided

**Success Criteria:**

- [x] All 15 roles have inline validation tasks removed
- [x] All 16 roles validate arguments automatically from meta specs
- [x] `ansible-doc` works correctly for all roles
- [x] `flow.yml` executes successfully end-to-end
- [x] All roles maintain idempotency
- [x] No regression in functionality

### Integration Notes

**Dependencies:**

- No dependencies on other Backlog Items
- All `meta/argument_specs.yml` files already exist (from Sprint 3)
- No external dependencies required

**Compatibility:**

- **Backward Compatible**: Existing playbooks work without modification
- **API Unchanged**: Variable names, structure, and behavior unchanged
- **Documentation Unchanged**: ansible-doc output should be identical

**Reusability:**

- Pattern can be applied to future roles
- Establishes best practice for collection development
- Reduces code duplication

### Documentation Requirements

**User Documentation:**

- No user-facing changes required
- Roles work identically from user perspective
- No changes to role invocation or parameters

**Technical Documentation:**

- Implementation notes document the changes
- Test documentation verifies functionality
- Design document explains rationale

### Design Decisions

**Decision 1:** Remove inline validation entirely (not keep both)
**Rationale:** 
- Ansible automatically validates from meta specs
- Reduces code duplication
- Single source of truth (meta/argument_specs.yml)
- Cleaner, more maintainable code

**Alternatives Considered:**
- Keep both inline and meta validation (rejected - redundant)
- Keep inline, remove meta (rejected - breaks ansible-doc)

**Decision 2:** Preserve INPUT/OUTPUT comment tables
**Rationale:**
- Provides human-readable documentation in code
- Helps developers understand role interface
- Does not interfere with automatic validation

**Decision 3:** Test with invalid arguments to verify automatic validation
**Rationale:**
- Ensures validation still works after removing inline task
- Verifies Ansible's automatic validation is functioning
- Provides confidence in changes

### Open Design Questions

None - Design is complete and ready for implementation.

---

## Design Summary

### Overall Architecture

All 16 roles will use only `meta/argument_specs.yml` for argument specification. Ansible automatically validates arguments when roles are invoked, eliminating the need for inline validation tasks.

### Shared Components

- `meta/argument_specs.yml` - Single source of truth for all roles
- Automatic validation - Built into Ansible when meta specs exist
- `ansible-doc` - Automatically generates documentation from meta specs

### Design Risks

**Overall Risk:** Very Low

- Well-understood Ansible behavior
- No complex logic changes
- Simple deletion operation
- Comprehensive testing approach

**Mitigation Strategies:**

- Test automatic validation with invalid arguments
- Test end-to-end workflow
- Verify documentation generation
- Test idempotency

### Resource Requirements

- **Tools**: Ansible, ansible-doc, git
- **Libraries**: None (using Ansible built-in features)
- **External Services**: None
- **Time**: Estimated 2-3 hours for implementation and testing

### Design Approval Status

**Status:** Proposed

Ready for Product Owner review and approval.

