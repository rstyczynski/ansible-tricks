# Sprint 6 - Analysis

Status: Complete

## Sprint Overview

**Sprint 6: Security cleanup**

This sprint focuses on securing sensitive data (GitHub TOKEN) and simplifying the role interface by removing unnecessary output variable dependencies from the precheck role. The goal is to improve security posture and reduce coupling between roles.

### Sprint Objectives

1. Minimize GitHub TOKEN exposure in Ansible facts
2. Remove explicit dependencies on precheck authentication status variables
3. Simplify precheck role to focus on its core purpose: halting on missing dependencies

## Backlog Items Analysis

### GHC-9: GitHub TOKEN is removed as soon as possible from facts

**Requirement Summary:**

GitHub TOKEN from netrc file must be treated as a secret and protected like the filesystem netrc file (600 permissions). Requirements:
- Remove TOKEN from exposed outputs immediately after use
- Keep TOKEN in facts for minimal time only
- Never expose TOKEN in outputs or logs
- Ensure no_log protects TOKEN in all tasks

**Current Implementation Analysis:**

File: `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/tasks/main.yml`

**Issues Identified:**

1. **Line 10-12:** OUTPUT VARIABLES TABLE documents TOKEN exposure:
   ```yaml
   # | github_auth_github_token      | string | GitHub authentication token                    |
   # | github_auth_netrc_token       | dict   | Token extracted from .netrc file               |
   ```

2. **Line 22:** TOKEN set to fact and remains throughout execution:
   ```yaml
   github_auth_github_token: "{{ lookup('env', 'GH_TOKEN') | default(lookup('env', 'GITHUB_TOKEN'), true) }}"
   ```

3. **Line 43:** `github_auth_netrc_token` register contains TOKEN in stdout:
   ```yaml
   register: github_auth_netrc_token
   ```

4. **Line 52:** TOKEN copied to another fact (line 52 has `no_log: true` ✓):
   ```yaml
   github_auth_github_token: "{{ github_auth_netrc_token.stdout }}"
   ```

5. **Line 85:** Critical security issue - `no_log: false` on task using TOKEN:
   ```yaml
   no_log: false
   ```
   Should be `no_log: true` since TOKEN is in command via echo

**Technical Approach:**

1. Remove `github_auth_github_token` and `github_auth_netrc_token` from OUTPUT VARIABLES TABLE
2. Add `no_log: true` to all tasks handling TOKEN (lines 22, 30, 43, 74)
3. Use `ansible.builtin.set_stats` to remove TOKEN from facts immediately after gh auth login
4. Consider using block/rescue to ensure TOKEN cleanup even on failure
5. Document in README that TOKEN is not exposed as output variable

**Dependencies:**

- No dependencies on other backlog items
- Changes are isolated to github_auth role

**Testing Strategy:**

1. **Functional Test:** Verify authentication still works after TOKEN removal
2. **Security Test:** Verify TOKEN does not appear in ansible output with -v, -vv, -vvv flags
3. **Negative Test:** Verify TOKEN cleanup happens even when auth fails
4. **Idempotency Test:** Run role twice, verify no TOKEN leakage

**Risks/Concerns:**

- **Low Risk:** Changes are straightforward
- **Concern:** Ensure TOKEN cleanup happens in all code paths (success/failure)
- **Mitigation:** Use block/always pattern to guarantee cleanup

**Compatibility Notes:**

