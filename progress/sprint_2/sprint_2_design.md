# Sprint 2 - Design

## GHC-3: GitHub Collection

Status: Proposed

### Requirement Summary

Transform 16 validated task-sets from ./github_task-sets into Ansible Collection (rstyczynski.github) with proper role structure, updated validation patterns, and modified workflow orchestration.

**Deliverables:**
1. Collection structure with 16 roles
2. Updated flow.yml using roles
3. Collection configuration (galaxy.yml, runtime.yml)
4. Role documentation (16 README.md files)
5. Collection README.md
6. Functional tests

### Feasibility Analysis

**API Availability:**

- ✅ ansible-galaxy collection init (Collection creation)
- ✅ ansible.builtin.validate_argument_spec (Validation pattern)
- ✅ ansible.builtin.include_role (Role invocation)
- ✅ FQCN support (Collection namespace)

All required Ansible features are available and well-documented.

**Technical Constraints:**

- Must maintain backward compatibility (workflow behavior)
- Must preserve idempotency from task-sets
- Must follow Ansible Best Practices for Collections
- Local development only (no Galaxy publishing)

**Risk Assessment:**

- **Risk: Repetitive transformation errors** - Medium
  - Mitigation: Use templates, systematic approach, incremental testing

- **Risk: validate_argument_spec syntax errors** - Low
  - Mitigation: Test each role individually, follow documented patterns

- **Risk: Collection path resolution issues** - Low
  - Mitigation: Proper directory structure, ansible.cfg configuration

**Overall Risk:** Low to Medium - Well-defined transformation with clear patterns

### Design Overview

**Architecture:**

1. **Collection Structure**: Standard Ansible Galaxy collection layout
2. **Role Design**: One role per task-set (1:1 mapping)
3. **Validation Upgrade**: ansible.builtin.validate_argument_spec with inline specs
4. **Workflow Update**: flow.yml uses include_role with FQCN
5. **Local Development**: Collections in ./collections/ansible_collections/

**Key Components:**

1. **Collection Configuration**:
   - galaxy.yml (metadata)
   - meta/runtime.yml (Ansible version requirements)
   - README.md (Collection documentation)

2. **16 Roles** (one per task-set):
   - defaults/main.yml (optional variable defaults)
   - tasks/main.yml (task logic from task-set)
   - meta/main.yml (role metadata)
   - README.md (role documentation)

3. **Workflow Orchestration**:
   - flow.yml (updated for role invocation)
   - ansible.cfg (optional - collections path)
   - 1.trigger (test file - unchanged)

**Data Flow:**

```
flow.yml → include_role (FQCN) → Collection role → tasks → GitHub operations
```

### Technical Specification

#### Collection Initialization

**Command:**
```bash
cd github_collection
ansible-galaxy collection init rstyczynski.github --init-path collections/ansible_collections
```

**Directory Structure Created:**
```
collections/ansible_collections/rstyczynski/github/
├── docs/
├── galaxy.yml
├── meta/
│   └── runtime.yml
├── plugins/
│   └── README.md
├── README.md
└── roles/
```

#### galaxy.yml Configuration

```yaml
namespace: rstyczynski
name: github
version: 1.0.0
readme: README.md
authors:
  - rstyczynski <rstyczynski@users.noreply.github.com>
description: Ansible Collection for GitHub operations using gh CLI
license:
  - MIT
repository: https://github.com/rstyczynski/ansible-tricks
documentation: https://github.com/rstyczynski/ansible-tricks/tree/master/github_collection
issues: https://github.com/rstyczynski/ansible-tricks/issues
tags:
  - github
  - git
  - gh
  - cli
  - api
dependencies: {}
```

#### meta/runtime.yml Configuration

```yaml
---
requires_ansible: '>=2.9'
```

#### Role Structure Template

**For each role (example: repo_clone):**

**roles/repo_clone/defaults/main.yml:**
```yaml
---
# No required variable defaults
# Optional variables only
```

