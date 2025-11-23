# Sprint 6 - Design

## GHC-9: GitHub TOKEN is removed as soon as possible from facts

Status: Proposed

### Requirement Summary

Secure GitHub TOKEN handling by:
- Removing TOKEN from exposed outputs
- Keeping TOKEN in facts for minimal time only
- Ensuring no_log protects TOKEN in all tasks
- Protecting TOKEN like filesystem netrc file (600 permissions)

### Feasibility Analysis

**API Availability:**

Using Ansible builtin modules:
- ✅ `ansible.builtin.set_fact` - Documented: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html
- ✅ `no_log: true` parameter - Ansible task-level security feature
- ✅ Block/always pattern - Ansible flow control for guaranteed cleanup

**Technical Constraints:**

- Ansible facts persist throughout play execution unless explicitly removed
- `no_log: true` prevents output to console but doesn't remove from facts
- Must balance security (remove TOKEN) with debugging capability

**Risk Assessment:**

- **Low Risk:** Changes are localized to github_auth role
- **Security Benefit:** High - eliminates TOKEN exposure in outputs/logs
- **Testing Required:** Verify no_log coverage and fact cleanup effectiveness
- **Edge Case:** Ensure TOKEN cleanup on both success and failure paths

### Design Overview

**Architecture:**

Implement "use-once-and-discard" pattern for TOKEN:
1. Read TOKEN from environment or netrc (with no_log)
2. Authenticate gh CLI using TOKEN (with no_log)
3. Immediately remove TOKEN from facts (explicit cleanup)
4. Verify authentication succeeded
5. Ensure cleanup even if authentication fails (block/always)

**Key Components:**

1. **TOKEN Acquisition Phase** (no_log: true)
   - Environment variable lookup
   - .netrc file parsing
   - Fact creation with minimal scope

2. **Authentication Phase** (no_log: true)
   - gh auth login with TOKEN
   - Authentication verification

3. **Cleanup Phase** (always executed)
   - Explicit fact removal
   - Verification of cleanup

**Data Flow:**

```
Environment/netrc → [Temporary Fact with no_log] → gh CLI Authentication → Fact Removal
                                                                                ↓
                                                                          Clean state
```

### Technical Specification

**Files Modified:**

- `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/tasks/main.yml`
- `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/README.md`

**Code Changes:**

**Change 1: Update OUTPUT VARIABLES TABLE**

Remove TOKEN from documented outputs:

```yaml
# OUTPUT VARIABLES TABLE
# | name                          | type   | description                                    |
# |-------------------------------|--------|------------------------------------------------|
# | github_auth_netrc_file        | dict   | Result of checking .netrc file existence       |
# | github_auth_gh_auth_result    | dict   | Result of authenticating with GitHub CLI       |
# | github_auth_gh_auth_verify    | dict   | Result of verifying authentication             |
```

**Removed outputs:**
- ❌ `github_auth_github_token` (string) - GitHub authentication token
- ❌ `github_auth_netrc_token` (dict) - Token extracted from .netrc file

**Change 2: Add no_log to TOKEN acquisition tasks**

Lines to modify with `no_log: true`:

```yaml
- name: "Auth: Check for GitHub token in environment"
  ansible.builtin.set_fact:
    github_auth_github_token: "{{ lookup('env', 'GH_TOKEN') | default(lookup('env', 'GITHUB_TOKEN'), true) }}"
  no_log: true  # ← ADD THIS

- name: "Auth: Read .netrc file for github.com credentials"
  ansible.builtin.shell:
    cmd: |
      [existing awk command]
  register: github_auth_netrc_token
  no_log: true  # ← ADD THIS

- name: "Auth: Set token from .netrc if found"
  ansible.builtin.set_fact:
    github_auth_github_token: "{{ github_auth_netrc_token.stdout }}"
  when:
    - github_auth_github_token == ""
    - github_auth_netrc_token.stdout is defined
    - github_auth_netrc_token.stdout != ""
  no_log: true  # ← ALREADY PRESENT, KEEP IT
```

**Change 3: Fix critical security issue on line 85**

```yaml
- name: "Auth: Authenticate gh CLI with token"
  ansible.builtin.shell:
    cmd: set -o pipefail && echo "{{ github_auth_github_token }}" | gh auth login --with-token
  args:
    executable: /bin/bash
  when:
    - github_auth_gh_version.rc == 0
    - github_auth_github_token != ""
    - github_auth_gh_auth_status.rc != 0
  register: github_auth_gh_auth_result
  changed_when: github_auth_gh_auth_result.rc == 0
  no_log: true  # ← CHANGE FROM false TO true (CRITICAL SECURITY FIX)
```

**Change 4: Implement TOKEN cleanup using block/always pattern**

Wrap authentication logic in block with guaranteed cleanup:

```yaml
- name: "Auth: Secure TOKEN handling block"
  block:
    - name: "Auth: Check for GitHub token in environment"
      ansible.builtin.set_fact:
        github_auth_github_token: "{{ lookup('env', 'GH_TOKEN') | default(lookup('env', 'GITHUB_TOKEN'), true) }}"
      no_log: true

    - name: "Auth: Check if .netrc file exists"
      ansible.builtin.stat:
        path: "{{ ansible_env.HOME }}/.netrc"
      register: github_auth_netrc_file
      when: github_auth_github_token == ""

    - name: "Auth: Read .netrc file for github.com credentials"
      ansible.builtin.shell:
        cmd: |
          set -o pipefail
          awk '
            /^[[:space:]]*#/ { next }
            /^[[:space:]]*$/ { next }
            /^[[:space:]]*machine[[:space:]]+github\.com/ { in_github=1; next }
            in_github && /^[[:space:]]*machine[[:space:]]/ { in_github=0 }
            in_github && /^[[:space:]]*password[[:space:]]/ { print $2; exit }
          ' ~/.netrc
      args:
        executable: /bin/bash
      register: github_auth_netrc_token
      changed_when: false
      failed_when: false
      when:
        - github_auth_github_token == ""
        - github_auth_netrc_file.stat.exists | default(false)
      no_log: true

    - name: "Auth: Set token from .netrc if found"
      ansible.builtin.set_fact:
        github_auth_github_token: "{{ github_auth_netrc_token.stdout }}"
      when:
        - github_auth_github_token == ""
        - github_auth_netrc_token.stdout is defined
        - github_auth_netrc_token.stdout != ""
      no_log: true

    - name: "Auth: Display token source"
      ansible.builtin.debug:
        msg: "GitHub token found in environment variables"
      when: github_auth_github_token != "" and (github_auth_netrc_token.stdout is not defined or github_auth_netrc_token.stdout == "")

    - name: "Auth: Display token from netrc"
      ansible.builtin.debug:
        msg: "GitHub token found in ~/.netrc for github.com"
      when: github_auth_github_token != "" and github_auth_netrc_token.stdout is defined and github_auth_netrc_token.stdout != ""

    - name: "Auth: Warning if no token found"
      ansible.builtin.debug:
        msg: "WARNING: No GitHub token found in GH_TOKEN, GITHUB_TOKEN environment variables, or ~/.netrc"
      when: github_auth_github_token == ""

    - name: "Auth: Authenticate gh CLI with token"
      ansible.builtin.shell:
        cmd: set -o pipefail && echo "{{ github_auth_github_token }}" | gh auth login --with-token
      args:
        executable: /bin/bash
      when:
        - github_auth_gh_version.rc == 0
        - github_auth_github_token != ""
        - github_auth_gh_auth_status.rc != 0
      register: github_auth_gh_auth_result
      changed_when: github_auth_gh_auth_result.rc == 0
      no_log: true

    - name: "Auth: Verify authentication after login"
      ansible.builtin.command: gh auth status
      register: github_auth_gh_auth_verify
      changed_when: false
      failed_when: false
      when: github_auth_gh_auth_result is not skipped and github_auth_gh_auth_result.rc is defined

    - name: "Auth: Display authentication success"
      ansible.builtin.debug:
        msg: "Successfully authenticated with GitHub CLI using token"
      when: github_auth_gh_auth_verify is not skipped and github_auth_gh_auth_verify.rc == 0

  always:
    - name: "Auth: Remove TOKEN from facts (security cleanup)"
      ansible.builtin.set_fact:
        github_auth_github_token: ""
      no_log: true

    - name: "Auth: Remove netrc TOKEN from facts (security cleanup)"
      ansible.builtin.set_fact:
        github_auth_netrc_token: {}
      no_log: true
      when: github_auth_netrc_token is defined
```

**Error Handling:**

- `always` block ensures TOKEN cleanup even if authentication fails
- `no_log: true` on cleanup tasks prevents TOKEN exposure during cleanup
- Empty string (`""`) for github_auth_github_token
- Empty dict (`{}`) for github_auth_netrc_token (was registered variable)

### Implementation Approach

**Step 1:** Update OUTPUT VARIABLES TABLE documentation (remove TOKEN outputs)

**Step 2:** Add `no_log: true` to all TOKEN-handling tasks (lines 22, 30, 43, 52, 74)

**Step 3:** Fix critical security issue - change `no_log: false` to `no_log: true` on line 85

**Step 4:** Wrap entire authentication logic in block/always pattern

**Step 5:** Add TOKEN cleanup in `always` section

**Step 6:** Update github_auth role README to remove TOKEN from output variables

**Step 7:** Verify with manual testing

### Testing Strategy

**Functional Tests:**

1. **Test: Authentication with environment variable TOKEN**
   - Setup: Export GH_TOKEN or GITHUB_TOKEN
   - Execute: Run github_auth role
   - Verify: Authentication succeeds, gh CLI authenticated

2. **Test: Authentication with netrc TOKEN**
   - Setup: Remove environment tokens, configure ~/.netrc
   - Execute: Run github_auth role
   - Verify: Authentication succeeds, netrc TOKEN used

