# Sprint 3 - Design

Status: Proposed

---

## GHC-4: GitHub Collection roles support input / output specification

Status: Proposed

### Requirement Summary

Implement `meta/argument_specs.yml` for all 16 roles in the `rstyczynski.github` Collection following the pattern defined in `rules/specific/ansible/input_output_spec.md`. Each role must validate arguments using `validate_argument_spec` module and document all input parameters and output attributes.

### Feasibility Analysis

**API Availability:**

✅ Ansible `validate_argument_spec` module - Available in Ansible Core 2.11+
- Documentation: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/validate_argument_spec_module.html
- Purpose: Validates role/module arguments against a specification
- Used inline in tasks/main.yml (9 roles already use this)

✅ Ansible `meta/argument_specs.yml` - Supported in Ansible 2.11+
- Documentation: https://docs.ansible.com/ansible/latest/dev_guide/developing_roles.html#role-argument-validation
- Purpose: Defines role interface for ansible-doc and validation
- Integration: Automatically read by ansible-doc command

**Technical Constraints:**

1. **Ansible Version**: Requires Ansible Core 2.11+ (already satisfied)
2. **Type System**: Limited to Ansible types (str, int, bool, list, dict, path, raw)
3. **Validation Timing**: validate_argument_spec runs during task execution, not role inclusion
4. **Documentation Format**: Must follow specific YAML structure for ansible-doc compatibility

**Risk Assessment:**

- **Low Risk**: Type mismatches between inline validation and meta specs
  - **Mitigation**: Extract exact specifications from existing inline validation
  - **Testing**: Verify both inline and meta specs accept same inputs

- **Low Risk**: Missing output attributes not documented in INPUT/OUTPUT tables
  - **Mitigation**: Scan all `register:` and `set_fact:` statements in each role
  - **Verification**: Cross-reference with comment tables

- **Low Risk**: Breaking changes if validation becomes stricter
  - **Mitigation**: Keep inline validation identical to current implementation
  - **Testing**: Run flow.yml end-to-end test to verify compatibility

### Design Overview

**Architecture:**

Dual validation approach combining meta specification with inline validation:

1. **Meta Specification** (`meta/argument_specs.yml`):
   - Defines complete role interface
   - Feeds ansible-doc for documentation
   - Serves as canonical reference

2. **Inline Validation** (`tasks/main.yml` first task):
   - Validates arguments at runtime
   - Provides immediate feedback
   - Identical spec to meta file

**Key Components:**

1. **Argument Specification Template**: Reusable structure for meta/argument_specs.yml
2. **Role Specifications**: Individual specs for all 16 roles
3. **Validation Tasks**: First task in each role's tasks/main.yml
4. **Documentation Integration**: ansible-doc command integration

**Data Flow:**

```
Role Invocation
    ↓
tasks/main.yml (validate_argument_spec)
    ↓
[Validation passes/fails]
    ↓
Role execution continues OR error raised
    ↓
Output attributes set via register/set_fact
    ↓
Documented in meta/argument_specs.yml with [OUTPUT] prefix
```

### Technical Specification

**Argument Specs Template:**

```yaml
# meta/argument_specs.yml
---
argument_specs:
  main:
    short_description: <Brief role description (1-2 sentences)>
    description:
      - <Detailed description paragraph 1>
      - <Additional details if needed>

    options:
      # INPUT PARAMETERS (no prefix in description)
      role_name_input_param:
        description: <Parameter description>
        type: <str|int|bool|dict|list|path>
        required: <true|false>
        default: <value>  # Optional, only if parameter has default

      # OUTPUT ATTRIBUTES (prefix with [OUTPUT])
      role_name_output_attr:
        description: "[OUTPUT] <Attribute description>"
        type: dict  # Usually dict for register results, str for set_fact
        required: false  # Outputs are never required inputs
```

**Type Mapping Rules:**

| Source | Ansible Type | Notes |
|--------|--------------|-------|
| Command/shell register | dict | Contains stdout, stderr, rc, etc. |
| set_fact (string) | str | Simple string value |
| set_fact (boolean) | bool | True/false flag |
| set_fact (dict) | dict | Complex structure |
| File paths | path | Validates path existence |
| Flags/switches | bool | true/false values |

