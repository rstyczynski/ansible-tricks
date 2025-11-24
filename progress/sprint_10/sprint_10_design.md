# Sprint 10 - Design

## CR-1: repo_commit's message argument is mandatory

Status: Accepted

### Requirement Summary
Simplify the `repo_commit` role by making the commit message mandatory and removing the fallback mechanism that auto-generates messages from file paths.

### Feasibility Analysis

**API Availability:**
- Ansible builtin modules: `validate_argument_spec`, `command`, `set_fact`, `debug` - all available
- Git command: `git commit -m "message"` - standard git functionality
- No external API dependencies

**Technical Constraints:**
- Breaking change: Playbooks must provide explicit commit messages
- Requires HTML documentation regeneration

**Risk Assessment:**
- Risk 1: Breaking change for existing playbooks
  - **Mitigation**: Document in implementation notes and README; low impact as fallback was impractical
- Risk 2: HTML documentation generation may fail
  - **Mitigation**: Reuse tested `generate_html_docs.sh` script from Sprint 4

### Design Overview

**Architecture:**
Simplified role interface with mandatory commit_message parameter. Removes conditional logic and fallback behavior.

**Key Components:**
1. Argument validation (existing, modified)
2. Git status check (existing, unchanged)
3. Git commit execution (existing, simplified)
4. Status display (existing, unchanged)

**Data Flow:**
```
Input: repo_commit_commit_message (required)
       repo_commit_dest_path (required)
  ↓
Validate arguments
  ↓
Check git status
  ↓
Commit with provided message
  ↓
Output: repo_commit_git_status
        repo_commit_git_commit_result
```

### Technical Specification

**Files Modified:**

1. `roles/repo_commit/meta/argument_specs.yml`
   - Change `repo_commit_commit_message.required: false` → `true`
   - Remove `repo_commit_file_path` parameter
   - Remove `repo_commit_final_message` output attribute
   - Keep `repo_commit_commit_result` output attribute

2. `roles/repo_commit/tasks/main.yml`
   - Remove task: "Commit: Set commit message" (lines 26-33)
   - Update commit task to use `{{ repo_commit_commit_message }}` directly
   - Update INPUT/OUTPUT variable tables

3. `roles/repo_commit/README.md`
   - Remove documentation for `repo_commit_file_path`
   - Update `repo_commit_commit_message` to show as required
   - Remove `repo_commit_final_message` from outputs
   - Add migration note for users relying on fallback

4. `github_collection/collections/ansible_collections/rstyczynski/github/docs/html/`
   - Regenerate using `generate_html_docs.sh`

**APIs Used:**
- `ansible.builtin.validate_argument_spec` - Validates required parameters
- `ansible.builtin.command` with `git commit -m` - Creates commit

**Data Structures:**
```yaml
# Input
repo_commit_dest_path: "/path/to/repo"  # required, type: path
repo_commit_commit_message: "message"   # required, type: str

# Output
repo_commit_git_status:                 # dict with git status info
  stdout: "M file.txt"
  rc: 0
repo_commit_git_commit_result:          # dict with commit result
  stdout: "[branch abc123] message"
  rc: 0
```

**Error Handling:**
- Missing `commit_message`: validate_argument_spec will fail with clear error
- Empty git status: Commit task skipped (idempotent behavior)
- Git commit failure: Task fails with git error message

### Implementation Approach

**Step 1:** Update argument_specs.yml
- Set repo_commit_commit_message required: true
- Remove repo_commit_file_path definition
- Remove repo_commit_final_message from outputs

**Step 2:** Update tasks/main.yml
- Remove "Commit: Set commit message" task (lines 26-33)
- Change line 37 from `"{{ repo_commit_final_commit_message }}"` to `"{{ repo_commit_commit_message }}"`
- Update INPUT VARIABLES TABLE (remove file_path line)
- Update OUTPUT VARIABLES TABLE (remove final_commit_message line)

**Step 3:** Update README.md
- Document commit_message as required
- Remove file_path from parameters section
- Add breaking change note

**Step 4:** Regenerate HTML documentation
```bash
cd github_collection
./generate_html_docs.sh
```

**Step 5:** Update github_pr_flow.yml
- Verify it provides commit_message (line 45: ✓ already provides it)
- No changes needed

### Testing Strategy

**Functional Tests:**

Test 1: Verify role fails when commit_message not provided
```yaml
# Should fail validation
- include_role:
    name: rstyczynski.github.repo_commit
  vars:
    repo_commit_dest_path: "./test_repo"
    # commit_message omitted - should fail
```