3. **Test: No TOKEN available**
   - Setup: Remove all TOKEN sources
   - Execute: Run github_auth role
   - Verify: Warning displayed, no authentication attempted

**Security Tests:**

4. **Test: TOKEN not in verbose output (-v)**
   - Execute: `ansible-playbook -v flow.yml`
   - Verify: TOKEN does not appear in output

5. **Test: TOKEN not in very verbose output (-vvv)**
   - Execute: `ansible-playbook -vvv flow.yml`
   - Verify: TOKEN does not appear in output

6. **Test: TOKEN cleaned from facts**
   - Execute: Add debug task after auth to print all facts matching 'github_auth'
   - Verify: github_auth_github_token is empty string or not present
   - Verify: github_auth_netrc_token is empty dict or not present

**Edge Cases:**

7. **Test: TOKEN cleanup on authentication failure**
   - Setup: Provide invalid TOKEN
   - Execute: Run github_auth role
   - Verify: Authentication fails BUT TOKEN still cleaned from facts

8. **Test: Idempotency when already authenticated**
   - Execute: Run github_auth role twice
   - Verify: Second run skips auth, no TOKEN exposure

**Success Criteria:**

- ✅ All functional tests pass
- ✅ TOKEN never appears in -v, -vv, -vvv output
- ✅ TOKEN removed from facts after authentication
- ✅ Cleanup happens even on failure
- ✅ No breaking changes to role functionality

### Integration Notes

**Dependencies:**

- No dependencies on other GHC-9, GHC-10, GHC-11 items
- Can be implemented and tested independently

**Compatibility:**