**Role-by-Role Specifications:**

### 1. github_precheck

**Current State**: No validation, only OUTPUT variables

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Verifies git and GitHub CLI prerequisites
    options:
      github_precheck_git_version:
        description: "[OUTPUT] Git version information"
        type: dict
        required: false
      github_precheck_gh_version:
        description: "[OUTPUT] GitHub CLI version information"
        type: dict
        required: false
      github_precheck_gh_auth_status:
        description: "[OUTPUT] GitHub CLI authentication status"
        type: dict
        required: false
```

**Validation Task**: Add as first task (no inputs to validate, but establishes pattern)

### 2. github_auth

**Current State**: Has inline validation (lines 16-26)

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Authenticates GitHub CLI using token from environment or .netrc
    options:
      # INPUTS
      github_auth_gh_version:
        description: "GitHub CLI version check result from github_precheck"
        type: dict
        required: true
      github_auth_gh_auth_status:
        description: "GitHub CLI authentication status from github_precheck"
        type: dict
        required: true

      # OUTPUTS
      github_auth_github_token:
        description: "[OUTPUT] GitHub authentication token"
        type: str
        required: false
      github_auth_netrc_file:
        description: "[OUTPUT] Result of checking .netrc file existence"
        type: dict
        required: false
      github_auth_netrc_token:
        description: "[OUTPUT] Token extracted from .netrc file"
        type: dict
        required: false
      github_auth_gh_auth_result:
        description: "[OUTPUT] Result of authenticating with GitHub CLI"
        type: dict
        required: false
      github_auth_gh_auth_verify:
        description: "[OUTPUT] Result of verifying authentication"
        type: dict
        required: false
```

**Validation Task**: Already exists, matches this spec

### 3. github_logout

**Current State**: Has inline validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Logs out from GitHub CLI and clears authentication state
    options:
      # INPUTS
      github_logout_gh_version:
        description: "GitHub CLI version check result"
        type: dict
        required: true
      github_logout_gh_auth_result:
        description: "GitHub CLI authentication result to verify logout needed"
        type: dict
        required: false

      # OUTPUTS
      github_logout_result:
        description: "[OUTPUT] Result of GitHub CLI logout operation"
        type: dict
        required: false
```

### 4. repo_clone

**Current State**: Has inline validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Clones GitHub repository or updates existing clone with branch sync
    options:
      # INPUTS
      repo_clone_repo_url:
        description: "GitHub repository URL to clone"
        type: str
        required: true
      repo_clone_dest_path:
        description: "Local destination path for repository"
        type: path
        required: true
      repo_clone_base_branch:
        description: "Base branch name (e.g., main, master)"
        type: str
        required: true
      repo_clone_new_branch:
        description: "New branch name for feature development"
        type: str
        required: false

      # OUTPUTS
      repo_clone_repo_stat:
        description: "[OUTPUT] Repository directory existence check"
        type: dict
        required: false
      repo_clone_clone_result:
        description: "[OUTPUT] Result of git clone operation"
        type: dict
        required: false
      repo_clone_current_branch:
        description: "[OUTPUT] Current active branch name"
        type: dict
        required: false
      repo_clone_remote_branch_check:
        description: "[OUTPUT] Check if local branch exists on remote"
        type: dict
        required: false
      repo_clone_fetch_result:
        description: "[OUTPUT] Result of fetching updates from remote"
        type: dict
        required: false
      repo_clone_pull_result:
        description: "[OUTPUT] Result of pulling latest changes"
        type: dict
        required: false
```

### 5. branch_checkout

**Current State**: Has inline validation (lines 22-40)

**Design**: (Already analyzed in inception - extract from existing validation)

### 6. branch_switch