**roles/repo_clone/tasks/main.yml:**
```yaml
---
# INPUT VARIABLES TABLE
# | name                      | type   | description                                 |
# |---------------------------|--------|---------------------------------------------|
# | repo_clone_repo_url       | string | Repository URL to clone                     |
# | repo_clone_dest_path      | string | Destination path for the repository          |
# | repo_clone_base_branch    | string | Base branch name                             |
# | repo_clone_new_branch     | string | New branch name                              |
#
# OUTPUT VARIABLES TABLE
# | name                          | type   | description                                    |
# |-------------------------------|--------|------------------------------------------------|
# | repo_clone_repo_exists       | dict   | Result of checking if repository exists        |
# | repo_clone_git_result        | dict   | Result of git clone/update operation          |
# | repo_clone_current_branch     | dict   | Current active branch name                     |
# | repo_clone_remote_branch_check| dict   | Result of checking if branch is pushed         |

- name: "Clone: Validate arguments"
  ansible.builtin.validate_argument_spec:
    argument_spec:
      repo_clone_repo_url:
        type: str
        required: true
        description: Repository URL to clone
      repo_clone_dest_path:
        type: str
        required: true
        description: Destination path for the repository
      repo_clone_base_branch:
        type: str
        required: true
        description: Base branch name
      repo_clone_new_branch:
        type: str
        required: true
        description: New branch name

# [Rest of tasks from repo_clone.yml - identical logic]
```

**roles/repo_clone/meta/main.yml:**
```yaml
---
galaxy_info:
  author: rstyczynski
  description: Clone and manage GitHub repositories
  company: Personal
  license: MIT
  min_ansible_version: "2.9"
  platforms:
    - name: MacOSX
      versions:
        - all
  galaxy_tags:
    - github
    - git
    - clone
dependencies: []
```

**roles/repo_clone/README.md:**
```markdown
# rstyczynski.github.repo_clone

Clone and manage GitHub repositories with proper branch handling.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `repo_clone_repo_url` (string): Repository URL to clone
- `repo_clone_dest_path` (string): Destination path for the repository
- `repo_clone_base_branch` (string): Base branch name
- `repo_clone_new_branch` (string): New branch name

### Output Variables

- `repo_clone_repo_exists` (dict): Result of checking if repository exists
- `repo_clone_git_result` (dict): Result of git clone/update operation
- `repo_clone_current_branch` (dict): Current active branch name
- `repo_clone_remote_branch_check` (dict): Result of checking if branch is pushed

## Dependencies

None

## Example Playbook

\`\`\`yaml
- hosts: localhost
  tasks:
    - name: Clone repository
      ansible.builtin.include_role:
        name: rstyczynski.github.repo_clone
      vars:
        repo_clone_repo_url: "https://github.com/user/repo.git"
        repo_clone_dest_path: "./repo"
        repo_clone_base_branch: "main"
        repo_clone_new_branch: "feature"
\`\`\`

## License

MIT

## Author

rstyczynski
```

#### validate_argument_spec Patterns

**String Variable:**
```yaml
variable_name:
  type: str
  required: true
  description: Description text
```

**Boolean Variable:**
```yaml
variable_name:
  type: bool
  required: false
  default: true
  description: Description text
```

**Integer Variable:**
```yaml
variable_name:
  type: int
  required: false
  default: 5
  description: Description text
```

**Dict Variable (registered result):**
```yaml
variable_name:
  type: dict
  required: true
  description: Description text
```

#### flow.yml Transformation

**From (current):**
```yaml
- name: Clone Repository
  ansible.builtin.import_tasks: repo_clone.yml
  vars:
    repo_clone_repo_url: "{{ repo_url }}"
    repo_clone_dest_path: "{{ dest_path }}"
    repo_clone_base_branch: "{{ base_branch }}"
    repo_clone_new_branch: "{{ new_branch }}"
```

**To (Collection):**
```yaml
- name: Clone Repository
  ansible.builtin.include_role:
    name: rstyczynski.github.repo_clone
  vars:
    repo_clone_repo_url: "{{ repo_url }}"
    repo_clone_dest_path: "{{ dest_path }}"
    repo_clone_base_branch: "{{ base_branch }}"
    repo_clone_new_branch: "{{ new_branch }}"
```

**Key Changes:**
- `import_tasks` → `include_role`
- File reference → FQCN (rstyczynski.github.<role_name>)
- Variable passing unchanged (vars: block)

#### ansible.cfg Configuration