- ⚠️ **Breaking Change:** TOKEN outputs removed
  - Impact: External playbooks referencing `github_auth_github_token` will break
  - Likelihood: Low (TOKEN is a secret, shouldn't be referenced)
  - Mitigation: Document in CHANGELOG, provide migration note

- ✅ **No breaking changes:** To role input parameters
- ✅ **No breaking changes:** To role invocation method

**Reusability:**

- Block/always pattern can be template for other sensitive data handling
- no_log strategy establishes pattern for future security enhancements

### Documentation Requirements

**User Documentation (README.md):**

- Remove `github_auth_github_token` from OUTPUT VARIABLES section
- Remove `github_auth_netrc_token` from OUTPUT VARIABLES section
- Add security note: "GitHub TOKEN is never exposed in role outputs or facts. It is used once for authentication and immediately removed."
- Add section: "Security Considerations"

**Technical Documentation:**

- Document block/always pattern for TOKEN cleanup
- Document no_log usage on all TOKEN-handling tasks
- Note that TOKEN cleanup uses empty string ("") for fact variable

**CHANGELOG.md entry:**

```markdown
## [0.2.0] - 2025-11-23

### Security
- **[BREAKING]** Removed `github_auth_github_token` output variable for security
- **[BREAKING]** Removed `github_auth_netrc_token` output variable for security
- Added `no_log: true` to all TOKEN-handling tasks
- Implemented automatic TOKEN cleanup from facts after authentication
- Fixed critical security issue: Changed `no_log: false` to `no_log: true` on gh auth login task

### Migration
- If your playbook referenced `github_auth_github_token`, remove these references (TOKEN should not be stored or reused)
```

### Design Decisions

**Decision 1: Use block/always pattern instead of handlers**

**Rationale:**
- Handlers run at end of play, TOKEN would persist longer
- block/always guarantees immediate cleanup
- Works even when task fails

**Alternatives Considered:**
- Handlers: Rejected - delayed execution
- Manual cleanup after each task: Rejected - error-prone, could miss paths

**Decision 2: Clean TOKEN with empty string vs undefined**

**Rationale:**
- Empty string (`""`) is safer than undefined
- Prevents "variable undefined" errors in edge cases
- Preserves fact existence for debugging (shows it was cleaned)

**Alternatives Considered:**
- `omit` special variable: Rejected - doesn't remove fact
- Delete fact entirely: Not supported in Ansible set_fact

**Decision 3: Keep github_auth_netrc_file output, remove github_auth_netrc_token**

**Rationale:**
- github_auth_netrc_file is stat result (no sensitive data)
- github_auth_netrc_token contains TOKEN in .stdout (sensitive)
- Selective removal balances security and debugging

### Open Design Questions

None - Design is complete and ready for implementation.

---

## GHC-10: gh assumes authentication is in place

Status: Proposed

### Requirement Summary

Remove explicit usage of `github_precheck_gh_auth_status` variable:
- gh CLI handles authentication failures internally with clear error messages
- Variable may exist in precheck outputs but roles should not explicitly use it
- Simplify role interface by removing unnecessary parameter dependency

### Feasibility Analysis

**API Availability:**

- ✅ gh CLI: Provides built-in authentication state management
- ✅ gh CLI: Returns clear error messages when not authenticated
- ✅ Ansible: Parameter removal from argument_specs.yml is standard practice

**Technical Constraints:**

- Must update argument specification (meta/argument_specs.yml)
- Must update all role invocations (flow.yml)
- gh CLI behavior is well-defined and reliable

**Risk Assessment:**

- **Low Risk:** Simplifies code, reduces coupling
- **Benefit:** Clearer separation of concerns (precheck vs auth)
- **Testing:** Verify gh CLI errors are user-friendly

### Design Overview

**Architecture:**

Remove authentication status checking from github_auth role:
1. Remove `github_auth_gh_auth_status` parameter from argument_specs.yml
2. Remove condition checking `github_auth_gh_auth_status.rc != 0`
3. Simplify logic: Always attempt gh auth login if TOKEN exists
4. Trust gh CLI to skip if already authenticated
5. Update flow.yml to not pass parameter

**Key Components:**

1. **Argument Specification Update**
   - Remove `github_auth_gh_auth_status` from meta/argument_specs.yml
   - Remove from INPUT VARIABLES TABLE

2. **Task Logic Simplification**
   - Remove `github_auth_gh_auth_status.rc != 0` condition from line 82
   - gh CLI will handle authentication state internally

3. **Flow.yml Update**
   - Remove line 65: `github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"`

**Data Flow:**

```
Before:
precheck → gh_auth_status output → github_auth input → condition check → gh auth login

After:
[no dependency] → github_auth → gh auth login (gh CLI decides if needed)
```

### Technical Specification

**Files Modified:**

1. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/meta/argument_specs.yml`
2. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/tasks/main.yml`
3. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/README.md`
4. `github_collection/flow.yml`

**Code Changes:**

**Change 1: Remove from meta/argument_specs.yml**

Remove this entire option block:

```yaml
# DELETE THIS:
      github_auth_gh_auth_status:
        description: "GitHub CLI authentication status"
        type: dict
        required: true
```

**Change 2: Update INPUT VARIABLES TABLE in tasks/main.yml**

Remove from documentation:

```yaml
# INPUT VARIABLES TABLE
# | name                        | type   | description                                 |
# |-----------------------------|--------|---------------------------------------------|
# | github_auth_gh_version       | dict   | GitHub CLI version check result             |
# DELETE THIS LINE: | github_auth_gh_auth_status   | dict   | GitHub CLI authentication status             |
```

**Change 3: Simplify authentication logic in tasks/main.yml**

Remove `github_auth_gh_auth_status.rc != 0` condition:

```yaml
# BEFORE (line ~80):
- name: "Auth: Authenticate gh CLI with token"
  ansible.builtin.shell:
    cmd: set -o pipefail && echo "{{ github_auth_github_token }}" | gh auth login --with-token
  when:
    - github_auth_gh_version.rc == 0
    - github_auth_github_token != ""
    - github_auth_gh_auth_status.rc != 0  # ← REMOVE THIS LINE
  register: github_auth_gh_auth_result
  changed_when: github_auth_gh_auth_result.rc == 0
  no_log: true

# AFTER:
- name: "Auth: Authenticate gh CLI with token"
  ansible.builtin.shell:
    cmd: set -o pipefail && echo "{{ github_auth_github_token }}" | gh auth login --with-token
  when:
    - github_auth_gh_version.rc == 0
    - github_auth_github_token != ""
    # gh CLI will skip if already authenticated
  register: github_auth_gh_auth_result
  changed_when: github_auth_gh_auth_result.rc == 0
  no_log: true
```

**Change 4: Update flow.yml**

Remove parameter passing:

```yaml
# BEFORE (line ~60):
- name: Authenticate GitHub CLI
  ansible.builtin.include_role:
    name: rstyczynski.github.github_auth
  vars:
    github_auth_gh_version: "{{ github_precheck_gh_version }}"
    github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"  # ← REMOVE THIS LINE

# AFTER:
- name: Authenticate GitHub CLI
  ansible.builtin.include_role:
    name: rstyczynski.github.github_auth
  vars:
    github_auth_gh_version: "{{ github_precheck_gh_version }}"
    # gh CLI manages authentication state internally
```

**Change 5: Update README.md**

Remove from INPUT VARIABLES section:

```markdown
## Input Variables

| Name | Type | Required | Description |
|------|------|----------|-------------|
| github_auth_gh_version | dict | yes | GitHub CLI version check result |
DELETE THIS ROW: | github_auth_gh_auth_status | dict | yes | GitHub CLI authentication status |
```

Add note:

```markdown
## Authentication Behavior

The role attempts to authenticate if a TOKEN is found. The gh CLI will automatically skip authentication if already logged in, making explicit status checking unnecessary.
```

**Error Handling:**

- gh CLI provides clear error messages when authentication fails
- No error handling changes needed - rely on gh CLI's built-in handling

### Implementation Approach

**Step 1:** Remove `github_auth_gh_auth_status` from meta/argument_specs.yml

**Step 2:** Remove `github_auth_gh_auth_status` from INPUT VARIABLES TABLE (tasks/main.yml)

**Step 3:** Remove `github_auth_gh_auth_status.rc != 0` condition from authentication task

**Step 4:** Remove `github_auth_gh_auth_status` parameter from flow.yml invocation

**Step 5:** Update github_auth README.md to remove parameter and add behavior note

**Step 6:** Test with gh CLI in various states (authenticated, not authenticated)

### Testing Strategy

**Functional Tests:**

1. **Test: gh CLI already authenticated**
   - Setup: Run `gh auth login` manually first
   - Execute: Run github_auth role
   - Verify: Role succeeds, gh CLI remains authenticated

2. **Test: gh CLI not authenticated**
   - Setup: Run `gh auth logout` manually first
   - Execute: Run github_auth role with valid TOKEN
   - Verify: Role succeeds, gh CLI becomes authenticated

3. **Test: gh CLI not authenticated, no TOKEN**
   - Setup: Run `gh auth logout`, remove TOKEN sources
   - Execute: Run github_auth role
   - Verify: Role displays warning, gh CLI remains unauthenticated

**Idempotency Tests:**

4. **Test: Run role twice when already authenticated**
   - Execute: Run github_auth role
   - Execute: Run github_auth role again
   - Verify: Second run succeeds, no changes reported

**Error Handling Tests:**

5. **Test: Invalid TOKEN**
   - Setup: Provide invalid TOKEN
   - Execute: Run github_auth role
   - Verify: gh CLI error message displayed clearly

**Success Criteria:**

- ✅ Role works when gh already authenticated
- ✅ Role works when gh not authenticated
- ✅ gh CLI errors are clear and actionable
- ✅ No dependency on precheck gh_auth_status

### Integration Notes

**Dependencies:**

- Related to GHC-11 (both remove precheck output dependencies)
- Can be implemented in same commit or separately

**Compatibility:**

- ⚠️ **Breaking Change:** github_auth role interface changes
  - Removed required parameter: `github_auth_gh_auth_status`
  - Impact: External playbooks must remove this parameter
  - Mitigation: Document in CHANGELOG

- ✅ **Benefit:** Simpler interface, less coupling

**Reusability:**

- Pattern demonstrates trusting tool's internal state management
- Reduces boilerplate parameter passing

### Documentation Requirements

**User Documentation (README.md):**

- Remove `github_auth_gh_auth_status` from input parameters
- Add "Authentication Behavior" section explaining gh CLI state management
- Provide migration example (before/after)

**CHANGELOG.md entry:**

```markdown
## [0.2.0] - 2025-11-23

### Changed
- **[BREAKING]** Removed `github_auth_gh_auth_status` required parameter from github_auth role
- Simplified authentication logic to trust gh CLI's internal state management
- gh CLI now determines if authentication is needed (will skip if already authenticated)

### Migration
- Remove `github_auth_gh_auth_status` parameter from github_auth role invocations
- Example:
  ```yaml
  # Before:
  vars:
    github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"

  # After:
  vars:
    # Parameter removed - gh CLI manages state
  ```
```

### Design Decisions

**Decision 1: Trust gh CLI state management**

**Rationale:**
- gh CLI is designed to handle authentication state
- Provides clear, user-friendly error messages
- Reduces Ansible role complexity

**Alternatives Considered:**
- Keep status check: Rejected - unnecessary coupling
- Add our own check: Rejected - duplicates gh CLI's functionality

**Decision 2: Remove required parameter vs make optional**

**Rationale:**
- Making optional still encourages misuse
- Clean break is clearer for migration
- Forces playbook authors to review their auth logic

**Alternatives Considered:**
- Make parameter optional: Rejected - encourages continued use
- Deprecate then remove: Rejected - project is version 0.1, acceptable to break

### Open Design Questions

None - Design is complete and ready for implementation.

---

## GHC-11: Precheck role halts task flow in case of missing dependencies

Status: Proposed

### Requirement Summary

Make precheck role halt execution when dependencies are missing:
- Precheck purpose: Halt with error, not expose variables for use
- Remove all instances where other roles use precheck outputs (e.g., `github_auth_gh_version`)
- Provide clear error messages when gh CLI not available

### Feasibility Analysis

**API Availability:**

- ✅ Ansible `failed_when` parameter: Controls task failure behavior
- ✅ Ansible `assert` module: Provides clear failure messages
- ✅ gh CLI: Returns non-zero exit code when not installed

**Technical Constraints:**

- Current precheck uses `failed_when: false` (soft check)
- Must change to `failed_when` omitted or explicit condition (hard check)
- Must update github_auth role to not depend on precheck outputs

**Risk Assessment:**

- **Medium Risk:** Behavioral change from warning to halting
- **Benefit:** Clear failure point, fail fast principle
- **User Impact:** Better UX - immediate clear error vs delayed cryptic error

### Design Overview

**Architecture:**

Transform precheck from soft check (warnings) to hard check (halts):

1. **Precheck role changes:**
   - Remove `failed_when: false` from gh CLI check
   - Add clear error message using `assert` module
   - Keep output variables for debugging but don't expose as interface

2. **github_auth role changes:**
   - Remove `github_auth_gh_version` parameter from argument_specs.yml
   - Remove conditions checking `github_auth_gh_version.rc == 0`
   - Assume gh CLI is available (precheck already verified)

3. **flow.yml changes:**
   - Remove `github_auth_gh_version` parameter passing

**Key Components:**

1. **Precheck Dependency Verification (Hard Check)**
   - git: Already checks with failure (no `failed_when: false`)
   - gh CLI: Remove `failed_when: false` → will halt if missing

2. **github_auth Parameter Simplification**
   - Remove `github_auth_gh_version` from interface
   - Simplify authentication logic

3. **Clear Error Messages**
   - Use `ansible.builtin.assert` for better error formatting

**Data Flow:**

```
Before:
precheck (soft) → gh_version output → github_auth input → condition check
                     ↓ warning if missing

After:
precheck (hard) → [HALT if gh CLI missing with clear error]
                ↓ only continues if gh available
              github_auth (assumes gh available)
```

### Technical Specification

**Files Modified:**

1. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_precheck/tasks/main.yml`
2. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_precheck/README.md`
3. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/meta/argument_specs.yml`
4. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/tasks/main.yml`
5. `github_collection/collections/ansible_collections/rstyczynski/github/roles/github_auth/README.md`
6. `github_collection/flow.yml`

**Code Changes:**

**Change 1: Modify github_precheck/tasks/main.yml**

Remove `failed_when: false` and add clear error message:

```yaml
# BEFORE (line ~22):
- name: "Precheck: Check if gh CLI is available"
  ansible.builtin.command: gh --version
  register: github_precheck_gh_version
  changed_when: false
  failed_when: false  # ← REMOVE THIS LINE

- name: "Precheck: Display gh CLI version"
  ansible.builtin.debug:
    msg: "Using {{ github_precheck_gh_version.stdout }}"
  when: github_precheck_gh_version.rc == 0

# ... warnings at end ...

- name: "Precheck: Warning if gh CLI is not installed"
  ansible.builtin.debug:
    msg: "WARNING: GitHub CLI (gh) is not installed. PR creation will fail. Install: https://cli.github.com/"
  when: github_precheck_gh_version.rc != 0  # ← REMOVE THIS WARNING

# AFTER:
- name: "Precheck: Check if gh CLI is available"
  ansible.builtin.command: gh --version
  register: github_precheck_gh_version
  changed_when: false
  # failed_when removed - will fail if gh not found

- name: "Precheck: Display gh CLI version"
  ansible.builtin.debug:
    msg: "Using {{ github_precheck_gh_version.stdout }}"

- name: "Precheck: Verify gh CLI is installed"
  ansible.builtin.assert:
    that:
      - github_precheck_gh_version.rc == 0
    fail_msg: |
      GitHub CLI (gh) is not installed or not in PATH.

      The rstyczynski.github collection requires gh CLI for GitHub operations.

      Install gh CLI: https://cli.github.com/

      Installation methods:
        - macOS: brew install gh
        - Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
        - Windows: choco install gh
    success_msg: "GitHub CLI (gh) is available: {{ github_precheck_gh_version.stdout }}"
```

**Change 2: Update github_precheck/README.md**

Document behavioral change:

```markdown
## Behavior

This role performs **hard checks** that will **halt execution** if dependencies are missing.

### Checks Performed

1. **git** - Halts if not installed
2. **gh CLI** - Halts if not installed
3. **gh authentication** (optional) - Checks status but does not halt

### Rationale

The precheck role follows the "fail fast" principle:
- If critical dependencies are missing, execution halts immediately with clear error message
- Better UX than delayed, cryptic errors during actual GitHub operations
- Output variables are for debugging only - other roles should not depend on them

### Installation Help

If precheck fails with gh CLI missing, install from: https://cli.github.com/
```

**Change 3: Remove github_auth_gh_version from github_auth role**

**meta/argument_specs.yml:**

```yaml
# DELETE THIS ENTIRE BLOCK:
      github_auth_gh_version:
        description: "GitHub CLI version check result"
        type: dict
        required: true
```

**tasks/main.yml INPUT VARIABLES TABLE:**

```yaml
# INPUT VARIABLES TABLE
# | name                        | type   | description                                 |
# |-----------------------------|--------|---------------------------------------------|
# DELETE THIS LINE: | github_auth_gh_version       | dict   | GitHub CLI version check result             |
```

**tasks/main.yml authentication task:**

```yaml
# BEFORE (line ~80):
- name: "Auth: Authenticate gh CLI with token"
  ansible.builtin.shell:
    cmd: set -o pipefail && echo "{{ github_auth_github_token }}" | gh auth login --with-token
  when:
    - github_auth_gh_version.rc == 0  # ← REMOVE THIS LINE
    - github_auth_github_token != ""
    - github_auth_gh_auth_status.rc != 0
  register: github_auth_gh_auth_result
  changed_when: github_auth_gh_auth_result.rc == 0
  no_log: true

# AFTER:
- name: "Auth: Authenticate gh CLI with token"
  ansible.builtin.shell:
    cmd: set -o pipefail && echo "{{ github_auth_github_token }}" | gh auth login --with-token
  when:
    - github_auth_github_token != ""
    # Precheck already verified gh CLI is available
  register: github_auth_gh_auth_result
  changed_when: github_auth_gh_auth_result.rc == 0
  no_log: true
```

**Change 4: Update flow.yml**

```yaml
# BEFORE (line ~60):
- name: Authenticate GitHub CLI
  ansible.builtin.include_role:
    name: rstyczynski.github.github_auth
  vars:
    github_auth_gh_version: "{{ github_precheck_gh_version }}"  # ← REMOVE THIS LINE
    github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"

# AFTER:
- name: Authenticate GitHub CLI
  ansible.builtin.include_role:
    name: rstyczynski.github.github_auth
  # No parameters needed - precheck already verified dependencies
```

**Change 5: Update github_auth/README.md**

Remove parameter:

```markdown
## Input Variables

| Name | Type | Required | Description |
|------|------|----------|-------------|
DELETE THIS ROW: | github_auth_gh_version | dict | yes | GitHub CLI version check result |
```

Add note:

```markdown
## Prerequisites

This role requires:
- GitHub CLI (gh) installed and in PATH
- Run the `rstyczynski.github.github_precheck` role first to verify dependencies

The precheck role will halt execution with a clear error message if gh CLI is not available.
```

**Error Handling:**

- `ansible.builtin.assert` provides multi-line, formatted error messages
- Error includes installation instructions for common platforms
- Clear distinction between "dependency missing" (precheck fails) vs "authentication failed" (auth role handles)

### Implementation Approach

**Step 1:** Modify github_precheck to remove `failed_when: false`

**Step 2:** Add `ansible.builtin.assert` for clear error message in precheck

**Step 3:** Remove github_auth_gh_version parameter from github_auth meta/argument_specs.yml

**Step 4:** Remove github_auth_gh_version from github_auth INPUT VARIABLES TABLE

**Step 5:** Remove `github_auth_gh_version.rc == 0` condition from github_auth tasks

**Step 6:** Remove parameter passing from flow.yml

**Step 7:** Update both README files to document new behavior

**Step 8:** Test with gh CLI present and absent

### Testing Strategy

**Positive Tests:**

1. **Test: Precheck succeeds with gh CLI installed**
   - Setup: Ensure gh and git installed
   - Execute: Run github_precheck role
   - Verify: Role succeeds, displays versions

2. **Test: Full flow with dependencies present**
   - Execute: Run complete flow.yml
   - Verify: All roles succeed, no errors

**Negative Tests:**

3. **Test: Precheck halts when gh CLI missing**
   - Setup: Temporarily rename/remove gh from PATH
   - Execute: Run github_precheck role
   - Verify: Role FAILS with clear error message including installation instructions
   - Verify: Error message mentions gh CLI not found

4. **Test: github_auth assumes gh available (after precheck)**
   - Setup: Ensure gh CLI installed
   - Execute: Run github_auth role (without precheck - direct invocation)
   - Verify: Role attempts to use gh CLI, relies on gh's error handling if actually missing

**Integration Tests:**

5. **Test: flow.yml halts at precheck when gh missing**
   - Setup: Remove gh CLI from PATH
   - Execute: Run flow.yml
   - Verify: Execution halts at precheck step with clear error
   - Verify: github_auth never executes

**Success Criteria:**

- ✅ Precheck halts execution if gh CLI missing
- ✅ Error message is clear and actionable
- ✅ Error message includes installation instructions
- ✅ github_auth role works without gh_version parameter
- ✅ flow.yml simplified (fewer parameters)

### Integration Notes

**Dependencies:**

- Related to GHC-10 (both modify github_auth parameters)
- Should be implemented in coordinated fashion
- Both changes simplify github_auth interface

**Compatibility:**

- ⚠️ **Breaking Change #1:** github_precheck behavioral change
  - From: Soft check (warnings)
  - To: Hard check (halts execution)
  - Impact: Playbooks expecting warnings will now fail
  - Benefit: Better UX - fail fast with clear message

- ⚠️ **Breaking Change #2:** github_auth interface change
  - Removed required parameter: `github_auth_gh_version`
  - Impact: External playbooks must remove this parameter
  - Mitigation: Document in CHANGELOG

**Reusability:**

- Assert pattern can be used for other dependency checks
- Fail-fast principle improves overall collection UX

### Documentation Requirements

**User Documentation:**

**github_precheck/README.md:**
- Add "Behavior" section explaining hard check (halts)
- Document that output variables are for debugging only
- Explain fail-fast principle

**github_auth/README.md:**
- Remove `github_auth_gh_version` from parameters
- Add "Prerequisites" section requiring precheck
- Document simplified interface

**Collection README:**
- Add section on dependency verification
- Explain precheck as required first step
- Document behavioral change in version upgrade

**CHANGELOG.md entry:**

```markdown
## [0.2.0] - 2025-11-23

### Changed
- **[BREAKING]** github_precheck now HALTS execution if gh CLI is not installed (previously warned only)
- **[BREAKING]** Removed `github_auth_gh_version` required parameter from github_auth role
- Precheck provides clear error messages with installation instructions when dependencies missing
- Simplified github_auth role interface (no longer depends on precheck outputs)

### Added
- Clear, formatted error messages in github_precheck with installation instructions
- "Fail fast" principle: Dependencies verified immediately at precheck stage

### Migration
- **Behavioral Change:** Playbooks that relied on precheck warnings (without halting) will now fail
  - Mitigation: Ensure gh CLI is installed before running collection roles
  - Install: https://cli.github.com/

- **Interface Change:** Remove `github_auth_gh_version` parameter
  ```yaml
  # Before:
  - include_role:
      name: rstyczynski.github.github_auth
    vars:
      github_auth_gh_version: "{{ github_precheck_gh_version }}"

  # After:
  - include_role:
      name: rstyczynski.github.github_auth
    # Parameter removed - precheck already verified gh CLI
  ```
```

### Design Decisions

**Decision 1: Use hard check (halt) instead of soft check (warn)**

**Rationale:**
- Aligns with GHC-11 requirement: "halts task flow"
- Better UX: Immediate clear error vs delayed cryptic gh error
- Follows "fail fast" principle
- Prevents wasted execution time on doomed tasks

**Alternatives Considered:**
- Keep soft check: Rejected - violates requirement
- Make configurable: Rejected - adds complexity, unclear value

**Decision 2: Use assert instead of fail_when condition**

**Rationale:**
- `assert` allows multi-line formatted error messages
- Can provide installation instructions inline
- More user-friendly than bare task failure

**Alternatives Considered:**
- `failed_when` with custom condition: Rejected - less readable error
- `fail` module: Considered equivalent to `assert`, chose assert for semantics

**Decision 3: Remove parameter dependency completely vs make optional**

**Rationale:**
- Complete removal is cleaner break
- Forces playbook authors to update (good for breaking changes)
- Simpler role interface going forward

**Alternatives Considered:**
- Make parameter optional with default: Rejected - perpetuates coupling
- Deprecate first: Rejected - project is 0.x, acceptable to break cleanly

### Open Design Questions

None - Design is complete and ready for implementation.

---

# Design Summary

## Overall Architecture

Sprint 6 implements three coordinated security and interface improvements:

1. **GHC-9:** Secure TOKEN handling - No exposure, immediate cleanup
2. **GHC-10 & GHC-11:** Interface simplification - Remove precheck output dependencies

These changes work together to:
- Improve security posture (TOKEN handling)
- Reduce coupling between roles (remove dependencies)
- Simplify collection interface (fewer parameters)
- Improve UX (fail fast with clear errors)

## Shared Components

All three backlog items modify the **github_auth** role:
- GHC-9: Adds TOKEN security measures
- GHC-10: Removes gh_auth_status parameter
- GHC-11: Removes gh_version parameter

**Integration Strategy:**
- All changes to github_auth can be made in single commit
- Coordinate testing across all three items
- Single argument_specs.yml update removes both parameters

## Design Risks

**Risk 1: Breaking Changes in 0.1 Version**

- **Severity:** Low
- **Impact:** External playbooks must be updated
- **Mitigation:**
  - Comprehensive CHANGELOG documentation
  - Migration guide with before/after examples
  - Benefits (security, simplicity) outweigh migration cost
  - Version bump to 0.2.0 signals breaking changes

**Risk 2: TOKEN Cleanup on All Code Paths**

- **Severity:** Medium
- **Impact:** If cleanup fails, TOKEN could leak
- **Mitigation:**
  - block/always pattern guarantees cleanup
  - Tested in both success and failure scenarios
  - no_log on cleanup tasks prevents exposure during cleanup

**Risk 3: Precheck Behavioral Change**

- **Severity:** Low
- **Impact:** Playbooks expecting warnings will halt
- **Mitigation:**
  - Clear error messages guide users to resolution
  - Fail-fast is better UX than delayed failures
  - Documents alignment with requirement

## Resource Requirements

**Tools:**
- Existing Ansible and gh CLI (no new tools)
- ansible-lint for validation

**Testing:**
- flow.yml (existing end-to-end test)
- Manual testing with various gh CLI states
- Security testing with verbose flags

**Documentation:**
- Update 2 role READMEs (github_auth, github_precheck)
- Update collection README
- Create/update CHANGELOG.md

## Design Approval Status

**Status:** Proposed

**Ready for Review:** Yes

All three backlog items have:
- ✅ Complete feasibility analysis
- ✅ Detailed technical specifications
- ✅ Testing strategies defined
- ✅ Integration points identified
- ✅ Documentation requirements listed
- ✅ No open design questions

**Awaiting:** Product Owner approval to proceed to Construction phase