**Current State**: No validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Switches to an existing local or remote branch
    options:
      # INPUTS
      branch_switch_dest_path:
        description: "Path to git repository"
        type: path
        required: true
      branch_switch_switch_to_branch:
        description: "Branch name to switch to"
        type: str
        required: true

      # OUTPUTS
      branch_switch_current_branch_before:
        description: "[OUTPUT] Current branch before switch operation"
        type: dict
        required: false
      branch_switch_checkout_result:
        description: "[OUTPUT] Result of git checkout operation"
        type: dict
        required: false
      branch_switch_current_branch:
        description: "[OUTPUT] Current branch after switch"
        type: dict
        required: false
```

### 7. branch_pull

**Current State**: No validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Pulls latest changes from remote for current branch
    options:
      # INPUTS
      branch_pull_dest_path:
        description: "Path to git repository"
        type: path
        required: true

      # OUTPUTS
      branch_pull_current_branch:
        description: "[OUTPUT] Current branch name"
        type: dict
        required: false
      branch_pull_pull_result:
        description: "[OUTPUT] Result of git pull operation"
        type: dict
        required: false
```

### 8. branch_push

**Current State**: Has inline validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Pushes current branch changes to remote repository
    options:
      # INPUTS
      branch_push_dest_path:
        description: "Path to git repository"
        type: path
        required: true

      # OUTPUTS
      branch_push_current_branch:
        description: "[OUTPUT] Current branch name"
        type: dict
        required: false
      branch_push_push_result:
        description: "[OUTPUT] Result of git push operation"
        type: dict
        required: false
```

### 9. branch_delete

**Current State**: Has inline validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Deletes branch both locally and remotely in idempotent manner
    options:
      # INPUTS
      branch_delete_dest_path:
        description: "Path to git repository"
        type: path
        required: true
      branch_delete_delete_branch:
        description: "Branch name to delete"
        type: str
        required: true
      branch_delete_new_branch:
        description: "New branch context for validation"
        type: str
        required: false
      branch_delete_base_branch:
        description: "Base branch to verify we're not deleting it"
        type: str
        required: true

      # OUTPUTS
      branch_delete_current_branch:
        description: "[OUTPUT] Current branch name before deletion"
        type: dict
        required: false
      branch_delete_local_branch_check:
        description: "[OUTPUT] Check if branch exists locally"
        type: dict
        required: false
      branch_delete_remote_branch_check:
        description: "[OUTPUT] Check if branch exists on remote"
        type: dict
        required: false
      branch_delete_delete_local_result:
        description: "[OUTPUT] Result of deleting local branch"
        type: dict
        required: false
      branch_delete_delete_remote_result:
        description: "[OUTPUT] Result of deleting remote branch"
        type: dict
        required: false
```

### 10. repo_file_add

**Current State**: Has inline validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Copies file into repository and stages it for commit
    options:
      # INPUTS
      repo_file_add_file_source:
        description: "Source file path to copy from"
        type: path
        required: true
      repo_file_add_file_path:
        description: "Destination file path in repository (auto-detected from source if not provided)"
        type: str
        required: false
      repo_file_add_dest_path:
        description: "Path to git repository"
        type: path
        required: true

      # OUTPUTS
      repo_file_add_detected_file_path:
        description: "[OUTPUT] Auto-detected file path from source"
        type: str
        required: false
      repo_file_add_copy_result:
        description: "[OUTPUT] Result of copying file"
        type: dict
        required: false
      repo_file_add_file_stat:
        description: "[OUTPUT] File existence check result"
        type: dict
        required: false
      repo_file_add_git_status:
        description: "[OUTPUT] Git status for the file"
        type: dict
        required: false
      repo_file_add_git_add_result:
        description: "[OUTPUT] Result of git add operation"
        type: dict
        required: false
```

### 11. repo_commit

**Current State**: Has inline validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Creates git commit with specified message if changes are staged
    options:
      # INPUTS
      repo_commit_dest_path:
        description: "Path to git repository"
        type: path
        required: true
      repo_commit_commit_message:
        description: "Commit message text"
        type: str
        required: false
      repo_commit_file_path:
        description: "File path for auto-generated commit message"
        type: str
        required: false

      # OUTPUTS
      repo_commit_git_status:
        description: "[OUTPUT] Git status before commit"
        type: dict
        required: false
      repo_commit_final_message:
        description: "[OUTPUT] Final commit message used"
        type: str
        required: false
      repo_commit_commit_result:
        description: "[OUTPUT] Result of git commit operation"
        type: dict
        required: false
```