- ✅ No breaking changes to role interface
- ✅ TOKEN was already documented as output, but playbooks should not depend on it
- ✅ Removing it aligns with security best practices
- ⚠️ If any external playbook references `github_auth_github_token`, it will break (unlikely, as it's a secret)

### GHC-10: gh assumes authentication is in place

**Requirement Summary:**

Remove explicit usage of `github_precheck_gh_auth_status` variable. The gh CLI will handle authentication failures internally with appropriate error messages. Variable may exist in precheck outputs but roles should not explicitly use it.

**Current Implementation Analysis:**

File: `github_collection/flow.yml`

**Issues Identified:**

1. **Line 65:** Passes `github_precheck_gh_auth_status` to github_auth role:
   ```yaml
   github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"
   ```

2. **github_auth role** uses this variable (line 82 in tasks/main.yml):
   ```yaml
   - github_auth_gh_auth_status.rc != 0
   ```

3. **github_auth/meta/argument_specs.yml:** Defines `github_auth_gh_auth_status` as required parameter

**Technical Approach:**

1. Remove `github_auth_gh_auth_status` parameter from github_auth role's argument_specs.yml
2. Remove `github_auth_gh_auth_status` from github_auth role's INPUT VARIABLES TABLE
3. Remove condition `github_auth_gh_auth_status.rc != 0` from line 82 in github_auth/tasks/main.yml
4. Simplify logic: Always attempt gh auth login if TOKEN is found (gh CLI will skip if already authenticated)
5. Remove variable passing from flow.yml line 65
6. Update github_auth README to reflect simplified interface

**Dependencies:**

- Related to GHC-11 (both involve removing precheck output dependencies)
- Can be implemented independently

**Testing Strategy:**

1. **Functional Test:** Verify auth role works when gh is already authenticated
2. **Functional Test:** Verify auth role works when gh is not authenticated
3. **Idempotency Test:** Run auth role twice (second time gh already authenticated)
4. **Error Handling:** Verify gh CLI errors are properly surfaced without explicit status check

**Risks/Concerns:**

- **Low Risk:** gh CLI handles authentication state internally
- **Benefit:** Simpler role interface, less coupling with precheck
- **Mitigation:** Trust gh CLI error handling (it's designed for this)

**Compatibility Notes:**

- ⚠️ **Breaking Change:** github_auth role's argument specification changes (required parameter removed)
- ✅ flow.yml will be updated in same sprint
- ✅ gh CLI will provide clear error messages if authentication needed
- ⚠️ External playbooks using this role will need to remove `github_auth_gh_auth_status` parameter

### GHC-11: Precheck role halts task flow in case of missing dependencies

**Requirement Summary:**

Precheck role exists to halt processing with error when dependencies are missing. It should NOT expose variables for further use by other roles. Remove all instances where other roles use precheck outputs (e.g., `github_auth_gh_version`).

**Current Implementation Analysis:**

**Files Affected:**

1. `github_collection/flow.yml` - Line 64
2. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/tasks/main.yml` - Line 4, 80
3. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/meta/argument_specs.yml`
4. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/README.md`
5. `github_collection/collections/ansible_collections/rstyczynski/github/README.md`

**Issues Identified:**

1. **flow.yml line 64:** Passes `github_precheck_gh_version` to github_auth role:
   ```yaml
   github_auth_gh_version: "{{ github_precheck_gh_version }}"
   ```

2. **github_auth role line 80:** Uses `github_auth_gh_version.rc` to conditionally run auth:
   ```yaml
   - github_auth_gh_version.rc == 0
   ```

3. **github_auth/meta/argument_specs.yml:** Defines `github_auth_gh_version` as REQUIRED parameter

4. **Precheck role:** Outputs `github_precheck_gh_version` but does NOT halt on failure (line 25: `failed_when: false`)

**Root Cause:**

The precheck role currently has `failed_when: false` on dependency checks, making it a "soft check" that exposes variables. Per GHC-11, it should be a "hard check" that halts execution when dependencies are missing.

**Technical Approach:**

**Option A: Precheck halts on failure (Preferred - aligns with GHC-11 requirement)**

1. **Modify github_precheck role:**
   - Remove `failed_when: false` from gh CLI check (line 25)
   - Role will halt if gh CLI not available
   - Keep output variables for debugging, but roles won't depend on them

2. **Modify github_auth role:**
   - Remove `github_auth_gh_version` parameter from argument_specs.yml
   - Remove `github_auth_gh_version` from INPUT VARIABLES TABLE
   - Remove condition `github_auth_gh_version.rc == 0` from line 80
   - Simplify: Assume gh CLI available (precheck already verified)

3. **Update flow.yml:**
   - Remove `github_auth_gh_version` parameter passing (line 64)

4. **Update documentation:**
   - github_precheck/README.md: Document that role HALTS on missing dependencies
   - github_auth/README.md: Remove `github_auth_gh_version` from parameters

**Option B: Keep soft precheck (Not recommended - violates GHC-11)**

- Keep `failed_when: false`
- Remove variable dependencies
- Warnings only

**Recommendation: Option A** - Aligns with GHC-11 requirement: "halts task flow in case of missing dependencies"

**Dependencies:**

- Related to GHC-10 (both remove precheck output dependencies)
- Must coordinate changes to precheck and github_auth roles
- Should be implemented together for coherent design

**Testing Strategy:**

1. **Positive Test:** Run flow.yml with gh CLI installed → should succeed
2. **Negative Test:** Run with gh CLI missing → should halt at precheck with clear error
3. **Functional Test:** Verify github_auth no longer references `github_auth_gh_version`
4. **Integration Test:** Full flow.yml execution after changes

**Risks/Concerns:**

- **Medium Risk:** Changing precheck to halt (instead of warn) is behavioral change
- **Benefit:** Clear failure point, simpler role interface, aligns with requirement
- **Mitigation:** Document behavioral change in README
- ⚠️ **Breaking Change:** Precheck will now FAIL (not warn) if gh CLI missing

**Compatibility Notes:**

- ⚠️ **Breaking Change:** Precheck role changes from soft check to hard check
- ⚠️ **Breaking Change:** github_auth role's argument specification changes
- ✅ Users will get immediate clear failure instead of delayed cryptic gh errors
- ⚠️ External playbooks must remove `github_auth_gh_version` parameter

## Overall Sprint Assessment

**Feasibility:** High

All three backlog items are:
- Well-defined with clear requirements
- Technically straightforward to implement
- Limited in scope to specific roles
- Based on security and design best practices

**Estimated Complexity:** Moderate

- GHC-9 (TOKEN security): **Moderate** - Requires careful handling of fact cleanup
- GHC-10 (Remove gh_auth_status): **Simple** - Parameter removal
- GHC-11 (Precheck halts): **Moderate** - Behavioral change requires careful testing

**Prerequisites Met:** Yes

All prerequisites are met:
- ✅ Existing roles are well-structured and use meta/argument_specs.yml
- ✅ Test framework exists (flow.yml provides end-to-end test)
- ✅ Documentation structure is in place
- ✅ Git workflows are established

**Open Questions:**

None - All requirements are clear from BACKLOG.md.

## Compatibility Impact Summary

### Breaking Changes

**GHC-10 and GHC-11 introduce breaking changes:**

1. **github_auth role interface changes:**
   - ❌ Removed parameter: `github_auth_gh_version` (was required)
   - ❌ Removed parameter: `github_auth_gh_auth_status` (was required)
   - ⚠️ External playbooks using this role must be updated

2. **github_precheck behavioral change:**
   - ❌ Changed from soft check (warnings) to hard check (fails)
   - ❌ Will halt execution if gh CLI not available
   - ⚠️ Playbooks expecting warnings only will now fail

3. **TOKEN output removal:**
   - ❌ Removed output: `github_auth_github_token`
   - ❌ Removed output: `github_auth_netrc_token`
   - ⚠️ Playbooks referencing TOKEN output will break (unlikely, as it's a secret)

### Migration Guide

For external playbooks using rstyczynski.github collection:

**Before (old interface):**
```yaml
- name: Precheck
  ansible.builtin.include_role:
    name: rstyczynski.github.github_precheck

- name: Authenticate
  ansible.builtin.include_role:
    name: rstyczynski.github.github_auth
  vars:
    github_auth_gh_version: "{{ github_precheck_gh_version }}"
    github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"
```

**After (new interface):**
```yaml
- name: Precheck (now halts on failure)
  ansible.builtin.include_role:
    name: rstyczynski.github.github_precheck

- name: Authenticate (simplified interface)
  ansible.builtin.include_role:
    name: rstyczynski.github.github_auth
  # No parameters required - precheck already verified gh CLI available
```

### Benefits of Breaking Changes

1. **Security:** TOKEN not exposed in facts or outputs
2. **Simplicity:** Fewer parameters, less coupling between roles
3. **Clarity:** Precheck fails fast with clear error message
4. **Trust:** Rely on gh CLI for authentication state management

### Version Bump Recommendation

Given breaking changes, recommend:
- **Semantic Version:** Bump from 0.1.x to 0.2.0 (minor version in 0.x series)
- **Or:** If moving to stable, bump to 1.0.0
- **galaxy.yml:** Update version and document breaking changes in CHANGELOG.md

## Recommended Design Focus Areas

1. **TOKEN Cleanup Pattern (GHC-9):**
   - Design robust fact cleanup using `ansible.builtin.set_stats` with `clear: true`
   - Use block/always pattern to ensure cleanup in all code paths
   - Verify no_log coverage on all TOKEN-handling tasks

2. **Precheck Failure Behavior (GHC-11):**
   - Design clear error messages when gh CLI missing
   - Consider whether to check gh version minimums
   - Document expected behavior in README

3. **Argument Specification Updates:**
   - Remove parameters from meta/argument_specs.yml
   - Update INPUT VARIABLES TABLEs in all affected files
   - Regenerate ansible-doc documentation

4. **Testing Coverage:**
   - Test all security scenarios (TOKEN not in output)
   - Test precheck halt behavior
   - Test simplified github_auth role
   - Test flow.yml end-to-end

5. **Documentation Updates:**
   - Update all READMEs for affected roles
   - Document breaking changes
   - Update collection README with migration guide
   - Create CHANGELOG.md entry

## Integration with Existing Implementation

### Review of Previous Sprints

**Sprint 5 (GHC-7):** Roles use argument specification at meta

- ✅ All roles already use meta/argument_specs.yml
- ✅ Sprint 6 will modify argument_specs.yml for github_auth role (remove 2 parameters)
- ✅ Pattern established in Sprint 5 makes this modification straightforward

**Sprint 4 (GHC-6):** HTML documentation generation

- ✅ Documentation framework exists with antsibull-docs
- ✅ Sprint 6 will regenerate docs after argument_specs.yml changes
- ✅ Use existing `generate_html_docs.sh` script

**Sprint 3 (GHC-4, GHC-5):** Role interface specification and documentation

- ✅ INPUT/OUTPUT VARIABLES TABLEs are in place
- ✅ Sprint 6 will update these tables to remove parameters and outputs
- ✅ ansible-doc structure already established

**Sprint 2 (GHC-3):** GitHub Collection

- ✅ Collection structure is solid (rstyczynski.github)
- ✅ flow.yml provides end-to-end test
- ✅ Sprint 6 will update flow.yml to use simplified role interface

### Compatibility Verification

All Sprint 6 changes integrate cleanly with existing implementations:
- ✅ No changes to collection structure
- ✅ No changes to role names or FQCN
- ✅ Changes limited to role parameters and outputs
- ✅ Existing test framework (flow.yml) will be updated and remain functional
- ✅ Documentation generation process unchanged (just regenerate)

## Readiness for Design Phase

**Status:** Confirmed Ready

All requirements are clear and well-understood:
- ✅ Technical approach identified for all three backlog items
- ✅ Compatibility impact assessed
- ✅ Testing strategy defined
- ✅ No blocking issues or missing information
- ✅ Previous sprint work provides solid foundation

**Recommended Next Steps:**

1. Proceed to Elaboration (Design) phase
2. Create detailed design for TOKEN cleanup mechanism (GHC-9)
3. Create detailed design for parameter removal (GHC-10, GHC-11)
4. Create detailed design for precheck halt behavior (GHC-11)
5. Design test cases for all scenarios
6. Plan documentation updates

## LLM Token Statistics

**Inception Phase Token Usage:**
- Total tokens consumed during analysis: ~65,000
- Files analyzed: 8 role files + flow.yml
- Grep searches performed: 3
- Lines of code reviewed: ~300

## Summary

Sprint 6 focuses on security and interface simplification with three well-defined backlog items:

1. **GHC-9:** Secure TOKEN handling - remove from facts and outputs
2. **GHC-10:** Remove gh_auth_status dependency - trust gh CLI
3. **GHC-11:** Make precheck halt on failure - clear error point

All items are feasible, compatibility impact is assessed, and the sprint is ready for the Design phase. Breaking changes are acceptable for security and design improvements, and a migration guide will be provided.