Test 2: Verify successful commit with valid message
```yaml
# Should succeed
- include_role:
    name: rstyczynski.github.repo_commit
  vars:
    repo_commit_dest_path: "./test_repo"
    repo_commit_commit_message: "test: verify mandatory message"
```

Test 3: Verify github_pr_flow.yml works end-to-end
```bash
# Run complete workflow
ansible-playbook github_pr_flow.yml
```

Test 4: Verify documentation updates
- Check README.md shows commit_message as required
- Check HTML docs generated successfully
- Verify ansible-doc output

**Edge Cases:**

Edge 1: Empty string for commit_message
- Expectation: Git will reject; task fails with error

Edge 2: Very long commit message
- Expectation: Git accepts; no length validation in role

Edge 3: No staged changes
- Expectation: Commit task skipped (when condition); idempotent

**Success Criteria:**
- ✓ validate_argument_spec fails when commit_message missing
- ✓ Commit succeeds when message provided
- ✓ github_pr_flow.yml runs successfully
- ✓ README and HTML docs updated
- ✓ ansible-doc shows correct interface

### Integration Notes

**Dependencies:**
- None - self-contained change to repo_commit role

**Compatibility:**
- **Breaking Change**: Users must now provide commit_message
- Impact: Any playbook omitting commit_message will fail validation
- Migration: Add explicit commit_message to all repo_commit invocations

**Reusability:**
- github_pr_flow.yml already compatible (provides commit_message)
- Pattern established: Required parameters should be truly required

### Documentation Requirements

**User Documentation:**
- Update README.md with required parameter notation
- Add "Breaking Changes" section noting mandatory commit_message
- Provide migration example

**Technical Documentation:**
- Update argument_specs.yml comments
- Update ansible-doc format strings
- Regenerate HTML documentation

### Design Decisions