### 12. pr_create

**Current State**: Has inline validation (lines 21-47)

**Design**: (Already analyzed - extract from existing validation)

### 13. pr_status_check

**Current State**: No validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Checks pull request status including CI checks and review state
    options:
      # INPUTS
      pr_status_check_gh_version:
        description: "GitHub CLI version check result"
        type: dict
        required: true
      pr_status_check_gh_auth_status:
        description: "GitHub CLI authentication status"
        type: dict
        required: true
      pr_status_check_dest_path:
        description: "Path to git repository"
        type: path
        required: true

      # OUTPUTS
      pr_status_check_current_branch:
        description: "[OUTPUT] Current branch name"
        type: dict
        required: false
      pr_status_check_pr_number:
        description: "[OUTPUT] Pull request number"
        type: dict
        required: false
      pr_status_check_pr_status:
        description: "[OUTPUT] Pull request status checks result"
        type: dict
        required: false
      pr_status_check_status_checks:
        description: "[OUTPUT] Parsed status checks list"
        type: list
        required: false
      pr_status_check_failed_checks:
        description: "[OUTPUT] Failed status checks list"
        type: list
        required: false
      pr_status_check_pending_checks:
        description: "[OUTPUT] Pending status checks list"
        type: list
        required: false
      pr_status_check_has_pending_checks:
        description: "[OUTPUT] Boolean flag if pending checks exist"
        type: bool
        required: false
```

### 14. pr_status_check_pause

**Current State**: No validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Waits for PR status checks to complete with configurable retries
    options:
      # INPUTS
      pr_status_check_pause_pr_status_check_delay:
        description: "Seconds to wait between status check attempts"
        type: int
        required: true
      pr_status_check_pause_pr_status_check_retries:
        description: "Maximum number of retry attempts"
        type: int
        required: true
      pr_status_check_pause_has_pending_checks:
        description: "Flag indicating if pending checks exist from previous iteration"
        type: bool
        required: false
      pr_status_check_pause_attempt_number:
        description: "Current attempt number in retry loop"
        type: int
        required: true

      # OUTPUTS
      pr_status_check_has_pending_checks:
        description: "[OUTPUT] Updated flag after checking status (inherited from pr_status_check)"
        type: bool
        required: false
```

### 15. pr_comment

**Current State**: No validation

**Design**:
```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Adds comment to pull request for current branch
    options:
      # INPUTS
      pr_comment_pr_comment:
        description: "Comment text to add to pull request"
        type: str
        required: true
      pr_comment_dest_path:
        description: "Path to git repository"
        type: path
        required: true

      # OUTPUTS
      pr_comment_current_branch:
        description: "[OUTPUT] Current branch name"
        type: dict
        required: false
      pr_comment_pr_number:
        description: "[OUTPUT] Pull request number"
        type: dict
        required: false
      pr_comment_comment_result:
        description: "[OUTPUT] Result of adding comment"
        type: dict
        required: false
```

### 16. pr_merge

**Current State**: Has inline validation (lines 20-30)

**Design**: (Already analyzed - extract from existing validation)

### Implementation Approach

**Phase 1: Create meta/argument_specs.yml for all roles**

For each of 16 roles:
1. Create `meta/` directory if it doesn't exist
2. Create `argument_specs.yml` file with specification above
3. Verify YAML syntax

**Phase 2: Update inline validation (where needed)**

For 7 roles without validation:
1. Add validation task as first task in `tasks/main.yml`
2. Use identical spec to meta/argument_specs.yml
3. Ensure task name follows pattern: `"{Role}: Validate arguments"`

For 9 roles with validation:
1. Verify inline spec matches meta spec
2. Update if discrepancies found

**Phase 3: Verification**

