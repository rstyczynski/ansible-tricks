# Sprint 3 - Analysis

Status: Complete

## Sprint Overview

Sprint 3 focuses on implementing formal argument specification and documentation for all roles in the `rstyczynski.github` Ansible Collection. This sprint delivers two key backlog items:

- **GHC-4**: Implement input/output specification for all roles using `meta/argument_specs.yml`
- **GHC-5**: Generate comprehensive `ansible-doc` documentation for all roles

The sprint ensures all 16 roles have proper argument validation, clear interface definitions, and complete documentation accessible via `ansible-doc`.

## Backlog Items Analysis

### GHC-4: GitHub Collection roles support input / output specification

**Requirement Summary:**

Implement `meta/argument_specs.yml` for all 16 roles following the pattern defined in `rules/specific/ansible/input_output_spec.md`. Each role must:

1. Validate arguments using `validate_argument_spec` module (not `assert`)
2. Document all input parameters with type, description, and required status
3. Document all output attributes with `[OUTPUT]` prefix in descriptions
4. Maintain existing variable naming conventions (`{role_name}_` prefix)

**Technical Approach:**

Currently, 9 out of 16 roles already use inline `validate_argument_spec` in their `tasks/main.yml` files:
- branch_checkout (lines 22-40)
- github_auth (lines 16-26)
- pr_create (lines 21-47)
- pr_merge (lines 20-30)
- branch_push
- repo_clone
- repo_commit
- repo_file_add
- branch_delete

The remaining 7 roles lack validation:
- github_precheck
- github_logout
- branch_pull
- branch_switch
- pr_status_check
- pr_status_check_pause
- pr_comment

**Implementation Strategy:**

1. **Extract existing inline validation** from 9 roles and move to `meta/argument_specs.yml`
2. **Create new argument specs** for 7 roles without validation
3. **Document output attributes** for all roles using `[OUTPUT]` prefix
4. **Maintain inline validation** as first task (using the same argument_spec structure)

**Pattern Structure:**

```yaml
# meta/argument_specs.yml
argument_specs:
  main:
    short_description: Brief role description
    options:
      # INPUT parameters (no prefix)
      role_name_input_param:
        description: "Parameter description"
        type: str|int|bool|dict|list
        required: true|false

      # OUTPUT attributes (with [OUTPUT] prefix)
      role_name_output_attr:
        description: "[OUTPUT] Attribute description"
        type: str|int|bool|dict|list
        required: false
```

**Dependencies:**

- No dependencies on other Backlog Items
- Requires understanding of existing INPUT/OUTPUT tables in each role's `tasks/main.yml`
- Must maintain backward compatibility with flow.yml

**Testing Strategy:**

1. **Validation Testing**: Each role validates arguments correctly when called
2. **Documentation Testing**: `ansible-doc rstyczynski.github.{role_name}` produces complete output
3. **Integration Testing**: End-to-end flow.yml test passes without modification
4. **Idempotency Testing**: All operations remain idempotent after changes

**Risks/Concerns:**

1. **Low Risk**: Extracting inline validation to meta/argument_specs.yml might introduce inconsistencies
   - **Mitigation**: Keep both inline validation and meta specs synchronized

2. **Low Risk**: Some output attributes may be missed if not clearly documented in comments
   - **Mitigation**: Review all `register:` statements in each role

3. **Low Risk**: Type specifications may not match actual Ansible behavior (dict vs string for command results)
   - **Mitigation**: Use `dict` for all `register:` results, `str` for set_fact strings

**Compatibility Notes:**

- All existing variable names preserved (no breaking changes)
- flow.yml continues to work without modification
- Inline validation remains as first task for immediate feedback
- `meta/argument_specs.yml` enables ansible-doc documentation

### GHC-5: GitHub Collection documentation

**Requirement Summary:**

Produce `ansible-doc` documentation for all 16 roles by leveraging the `meta/argument_specs.yml` files created in GHC-4. Each role requires:

1. A concise description (up to 5 sentences) explaining the role's purpose
2. Complete documentation for all input arguments
3. Complete documentation for all output attributes
4. Verification that `ansible-doc rstyczynski.github.{role_name}` produces readable output

**Technical Approach:**

Once GHC-4 is complete, `ansible-doc` automatically reads `meta/argument_specs.yml` to generate documentation. The work involves:

1. Writing clear `short_description` for each role's `argument_specs.main`
2. Ensuring all `description` fields are comprehensive and user-friendly
3. Verifying output format with `ansible-doc` command
4. Adding examples to `meta/argument_specs.yml` if needed (optional enhancement)

**Role Descriptions (Draft):**

Based on code analysis, here are proposed short descriptions:

1. **github_precheck**: Verifies system prerequisites including git installation and GitHub CLI authentication status
2. **github_auth**: Authenticates GitHub CLI using token from environment variables or .netrc file
3. **github_logout**: Logs out from GitHub CLI and clears authentication state
4. **repo_clone**: Clones a GitHub repository or updates an existing clone, handling branch synchronization
5. **branch_checkout**: Checks out or creates a new branch, with optional push to remote
6. **branch_switch**: Switches to an existing local or remote branch
7. **branch_pull**: Pulls latest changes from remote for the current branch
8. **branch_push**: Pushes current branch changes to remote repository
9. **branch_delete**: Deletes a branch both locally and remotely in an idempotent manner
10. **repo_file_add**: Copies a file into repository and stages it for commit
11. **repo_commit**: Creates a git commit with specified message if changes are staged
12. **pr_create**: Creates a new pull request using GitHub CLI with customizable title and body
13. **pr_status_check**: Checks pull request status including CI checks and review state
14. **pr_status_check_pause**: Waits for PR status checks to complete with configurable retries and delays
15. **pr_comment**: Adds a comment to the pull request for the current branch
16. **pr_merge**: Merges a pull request using specified method (merge, squash, or rebase)

**Dependencies:**

- **Depends on GHC-4**: Requires `meta/argument_specs.yml` files to be created first
- Sequential dependency: cannot complete GHC-5 without GHC-4

**Testing Strategy:**

1. **Documentation Completeness**: Run `ansible-doc rstyczynski.github.{role_name}` for all 16 roles
2. **Readability Review**: Verify descriptions are clear and helpful
3. **Accuracy Verification**: Ensure documented behavior matches actual implementation

**Risks/Concerns:**

1. **Low Risk**: Generic descriptions may not capture role-specific nuances
   - **Mitigation**: Review each role's implementation to capture unique behaviors

2. **Low Risk**: Output attributes may be unclear without usage examples
   - **Mitigation**: Consider adding examples section (optional, not required for this sprint)

**Compatibility Notes:**

- Documentation is read-only (does not affect runtime behavior)
- Enhances developer experience without breaking changes
- Supports both human readers and automated documentation generation

## Overall Sprint Assessment

**Feasibility:** High

The sprint is highly feasible because:
1. 9 out of 16 roles already have inline validation that can be extracted
2. All roles have INPUT/OUTPUT tables documenting their interfaces
3. The pattern is well-defined in `input_output_spec.md`
4. No new functionality required, only formalization of existing interfaces
5. End-to-end test (flow.yml) provides validation coverage

**Estimated Complexity:** Moderate

Complexity factors:
- **Simple**: Pattern is well-defined and repetitive across 16 roles
- **Moderate**: Requires careful extraction of inline validation to avoid errors
- **Moderate**: Need to document ~100+ parameters across all roles (estimated 6-8 per role)

Estimated effort breakdown:
- GHC-4 Implementation: 16 roles × ~30 minutes = 8 hours
- GHC-5 Documentation: 16 roles × ~15 minutes = 4 hours
- Testing and validation: 2 hours
- **Total: ~14 hours of focused work**