**Optional file for local development:**
```ini
[defaults]
collections_path = ./collections

[inventory]
localhost ansible_connection=local
```

### Implementation Approach

**Phase 1: Collection Initialization (Steps 1-3)**

**Step 1:** Create directory structure
```bash
mkdir -p github_collection
cd github_collection
mkdir -p collections
```

**Step 2:** Initialize Collection
```bash
ansible-galaxy collection init rstyczynski.github \
  --init-path collections/ansible_collections
```

**Step 3:** Configure Collection
- Update galaxy.yml with project details
- Configure meta/runtime.yml
- Create Collection README.md

**Phase 2: Role Transformation (Steps 4-6)**

**Step 4:** Create role structure for each task-set
```bash
cd collections/ansible_collections/rstyczynski/github
mkdir -p roles/{role_name}/{defaults,tasks,meta}
```

**Step 5:** Transform task-set to role (repeat for all 16)
- Copy tasks from task-set to roles/<name>/tasks/main.yml
- Update validation (assert → validate_argument_spec)
- Create defaults/main.yml (empty or with optional defaults)
- Create meta/main.yml with galaxy_info
- Create README.md with role documentation

**Step 6:** Verify role structure
```bash
# Check each role has required files
for role in roles/*; do
  ls $role/{defaults,tasks,meta}/main.yml
  ls $role/README.md
done
```

**Phase 3: Workflow Update (Steps 7-8)**

**Step 7:** Copy and update flow.yml
```bash
cp ../../../github_task-sets/flow.yml .
```

**Step 8:** Transform all import_tasks to include_role
- Replace 16 import_tasks statements
- Update to FQCN format
- Maintain variable passing
- Test syntax

**Phase 4: Configuration (Steps 9-10)**

**Step 9:** Create ansible.cfg (optional)
```ini
[defaults]
collections_path = ./collections
```

**Step 10:** Copy test files
```bash
cp ../../../github_task-sets/1.trigger .
```

**Phase 5: Testing (Step 11)**

**Step 11:** Execute functional tests
```bash
# Test 1: Syntax check
ansible-playbook flow.yml --syntax-check

# Test 2: Functional test
ansible-playbook flow.yml

# Test 3: Idempotency test
ansible-playbook flow.yml  # Run twice, verify no changes
```

### Testing Strategy

**Functional Tests:**

1. **Syntax Validation**:
   - Purpose: Verify YAML and Ansible syntax
   - Command: `ansible-playbook flow.yml --syntax-check`
   - Expected: No syntax errors

2. **End-to-End Workflow**:
   - Purpose: Verify full GitHub workflow with Collection
   - Command: `ansible-playbook flow.yml`
   - Expected: Workflow completes successfully, PR created and merged

3. **Idempotency Verification**:
   - Purpose: Verify no changes on second run
   - Command: Run flow.yml twice
   - Expected: First run makes changes, second run shows all "ok"

4. **Timeout Scenario**:
   - Purpose: Test PR status check timeout handling
   - Setup: Adjust timeout values to force timeout
   - Expected: Graceful handling, can re-execute

5. **Role Isolation Test**:
   - Purpose: Verify individual role functionality
   - Command: Create simple playbook calling one role
   - Expected: Role executes independently

**Edge Cases:**

1. **Repository Already Exists**: Verify update logic works
2. **Branch Already Created**: Verify checkout logic works
3. **PR Already Exists**: Verify duplicate prevention
4. **Authentication Failure**: Verify error handling

**Success Criteria:**

- ✅ Collection structure created correctly
- ✅ All 16 roles have complete structure (4 files each)
- ✅ flow.yml uses include_role with FQCN
- ✅ Syntax check passes
- ✅ Functional test completes successfully
- ✅ Idempotency maintained
- ✅ No regression in functionality

### Integration Notes

**Dependencies:**

- Sprint 1 validated task-sets (source material)
- ansible-galaxy (Collection init)
- github_lab repository (testing)
- ~/.netrc authentication (unchanged)

**Compatibility:**

- Maintains workflow behavior from task-sets
- Preserves variable naming conventions
- Keeps idempotency patterns
- Compatible with existing github_lab test setup

**Reusability:**