1. Run `ansible-doc rstyczynski.github.{role_name}` for each role
2. Verify documentation displays correctly
3. Run flow.yml end-to-end test
4. Verify idempotency (run twice)

### Testing Strategy

**Functional Tests:**

1. **Validation Test**: Each role validates arguments correctly
   - Test with valid arguments (should pass)
   - Test with missing required arguments (should fail with clear error)
   - Test with wrong type (should fail with type error)

2. **Documentation Test**: ansible-doc produces complete output
   ```bash
   for role in github_precheck github_auth github_logout repo_clone branch_checkout branch_switch branch_pull branch_push branch_delete repo_file_add repo_commit pr_create pr_status_check pr_status_check_pause pr_comment pr_merge; do
     ansible-doc rstyczynski.github.$role
   done
   ```

3. **Integration Test**: flow.yml completes successfully
   ```bash
   cd github_collection
   ansible-playbook flow.yml
   ```

4. **Idempotency Test**: Second run shows no changes
   ```bash
   ansible-playbook flow.yml  # Second execution
   ```

**Edge Cases:**

1. Optional parameters not provided (should use defaults or skip)
2. Output attributes should never cause validation failures
3. Path parameters should handle relative and absolute paths

**Success Criteria:**

- ✅ All 16 roles have `meta/argument_specs.yml`
- ✅ All roles validate arguments as first task
- ✅ `ansible-doc` works for all 16 roles
- ✅ flow.yml passes without modification
- ✅ No breaking changes to existing interfaces

### Integration Notes

**Dependencies:**

- GHC-5 depends on GHC-4 completion (needs argument_specs.yml for documentation)
- No external system dependencies

**Compatibility:**

- Maintains backward compatibility with flow.yml
- All existing variable names preserved
- No changes to role behavior, only formalization

**Reusability:**

- Template structure reusable for future roles
- Validation pattern established for Collection expansion

### Documentation Requirements

**User Documentation:**

- None required (GHC-5 handles this)

**Technical Documentation:**

- Update Collection README if needed
- Document argument_specs.yml pattern for future role development

### Design Decisions

**Decision 1: Dual Validation (Meta + Inline)**

**Rationale:**
- Meta specs enable ansible-doc documentation
- Inline validation provides immediate runtime feedback
- Both use identical specifications to ensure consistency

**Alternatives Considered:**
- Meta specs only (no runtime validation - rejected for poor UX)
- Inline only (no documentation - rejected for missing GHC-5 requirement)

**Decision 2: Type Mapping (dict for register results)**

**Rationale:**
- Ansible register creates dict with stdout, stderr, rc, changed, etc.
- Using `dict` type accurately reflects structure
- Consistent with Ansible documentation

**Alternatives Considered:**
- Using `raw` type (too permissive)
- Using `str` type (incorrect, would fail validation)

**Decision 3: OUTPUT attributes in same argument_specs**

**Rationale:**
- Single file documents complete role interface
- Follows Ansible best practices
- [OUTPUT] prefix distinguishes from inputs

**Alternatives Considered:**
- Separate output documentation file (rejected - not standard)
- No output documentation (rejected - GHC-4 requires it)

### Open Design Questions

None - all design decisions resolved based on established patterns and requirements.

---

## GHC-5: GitHub Collection documentation

Status: Proposed

### Requirement Summary

Produce `ansible-doc` documentation for all 16 roles by leveraging `meta/argument_specs.yml` files created in GHC-4. Each role requires concise description and complete parameter documentation.

### Feasibility Analysis

**API Availability:**

✅ `ansible-doc` command - Standard Ansible tool
- Documentation: https://docs.ansible.com/ansible/latest/cli/ansible-doc.html
- Purpose: Display documentation for modules and roles
- Integration: Automatically reads `meta/argument_specs.yml`

**Technical Constraints:**

1. **Depends on GHC-4**: Requires argument_specs.yml files to exist
2. **Sequential Dependency**: Cannot complete GHC-5 without GHC-4
3. **Format Constraints**: Must follow ansible-doc expected structure

**Risk Assessment:**