**Prerequisites Met:** Yes

All prerequisites are satisfied:
- ✅ Collection structure in place (16 roles with FQCN `rstyczynski.github`)
- ✅ Rules documentation available (`input_output_spec.md`, `input_output_rule_spec.md`)
- ✅ End-to-end test working (flow.yml)
- ✅ All roles have INPUT/OUTPUT tables in comments
- ✅ 9 roles already demonstrate validation pattern

**Open Questions:**

None. Requirements are clear and unambiguous. Execution mode is Managed, so any discovered ambiguities during implementation will be raised for clarification.

## Recommended Design Focus Areas

The design phase (Elaboration) should focus on:

1. **Argument Spec Structure Template**: Create a reusable template showing exactly where INPUT/OUTPUT parameters go in `meta/argument_specs.yml`

2. **Validation Strategy**: Decide whether to keep inline validation in `tasks/main.yml` or rely solely on meta specs
   - **Recommendation**: Keep both for immediate validation feedback

3. **Type Mapping**: Document the mapping between Ansible module results and argument spec types:
   - Command/shell register results → `dict`
   - set_fact string values → `str`
   - Boolean flags → `bool`

4. **Output Attribute Discovery**: Create a systematic approach to identify all output attributes:
   - Scan for all `register:` statements
   - Scan for all `set_fact:` statements
   - Verify against OUTPUT tables in comments

5. **Documentation Style Guide**: Define consistent phrasing for descriptions:
   - Input parameters: Present tense, imperative ("Path to repository", "Whether to push branch")
   - Output attributes: Past tense, descriptive ("[OUTPUT] Result of checking branch existence")

6. **Testing Procedure**: Define the verification steps:
   - Step 1: Run `ansible-doc` for each role
   - Step 2: Execute flow.yml end-to-end test
   - Step 3: Verify idempotency by running flow.yml twice

## Existing Implementation Patterns

### Pattern 1: Inline Validation (9 roles)

Example from branch_checkout:

```yaml
- name: "Branch: Validate arguments"
  ansible.builtin.validate_argument_spec:
    argument_spec:
      branch_checkout_new_branch:
        type: str
        required: true
        description: Name of the branch to checkout or create
      branch_checkout_dest_path:
        type: str
        required: true
        description: Destination path to the git repository
```

### Pattern 2: No Validation (7 roles)

Example from github_precheck - no validation task present, only INPUT/OUTPUT tables in comments.

### Pattern 3: Variable Naming

All roles consistently use `{role_name}_` prefix for all variables:
- `github_precheck_git_version`
- `branch_checkout_new_branch`
- `pr_create_final_pr_title`

This naming convention must be preserved in argument specs.

### Pattern 4: INPUT/OUTPUT Tables

All roles document interfaces in YAML comments at the top of `tasks/main.yml`:

```yaml
# INPUT VARIABLES TABLE
# | name                      | type   | description                      |
# |---------------------------|--------|----------------------------------|

# OUTPUT VARIABLES TABLE
# | name                      | type   | description                      |
# |---------------------------|--------|----------------------------------|
```

These tables serve as the authoritative source for creating `meta/argument_specs.yml`.

## Readiness for Design Phase

**Status**: Confirmed Ready

All requirements are clear and well-understood:
- ✅ Sprint objectives defined
- ✅ Backlog items analyzed in detail
- ✅ Existing patterns documented
- ✅ Technical approach validated
- ✅ Risks identified and mitigated
- ✅ Testing strategy defined
- ✅ Compatibility verified

No blockers or open questions remain. The Designer Agent can proceed with creating detailed specifications for implementing `meta/argument_specs.yml` for all 16 roles.

---

**Analysis Date**: 2025-11-21
**Analyst**: Analyst Agent (Inception Phase)
**Sprint**: Sprint 3 - Role interface specification
**Status**: Analysis Complete