- Each role is independent and reusable
- Collection can be used in other playbooks
- Role documentation enables standalone usage
- FQCN allows clear identification

### Documentation Requirements

**Collection Documentation:**

File: `collections/ansible_collections/rstyczynski/github/README.md`

Content:
- Collection overview and purpose
- Installation instructions (local path)
- List of included roles with brief descriptions
- Usage examples
- Requirements (gh CLI, git, authentication)
- Testing instructions
- Contributing guidelines (if applicable)
- License information

**Role Documentation** (16 files):

File: `roles/<role_name>/README.md`

Content (per role):
- Role name and description
- Requirements section
- Role variables (required and optional)
- Output variables (registered facts)
- Dependencies section
- Example playbook usage
- License
- Author information

**User Documentation:**

File: `github_collection/README.md` (project level)

Content:
- Project overview
- Directory structure
- How to use the Collection
- How to run tests
- Development setup
- Reference to Collection README

### Design Decisions

**Decision 1: One Role Per Task-Set**

**Rationale:** Maintains clear 1:1 mapping, preserves modularity

**Alternatives Considered:**
- Combine related roles (e.g., all branch operations)
- Create composite roles

**Selected:** One role per task-set (clearest, most maintainable)

**Decision 2: Keep Variable Names Unchanged**

**Rationale:** Maintains compatibility, reduces transformation complexity

**Alternatives Considered:**
- Rename to shorter names
- Remove prefixes

**Selected:** Keep existing names (backward compatible)

**Decision 3: Use include_role (not import_role)**

**Rationale:** Per Ansible Best Practices, provides variable isolation

**Alternatives Considered:**
- import_role (static, no isolation)
- roles: keyword (less flexible)

**Selected:** include_role (best practice)

**Decision 4: Empty defaults/main.yml**

**Rationale:** All variables are required in workflow context

**Alternatives Considered:**
- Add defaults for all optional variables
- Skip defaults file

**Selected:** Create empty defaults/main.yml (standard structure, future-ready)

**Decision 5: No Meta Dependencies**

**Rationale:** Keep roles independent, document in README

**Alternatives Considered:**
- Enforce dependencies in meta/main.yml
- Create dependency chain

**Selected:** No meta dependencies (flexibility)

**Decision 6: Local Collections Path**

**Rationale:** No Galaxy publishing needed yet, simpler development

**Alternatives Considered:**
- Publish to Galaxy
- Use system collections path

**Selected:** Local ./collections/ (controlled, isolated)

### Open Design Questions

None. All design aspects are clear from requirements and Ansible Best Practices.

### Implementation Sequence

**Recommended order:**

1. Collection initialization and configuration
2. Transform simple roles first (github_precheck, github_auth)
3. Transform repository roles (repo_*)
4. Transform branch roles (branch_*)
5. Transform PR roles (pr_*)
6. Update flow.yml
7. Test after each role or logical group
8. Full integration test

This sequence allows incremental testing and early detection of issues.

---

## Design Summary

### Overall Architecture

Standard Ansible Galaxy Collection with:
- 16 roles (one per task-set)
- FQCN: rstyczynski.github
- Local development (./collections/)
- Updated workflow (include_role)
- Enhanced validation (validate_argument_spec)

### Shared Components

- Collection configuration (galaxy.yml, runtime.yml)
- Common patterns (validation, variable naming)
- Documentation templates (role README)
- Testing approach (flow.yml integration)

### Design Risks

**Low Risk** - Well-defined transformation with proven patterns

- Clear source material (validated task-sets)
- Documented Ansible features
- Systematic approach
- Incremental testing

### Resource Requirements

**Tools:**
- ansible-galaxy (Collection init)
- Ansible 2.9+ (Collection support)
- Text editor (role creation)

**Time Estimate:**
- Collection init: 5 minutes
- Role transformation: ~30 minutes per role (16 roles = ~8 hours)
- flow.yml update: 30 minutes
- Testing: 1 hour
- Documentation: 2 hours
- **Total: ~12 hours of work**

Note: Due to repetitive nature, actual implementation may be faster with templates.

### Design Approval Status

Awaiting Review

This design is ready for Product Owner approval. Once approved, Construction phase can proceed to implement the Collection transformation.