- **Low Risk**: Incomplete or unclear descriptions
  - **Mitigation**: Review role implementation to understand behavior
  - **Testing**: Manual review of ansible-doc output

### Design Overview

**Architecture:**

GHC-5 is primarily a validation and refinement task that builds on GHC-4:

1. Verify `short_description` is clear and concise
2. Ensure all parameter descriptions are helpful
3. Add examples if beneficial (optional enhancement)

**Key Components:**

1. **Role Descriptions**: Already drafted in inception phase
2. **Parameter Descriptions**: Already specified in GHC-4 design
3. **Verification Script**: Automated check for all roles

**Data Flow:**

```
meta/argument_specs.yml (from GHC-4)
    ↓
ansible-doc rstyczynski.github.{role_name}
    ↓
Formatted documentation output
    ↓
Manual review for clarity
```

### Technical Specification

**Role Descriptions (Final):**

These descriptions were drafted in inception and are finalized here:

1. **github_precheck**: "Verifies system prerequisites including git installation and GitHub CLI authentication status"

2. **github_auth**: "Authenticates GitHub CLI using token from environment variables or .netrc file"

3. **github_logout**: "Logs out from GitHub CLI and clears authentication state"

4. **repo_clone**: "Clones a GitHub repository or updates an existing clone, handling branch synchronization"

5. **branch_checkout**: "Checks out or creates a new branch, with optional push to remote"

6. **branch_switch**: "Switches to an existing local or remote branch"

7. **branch_pull**: "Pulls latest changes from remote for the current branch"

8. **branch_push**: "Pushes current branch changes to remote repository"

9. **branch_delete**: "Deletes a branch both locally and remotely in an idempotent manner"

10. **repo_file_add**: "Copies a file into repository and stages it for commit"

11. **repo_commit**: "Creates a git commit with specified message if changes are staged"

12. **pr_create**: "Creates a new pull request using GitHub CLI with customizable title and body"

13. **pr_status_check**: "Checks pull request status including CI checks and review state"

14. **pr_status_check_pause**: "Waits for PR status checks to complete with configurable retries and delays"

15. **pr_comment**: "Adds a comment to the pull request for the current branch"

16. **pr_merge**: "Merges a pull request using specified method (merge, squash, or rebase)"

**Verification Script:**

```bash
#!/bin/bash
# verify_docs.sh

echo "Verifying ansible-doc for all roles in rstyczynski.github Collection"
echo "======================================================================"

ROLES="github_precheck github_auth github_logout repo_clone branch_checkout branch_switch branch_pull branch_push branch_delete repo_file_add repo_commit pr_create pr_status_check pr_status_check_pause pr_comment pr_merge"

FAILED=0

for role in $ROLES; do
    echo -n "Checking rstyczynski.github.$role ... "
    if ansible-doc rstyczynski.github.$role > /dev/null 2>&1; then
        echo "✅ OK"
    else
        echo "❌ FAILED"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "Results: $((16 - FAILED))/16 roles documented"

if [ $FAILED -eq 0 ]; then
    echo "✅ All roles have valid documentation"
    exit 0
else
    echo "❌ $FAILED roles failed documentation check"
    exit 1
fi
```

### Implementation Approach

**Step 1:** Complete GHC-4 implementation (prerequisite)

**Step 2:** Create verification script
- Save as `github_collection/verify_docs.sh`
- Make executable: `chmod +x verify_docs.sh`

**Step 3:** Run verification for all roles
```bash
./verify_docs.sh
```

**Step 4:** Manual review of each role
```bash
ansible-doc rstyczynski.github.github_precheck
ansible-doc rstyczynski.github.github_auth
# ... etc for all 16 roles
```

**Step 5:** Fix any issues found
- Update short_description if unclear
- Improve parameter descriptions if confusing
- Ensure OUTPUT attributes are properly marked

### Testing Strategy

**Functional Tests:**

1. **Documentation Completeness**: All 16 roles return valid output
2. **Readability**: Descriptions are clear to users unfamiliar with code
3. **Accuracy**: Documented behavior matches actual implementation