**Decision 1:** Remove fallback completely vs make it configurable
**Rationale:** Fallback was never practical; explicit messages are better practice
**Alternatives Considered:**
- Make fallback opt-in with additional parameter (adds complexity)
- Keep fallback but emit warning (doesn't simplify code)
**Chosen:** Complete removal for simplicity

**Decision 2:** Regenerate HTML docs vs manual update
**Rationale:** Automated generation ensures consistency and correctness
**Alternatives Considered:**
- Manual HTML edit (error-prone, hard to maintain)
**Chosen:** Use generate_html_docs.sh script

### Open Design Questions

None - design is straightforward and complete.

---

## CR-2: pr_create returns pr number

Status: Accepted

### Requirement Summary
Enhance the `pr_create` role to return the PR number as an output attribute, eliminating the need for callers to perform a separate lookup.

### Feasibility Analysis

**API Availability:**
- `gh pr create` - Returns URL like "https://github.com/owner/repo/pull/123"
- `gh pr view --json number --jq '.number'` - Returns just the number
- Both commands available in gh CLI (version verified by github_precheck)

**Technical Constraints:**
- Must handle both new PR creation and existing PR scenarios
- PR number extraction must be reliable

**Risk Assessment:**
- Risk 1: PR number extraction from gh pr create output
  - **Mitigation**: Use `gh pr view` query immediately after creation for reliability
- Risk 2: Integer conversion for pr_number output
  - **Mitigation**: Use `| int` filter to ensure proper type

### Design Overview

**Architecture:**
Enhanced pr_create role that captures and exposes PR number for both existing and newly created PRs.

**Key Components:**
1. Existing PR detection (existing, enhanced with output)
2. New PR creation (existing, enhanced with output)
3. PR number extraction (new)
4. Output attribute (new)

**Data Flow:**
```
Input: pr_create_dest_path, pr_create_base_branch, pr_create_pr_title, pr_create_pr_body
  ↓
Check for existing PR (already returns number if exists)
  ↓
If exists:
  Set pr_create_pr_number = existing number
  ↓
If not exists:
  Create PR → Query for PR number → Set pr_create_pr_number
  ↓
Output: pr_create_pr_number (int)
```

### Technical Specification

**Files Modified:**

1. `roles/pr_create/meta/argument_specs.yml`
   - Add new output attribute:
     ```yaml
     pr_create_pr_number:
       description: "[OUTPUT] PR number (existing or newly created)"
       type: int
       required: false
     ```

2. `roles/pr_create/tasks/main.yml`
   - After line 56 (existing PR found), add:
     ```yaml
     - name: "PR Create: Set PR number for existing PR"
       ansible.builtin.set_fact:
         pr_create_pr_number: "{{ pr_create_existing_pr.stdout | int }}"
       when: pr_create_existing_pr.stdout != ""
     ```
   - After line 90 (new PR created), add:
     ```yaml
     - name: "PR Create: Get PR number for newly created PR"
       ansible.builtin.command:
         cmd: gh pr view --json number --jq '.number'
         chdir: "{{ pr_create_dest_path }}"
       register: pr_create_new_pr_number
       changed_when: false
       when: pr_create_pr_create_result is not skipped

     - name: "PR Create: Set PR number for new PR"
       ansible.builtin.set_fact:
         pr_create_pr_number: "{{ pr_create_new_pr_number.stdout | int }}"
       when: pr_create_pr_create_result is not skipped
     ```
   - Update OUTPUT VARIABLES TABLE to include pr_create_pr_number

3. `roles/pr_create/README.md`
   - Add `pr_create_pr_number` to Outputs section
   - Add usage example showing how to use the output

4. `github_collection/github_pr_flow.yml`
   - Remove lines 124-135 (PR number lookup tasks)
   - Update line 174 (pr_comment_barrier invocation) to use:
     ```yaml
     pr_comment_barrier_issue_number: "{{ pr_create_pr_number }}"
     ```

5. Regenerate HTML documentation

**APIs Used:**
- `gh pr list --head BRANCH --json number --jq '.[0].number'` - Check existing PR
- `gh pr create --base BASE --head HEAD --title TITLE --body BODY` - Create PR
- `gh pr view --json number --jq '.number'` - Get PR number

**Data Structures:**
```yaml
# Output (new)
pr_create_pr_number: 123  # int, PR number for existing or new PR

# Existing outputs (unchanged)
pr_create_existing_pr:
  stdout: "123" or ""
pr_create_pr_create_result:
  stdout: "https://github.com/owner/repo/pull/123"
```

**Error Handling:**
- PR number query fails: Task will fail with gh error
- Type conversion fails: Ansible will fail with clear error
- No PR exists and creation fails: pr_create_pr_number will not be set

### Implementation Approach

**Step 1:** Update argument_specs.yml
- Add pr_create_pr_number output attribute definition

**Step 2:** Update tasks/main.yml
- Add "Set PR number for existing PR" task after existing PR check
- Add "Get PR number for newly created PR" task after PR creation
- Add "Set PR number for new PR" task after query
- Update OUTPUT VARIABLES TABLE

**Step 3:** Update README.md
- Add pr_create_pr_number to outputs section
- Add example:
  ```yaml
  - include_role: name: rstyczynski.github.pr_create
  - debug: msg="PR number is {{ pr_create_pr_number }}"
  ```

**Step 4:** Update github_pr_flow.yml
- Remove PR number lookup tasks (lines 124-135)
- Update pr_comment_barrier to use pr_create_pr_number

**Step 5:** Regenerate HTML documentation

### Testing Strategy

**Functional Tests:**

Test 1: Create new PR and capture number
```bash
# Setup: Create test branch with changes
# Action: Run pr_create role
# Verify: pr_create_pr_number is set and matches actual PR
# Cleanup: Close PR
```

Test 2: Use existing PR and capture number
```bash
# Setup: Create PR manually
# Action: Run pr_create role again
# Verify: pr_create_pr_number matches existing PR number
# Cleanup: Close PR
```

Test 3: Verify github_pr_flow.yml works without lookup tasks
```bash
# Run complete workflow
ansible-playbook github_pr_flow.yml
# Verify: No errors, PR barrier uses correct number
```

Test 4: Verify output type is integer
```bash
# Check that pr_create_pr_number can be used in arithmetic
# {{ pr_create_pr_number + 0 }} should work
```

**Edge Cases:**

Edge 1: Multiple PRs from same branch
- Expectation: Returns first PR (existing behavior)

Edge 2: PR created but immediate query fails
- Expectation: Task fails; needs retry in playbook

Edge 3: Existing PR found
- Expectation: pr_create_pr_number set from pr_create_existing_pr

**Success Criteria:**
- ✓ New PR creation sets pr_create_pr_number
- ✓ Existing PR detection sets pr_create_pr_number
- ✓ Output type is integer
- ✓ github_pr_flow.yml works without extra lookup
- ✓ Documentation updated

### Integration Notes

**Dependencies:**
- None - enhancement to existing pr_create role

**Compatibility:**
- **Additive Change**: New output attribute
- Impact: Existing playbooks continue to work
- Benefit: New playbooks can use pr_create_pr_number directly

**Reusability:**
- github_pr_flow.yml simplified by removing duplicate lookup
- Pattern: Roles should expose all useful outputs

### Documentation Requirements

**User Documentation:**
- Add pr_create_pr_number to README outputs section
- Provide example usage in README
- Note that both new and existing PRs return the number

**Technical Documentation:**
- Add pr_create_pr_number to argument_specs.yml
- Update ansible-doc format
- Regenerate HTML docs

### Design Decisions

**Decision 1:** Parse URL from gh pr create vs Query with gh pr view
**Rationale:** `gh pr view` is more robust and consistent than URL parsing
**Alternatives Considered:**
- Regex parse URL from create output (fragile, depends on format)
**Chosen:** Query with `gh pr view --json number` after creation

**Decision 2:** Return as string vs integer
**Rationale:** Integer type is more semantically correct and enables arithmetic
**Alternatives Considered:**
- String type (would require conversion by users)
**Chosen:** Integer type using `| int` filter

**Decision 3:** Set pr_number for both existing and new PRs
**Rationale:** Consistent output regardless of PR state
**Alternatives Considered:**
- Only set for new PRs (inconsistent, requires conditional logic in callers)
**Chosen:** Always set pr_create_pr_number when role succeeds

### Open Design Questions

None - design is complete and feasible.

---

## CR-3: PR status check roles get all arguments via variables

Status: Accepted

### Requirement Summary
Modify `pr_status_check_pause` role to accept `dest_path` as an explicit parameter and pass it to `pr_status_check`, eliminating the need for the top-level playbook to set this via set_fact.

### Feasibility Analysis

**API Availability:**
- Ansible `include_role` with `vars:` - Standard Ansible functionality
- Variable scoping is well-defined in Ansible

**Technical Constraints:**
- Two roles involved: pr_status_check_pause and pr_status_check
- Must ensure proper variable passing through role inclusion

**Risk Assessment:**
- Risk 1: Variable scoping issues
  - **Mitigation**: Use explicit `vars:` section when including pr_status_check
- Risk 2: Breaking change for role interface
  - **Mitigation**: Document in README; change improves clarity

### Design Overview

**Architecture:**
Explicit parameter passing through role chain. pr_status_check_pause accepts dest_path and passes it to pr_status_check.

**Key Components:**
1. pr_status_check_pause argument specification (modified)
2. pr_status_check inclusion with vars (modified)
3. github_pr_flow.yml role invocation (modified)

**Data Flow:**
```
github_pr_flow.yml
  ↓ (passes pr_status_check_pause_dest_path)
pr_status_check_pause role
  ↓ (passes pr_status_check_dest_path via vars)
pr_status_check role
  ↓
Uses dest_path for git and gh commands
```

### Technical Specification

**Files Modified:**

1. `roles/pr_status_check_pause/meta/argument_specs.yml`
   - Add new input parameter:
     ```yaml
     pr_status_check_pause_dest_path:
       description: "Destination path to the git repository"
       type: path
       required: true
     ```

2. `roles/pr_status_check_pause/tasks/main.yml`
   - Update pr_status_check inclusion (around line 18):
     ```yaml
     - name: "PR Check: Check PR status"
       ansible.builtin.include_role:
         name: rstyczynski.github.pr_status_check
       vars:
         pr_status_check_dest_path: "{{ pr_status_check_pause_dest_path }}"
     ```
   - Update INPUT VARIABLES TABLE to include dest_path

3. `roles/pr_status_check_pause/README.md`
   - Add `pr_status_check_pause_dest_path` to Arguments section

4. `github_collection/github_pr_flow.yml`
   - Remove lines 137-139 (set_fact for pr_status_check_dest_path)
   - Update pr_status_check_pause invocation (around line 147):
     ```yaml
     vars:
       pr_status_check_pause_pr_status_check_delay: "{{ arg_pr_status_check_delay }}"
       pr_status_check_pause_pr_status_check_retries: "{{ arg_pr_status_check_retries }}"
       pr_status_check_pause_has_pending_checks: "{{ pr_status_check_has_pending_checks | default(false) }}"
       pr_status_check_pause_attempt_number: "{{ attempt_number }}"
       pr_status_check_pause_dest_path: "{{ arg_dest_path }}"  # NEW
     ```

5. Regenerate HTML documentation

**APIs Used:**
- `ansible.builtin.include_role` with `vars:` - Role inclusion with variable passing

**Data Structures:**
```yaml
# Input to pr_status_check_pause (new)
pr_status_check_pause_dest_path: "/path/to/repo"  # path, required

# Passed to pr_status_check
pr_status_check_dest_path: "/path/to/repo"  # path, required
```

**Error Handling:**
- Missing dest_path: validate_argument_spec fails in pr_status_check_pause
- Invalid path: Git commands in pr_status_check will fail

### Implementation Approach

**Step 1:** Update pr_status_check_pause/meta/argument_specs.yml
- Add pr_status_check_pause_dest_path input parameter

**Step 2:** Update pr_status_check_pause/tasks/main.yml
- Add `vars:` section to include_role task
- Pass pr_status_check_dest_path explicitly
- Update INPUT VARIABLES TABLE

**Step 3:** Update pr_status_check_pause/README.md
- Document new dest_path parameter

**Step 4:** Update github_pr_flow.yml
- Remove set_fact task for pr_status_check_dest_path
- Add dest_path to pr_status_check_pause vars

**Step 5:** Regenerate HTML documentation

### Testing Strategy

**Functional Tests:**

Test 1: Verify pr_status_check_pause passes dest_path correctly
```yaml
# Call pr_status_check_pause with explicit dest_path
# Verify pr_status_check receives and uses it correctly
```

Test 2: Verify github_pr_flow.yml works without set_fact
```bash
# Run complete workflow
ansible-playbook github_pr_flow.yml
# Verify: PR status checks succeed
```

Test 3: Verify role fails when dest_path not provided
```yaml
# Should fail validation
- include_role:
    name: rstyczynski.github.pr_status_check_pause
  vars:
    # dest_path omitted - should fail
    pr_status_check_pause_pr_status_check_delay: 5
```

Test 4: Verify standalone pr_status_check still works
```yaml
# Direct call to pr_status_check (not via pause role)
- include_role:
    name: rstyczynski.github.pr_status_check
  vars:
    pr_status_check_dest_path: "./github_lab"
```

**Edge Cases:**

Edge 1: Invalid dest_path provided
- Expectation: Git commands fail with "not a git repository"

Edge 2: Relative vs absolute paths
- Expectation: Both work (git handles both)

Edge 3: pr_status_check called directly (not via pause)
- Expectation: Still works if dest_path provided directly

**Success Criteria:**
- ✓ pr_status_check_pause accepts dest_path parameter
- ✓ Variable passed correctly to pr_status_check
- ✓ github_pr_flow.yml works without set_fact
- ✓ Validation fails when dest_path missing
- ✓ Documentation updated

### Integration Notes

**Dependencies:**
- Internal dependency: pr_status_check_pause includes pr_status_check

**Compatibility:**
- **Breaking Change**: pr_status_check_pause now requires dest_path
- Impact: Any direct callers must provide dest_path
- Benefit: Explicit dependencies, clearer interface

**Reusability:**
- Both roles can be called independently with their required parameters
- Pattern: Wrapper roles explicitly pass parameters to included roles

### Documentation Requirements

**User Documentation:**
- Update pr_status_check_pause README with new parameter
- Note that dest_path is required
- Provide example usage

**Technical Documentation:**
- Update argument_specs.yml for pr_status_check_pause
- Update ansible-doc format
- Regenerate HTML docs

### Design Decisions

**Decision 1:** Add parameter to pr_status_check_pause vs keep set_fact in playbook
**Rationale:** Explicit parameters make role dependencies clear and self-documenting
**Alternatives Considered:**
- Keep set_fact approach (doesn't improve interface)
- Use Ansible magic variables (implicit, hard to understand)
**Chosen:** Explicit parameter with vars passing

**Decision 2:** Pass via vars vs rely on variable inheritance
**Rationale:** Explicit `vars:` section is clearer and more maintainable
**Alternatives Considered:**
- Rely on play-scope variables (implicit, fragile)
**Chosen:** Explicit vars section in include_role

### Open Design Questions

None - design is straightforward and follows Ansible best practices.

---

## CR-4: Prefix all playbook arguments with arg_

Status: Accepted

### Requirement Summary
Standardize all input arguments in `github_pr_flow.yml` by prefixing them with `arg_` for consistency. Some variables already have this prefix (e.g., `arg_pr_comment_barrier_*`), but most do not.

### Feasibility Analysis

**API Availability:**
- Pure Ansible variable renaming - no external dependencies

**Technical Constraints:**
- Must update all variable references throughout the playbook
- Variable renaming must be complete and consistent

**Risk Assessment:**
- Risk 1: Missed variable reference
  - **Mitigation**: Ansible will fail on undefined variable; thorough search
- Risk 2: Breaking playbook functionality
  - **Mitigation**: Comprehensive end-to-end testing

### Design Overview

**Architecture:**
Consistent variable naming convention with `arg_` prefix for all playbook inputs.

**Key Components:**
1. Variable declarations in vars section (modified)
2. Variable references in role invocations (modified)
3. Variable references in when conditions (modified)

**Data Flow:**
No change to data flow - purely a naming convention change.

### Technical Specification

**Files Modified:**

1. `github_collection/github_pr_flow.yml`

**Variable Renamings:**
```yaml
# OLD → NEW
repo_url → arg_repo_url
dest_path → arg_dest_path
base_branch → arg_base_branch
new_branch → arg_new_branch
push_new_branch → arg_push_new_branch
file_source → arg_file_source
file_path → arg_file_path
commit_message → arg_commit_message
pr_title → arg_pr_title
pr_body → arg_pr_body
pr_comment → arg_pr_comment
# Already prefixed: arg_pr_comment_barrier_patterns, arg_pr_comment_barrier_timeout, etc.
pr_status_check_retries → arg_pr_status_check_retries
pr_status_check_delay → arg_pr_status_check_delay
pr_merge → arg_pr_merge
pr_merge_method → arg_pr_merge_method
pr_pull_latest → arg_pr_pull_latest
branch_delete → arg_branch_delete
delete_branch → arg_delete_branch
```

**Specific Changes:**

Lines 38-60 (vars section):
```yaml
vars:
  arg_repo_url: "https://github.com/rstyczynski/github_lab.git"
  arg_dest_path: "./github_lab"
  arg_base_branch: "main"
  arg_new_branch: "test-collection-e2e-final"
  arg_push_new_branch: true
  arg_file_source: "./1.trigger"
  arg_file_path: "1.trigger"
  arg_commit_message: "test: verify ansible collection workflow"
  arg_pr_title: "Test Collection Workflow"
  arg_pr_body: "Automated test to verify rstyczynski.github collection end-to-end workflow"
  arg_pr_comment: "/approved"
  arg_pr_comment_barrier_patterns:
    - "/approved"
  arg_pr_comment_barrier_timeout: 300
  arg_pr_comment_barrier_interval: 5
  arg_pr_comment_barrier_latest_only: true
  arg_pr_status_check_retries: 6
  arg_pr_status_check_delay: 5
  arg_pr_merge: true
  arg_pr_merge_method: "merge"
  arg_pr_pull_latest: true
  arg_branch_delete: true
  arg_delete_branch: "test-collection-e2e-final"
```

Lines 79-82 (repo_clone vars):
```yaml
vars:
  repo_clone_repo_url: "{{ arg_repo_url }}"
  repo_clone_dest_path: "{{ arg_dest_path }}"
  repo_clone_base_branch: "{{ arg_base_branch }}"
  repo_clone_new_branch: "{{ arg_new_branch }}"
```

Lines 88-91 (branch_checkout vars):
```yaml
vars:
  branch_checkout_new_branch: "{{ arg_new_branch }}"
  branch_checkout_dest_path: "{{ arg_dest_path }}"
  branch_checkout_base_branch: "{{ arg_base_branch }}"
  branch_checkout_push_new_branch: "{{ arg_push_new_branch }}"
```

Lines 97-99 (repo_file_add vars):
```yaml
vars:
  repo_file_add_file_source: "{{ arg_file_source }}"
  repo_file_add_file_path: "{{ arg_file_path }}"
  repo_file_add_dest_path: "{{ arg_dest_path }}"
```

Lines 104-106 (repo_commit vars):
```yaml
vars:
  repo_commit_dest_path: "{{ arg_dest_path }}"
  repo_commit_commit_message: "{{ arg_commit_message }}"
```

Note: repo_commit_file_path removed per CR-1

Lines 111-112 (branch_push vars):
```yaml
vars:
  branch_push_dest_path: "{{ arg_dest_path }}"
```

Lines 118-121 (pr_create vars):
```yaml
vars:
  pr_create_dest_path: "{{ arg_dest_path }}"
  pr_create_base_branch: "{{ arg_base_branch }}"
  pr_create_pr_title: "{{ arg_pr_title }}"
  pr_create_pr_body: "{{ arg_pr_body }}"
```

Lines 165-167 (pr_comment vars):
```yaml
vars:
  pr_comment_pr_comment: "{{ arg_pr_comment }}"
  pr_comment_dest_path: "{{ arg_dest_path }}"
```

Lines 172-178 (pr_comment_barrier vars):
```yaml
vars:
  pr_comment_barrier_repo: "{{ arg_repo_url | regex_replace('https://github.com/', '') | regex_replace('\\.git$', '') }}"
  pr_comment_barrier_issue_number: "{{ pr_create_pr_number }}"  # From CR-2
  pr_comment_barrier_patterns: "{{ arg_pr_comment_barrier_patterns }}"
  pr_comment_barrier_timeout: "{{ arg_pr_comment_barrier_timeout }}"
  pr_comment_barrier_interval: "{{ arg_pr_comment_barrier_interval }}"
  pr_comment_barrier_latest_only: "{{ arg_pr_comment_barrier_latest_only }}"
```

Lines 183-185 (pr_merge vars):
```yaml
vars:
  pr_merge_dest_path: "{{ arg_dest_path }}"
  pr_merge_pr_merge_method: "{{ arg_pr_merge_method }}"
when: arg_pr_merge is defined and arg_pr_merge | bool
```

Lines 190-192 (branch_switch vars):
```yaml
vars:
  branch_switch_dest_path: "{{ arg_dest_path }}"
  branch_switch_switch_to_branch: "{{ arg_base_branch }}"
when: arg_pr_merge is defined and arg_pr_merge | bool
```

Lines 197-199 (branch_pull vars):
```yaml
vars:
  branch_pull_dest_path: "{{ arg_dest_path }}"
when:
  - arg_pr_pull_latest is defined and arg_pr_pull_latest | bool
  - arg_pr_merge is defined and arg_pr_merge | bool
```

Lines 206-211 (branch_delete vars):
```yaml
vars:
  branch_delete_dest_path: "{{ arg_dest_path }}"
  branch_delete_delete_branch: "{{ arg_delete_branch }}"
  branch_delete_new_branch: "{{ arg_new_branch }}"
  branch_delete_base_branch: "{{ arg_base_branch }}"
when:
  - arg_branch_delete is defined and arg_branch_delete | bool
  - arg_pr_merge is defined and arg_pr_merge | bool
```

Lines 146-152 (pr_status_check_pause loop vars):
```yaml
vars:
  pr_status_check_pause_pr_status_check_delay: "{{ arg_pr_status_check_delay }}"
  pr_status_check_pause_pr_status_check_retries: "{{ arg_pr_status_check_retries }}"
  pr_status_check_pause_has_pending_checks: "{{ pr_status_check_has_pending_checks | default(false) }}"
  pr_status_check_pause_attempt_number: "{{ attempt_number }}"
  pr_status_check_pause_dest_path: "{{ arg_dest_path }}"  # From CR-3
```

Lines 157-159 (fail task when condition):
```yaml
msg: >-
  PR status checks did not complete within
  {{ arg_pr_status_check_retries * arg_pr_status_check_delay }} seconds
  ({{ arg_pr_status_check_retries }} attempts)
```

Lines 2-28 (INPUT VARIABLES TABLE):
Update all variable names in comment table to use arg_ prefix

**APIs Used:**
None - pure variable renaming

**Data Structures:**
No change - same data, different variable names

**Error Handling:**
Undefined variable errors will be caught by Ansible during playbook parsing/execution

### Implementation Approach

**Step 1:** Update vars section (lines 37-60)
- Add arg_ prefix to all variable names

**Step 2:** Update all variable references in role vars sections
- Search for `"{{ repo_url }}"` → `"{{ arg_repo_url }}"`
- Repeat for all renamed variables

**Step 3:** Update all when conditions
- Search for `repo_url is defined` → `arg_repo_url is defined`
- Search for `repo_url | bool` → `arg_repo_url | bool`
- Repeat for all renamed variables

**Step 4:** Update INPUT VARIABLES TABLE comment
- Replace all variable names in table with arg_ prefixed versions

**Step 5:** Test playbook execution
```bash
ansible-playbook github_pr_flow.yml
```

### Testing Strategy

**Functional Tests:**

Test 1: Verify playbook syntax
```bash
ansible-playbook --syntax-check github_pr_flow.yml
```

Test 2: Run complete workflow
```bash
ansible-playbook github_pr_flow.yml
# Verify: All tasks succeed, no undefined variable errors
```

Test 3: Verify conditional logic works
```bash
# Check that when conditions evaluate correctly
# Verify pr_merge, pr_pull_latest, branch_delete conditions work
```

Test 4: Verify variable substitution in role vars
```bash
# Ensure all role invocations receive correct values
# Check with ansible-playbook -vv for variable expansion
```

**Edge Cases:**

Edge 1: Boolean variables in when conditions
- Verify `arg_pr_merge | bool` works correctly

Edge 2: Variables used in multiple places
- Verify `arg_dest_path` is correctly passed to all 10+ roles

Edge 3: Variables used in calculations
- Verify `arg_pr_status_check_retries * arg_pr_status_check_delay` works

**Success Criteria:**
- ✓ Playbook syntax check passes
- ✓ Complete workflow executes successfully
- ✓ All roles receive correct variable values
- ✓ Conditional logic works correctly
- ✓ No undefined variable errors

### Integration Notes

**Dependencies:**
- Depends on CR-1 (repo_commit changes)
- Depends on CR-2 (pr_create PR number output)
- Depends on CR-3 (pr_status_check_pause dest_path parameter)

**Compatibility:**
- Internal change only to github_pr_flow.yml
- No impact on collection roles
- No impact on other playbooks

**Reusability:**
- Establishes consistent pattern for playbook variable naming
- Makes playbook inputs clearly identifiable

### Documentation Requirements

**User Documentation:**
- No external documentation needed (internal test playbook)
- INPUT VARIABLES TABLE in playbook header serves as documentation

**Technical Documentation:**
- Comments in playbook are self-documenting

### Design Decisions

**Decision 1:** Prefix all inputs vs only some
**Rationale:** Consistency is more valuable than partial adherence
**Alternatives Considered:**
- Only prefix user-facing variables (inconsistent)
- Use different prefix for internal vs external (complex)
**Chosen:** Prefix all playbook input arguments uniformly

**Decision 2:** Keep arg_ prefix for intermediate variables
**Rationale:** Only prefix playbook inputs; role outputs and internal vars unchanged
**Alternatives Considered:**
- Prefix all variables in playbook (clutters internal variables)
**Chosen:** Only prefix input arguments defined in vars section

### Open Design Questions

None - straightforward find-and-replace with verification.

---

# Design Summary

## Overall Architecture

Sprint 10 implements 4 independent improvements that together enhance code quality:

1. **CR-1**: Simplified role interface (repo_commit)
2. **CR-2**: Enhanced role output (pr_create)
3. **CR-3**: Explicit parameter passing (pr_status_check_pause)
4. **CR-4**: Consistent naming convention (github_pr_flow.yml)

## Shared Components

- HTML documentation generation (reused from Sprint 4)
- github_pr_flow.yml test playbook (updated for all CRs)
- Argument specification pattern (used consistently)

## Design Risks

**Overall Risk: Low**

All changes are straightforward improvements to existing, working code:
- CR-1: Simple removal of unused code
- CR-2: Clear API enhancement
- CR-3: Standard Ansible pattern
- CR-4: Systematic variable renaming

**Mitigation:**
- Comprehensive functional testing
- End-to-end workflow validation
- HTML documentation regeneration

## Resource Requirements

**Tools:**
- Ansible (already installed)
- GitHub CLI (already installed)
- antsibull-docs (already installed from Sprint 4)

**Libraries:**
None - uses existing Ansible built-in modules

**External Services:**
- GitHub API (via gh CLI)
- Git operations (via git command)

## Design Approval Status

**Status: Accepted** (YOLO Mode Auto-Approved)

All designs are complete, feasible, and follow established patterns. Ready for Construction phase.

## YOLO Mode Design Decisions

### Decision 1: PR Number Extraction Method (CR-2)
**Context**: Two options for getting PR number after creation
**Decision Made**: Use `gh pr view` query after creation
**Rationale**: More robust than URL parsing; consistent with existing code
**Alternatives Considered**: Regex parse URL (fragile)
**Risk**: Low - well-defined API behavior

### Decision 2: Variable Passing Strategy (CR-3)
**Context**: How to pass dest_path through role chain
**Decision Made**: Explicit `vars:` section in include_role
**Rationale**: Clear, maintainable, follows Ansible best practices
**Alternatives Considered**: Rely on variable inheritance (implicit)
**Risk**: Low - standard Ansible pattern

### Decision 3: Breaking Change Acceptance (CR-1, CR-3)
**Context**: Changes break backward compatibility
**Decision Made**: Accept breaking changes, document clearly
**Rationale**: Improvements outweigh compatibility concerns; clean interfaces
**Alternatives Considered**: Keep deprecated interfaces (technical debt)
**Risk**: Medium - users must update, but documented

### Decision 4: Documentation Regeneration (All CRs)
**Context**: HTML docs need updating
**Decision Made**: Use generate_html_docs.sh script
**Rationale**: Automated, tested in Sprint 4, ensures consistency
**Alternatives Considered**: Manual updates (error-prone)
**Risk**: Low - proven approach