**Success Criteria:**

- ✅ `ansible-doc rstyczynski.github.{role}` works for all 16 roles
- ✅ Each role has clear short_description
- ✅ All parameters documented with helpful descriptions
- ✅ OUTPUT attributes clearly marked with [OUTPUT] prefix

### Integration Notes

**Dependencies:**

- **Hard Dependency**: GHC-4 must be 100% complete
- Sequential implementation required

**Compatibility:**

- Read-only operation (documentation only)
- No runtime impact
- No breaking changes

### Documentation Requirements

This backlog item IS the documentation requirement, so meta-documentation is:

**Collection README**: May add section on viewing role documentation:
```markdown
## Role Documentation

View documentation for any role:
```bash
ansible-doc rstyczynski.github.{role_name}
```

Example:
```bash
ansible-doc rstyczynski.github.branch_checkout
```
```

### Design Decisions

**Decision 1: Use ansible-doc native format (no custom docs)**

**Rationale:**
- Standard Ansible approach
- No additional tooling required
- Familiar to Ansible users

**Alternatives Considered:**
- Custom Markdown documentation (rejected - redundant)
- Sphinx documentation (rejected - overkill for 16 roles)

**Decision 2: Concise descriptions (1-2 sentences)**

**Rationale:**
- Quick reference for users
- Detailed information in parameter descriptions
- Follows ansible-doc conventions

**Alternatives Considered:**
- Long descriptions (rejected - clutters output)
- Minimal descriptions (rejected - not helpful enough)

### Open Design Questions

None - design is straightforward given GHC-4 foundation.

---

# Design Summary

## Overall Architecture

Sprint 3 delivers a complete documentation and validation framework for the `rstyczynski.github` Collection:

```
┌─────────────────────────────────────────────────────────────┐
│                    rstyczynski.github Collection            │
│                         (16 roles)                          │
└─────────────────────────────────────────────────────────────┘
                              │
                 ┌────────────┴────────────┐
                 │                         │
         ┌───────▼────────┐       ┌───────▼────────┐
         │    GHC-4       │       │    GHC-5       │
         │ Argument Specs │       │ Documentation  │
         └───────┬────────┘       └───────┬────────┘
                 │                         │
    ┌────────────┴─────────────┐          │
    │                          │          │
┌───▼──────────┐   ┌──────────▼───┐      │
│ meta/        │   │ tasks/       │      │
│ argument_    │   │ main.yml     │      │
│ specs.yml    │   │ (validation) │      │
└───┬──────────┘   └──────────────┘      │
    │                                     │
    └─────────────────────────────────────┤
                                          │
                                  ┌───────▼────────┐
                                  │  ansible-doc   │
                                  │    output      │
                                  └────────────────┘
```

## Shared Components

**Argument Specification Template:**
- Reusable structure for all roles
- INPUT/OUTPUT separation pattern
- Type mapping conventions

**Validation Pattern:**
- First task in tasks/main.yml
- Identical to meta specification
- Clear error messages

**Documentation Pattern:**
- Concise short_description
- Detailed parameter descriptions
- OUTPUT prefix for attributes

## Design Risks

1. **Low Risk**: Implementation effort underestimated
   - **Mitigation**: Systematic approach, role-by-role implementation
   - **Contingency**: Extend sprint if needed

2. **Low Risk**: Type validation too strict
   - **Mitigation**: Test with flow.yml after each role
   - **Rollback**: Adjust types to match actual usage

## Resource Requirements

**Tools:**
- Ansible Core 2.11+ (already available)
- ansible-doc command (included with Ansible)
- Text editor for YAML files

**Libraries:**
- None required (uses Ansible built-in modules)

**External Services:**
- None required

## Design Approval Status

Status: Proposed - Awaiting Review

This design is ready for Product Owner review. Once approved (Status changed to "Accepted"), implementation can begin in the Construction phase.

---

**Design Document Version**: 1.0
**Created**: 2025-11-21
**Designer**: Designer Agent (Elaboration Phase)
**Sprint**: Sprint 3 - Role interface specification
