# Sprint 2 - Analysis

Status: Complete

## Sprint Overview

Sprint 2 focuses on transforming the validated task-sets from Sprint 1 into a formal Ansible Collection structure. The goal is to create the `rstyczynski.github` Collection with 16 roles, maintain all functionality and idempotency, and update the workflow to use roles instead of task-sets.

## Backlog Items Analysis

### GHC-3: GitHub Collection

**Requirement Summary:**

Transform all existing task-sets from `github_task-sets` directory into Ansible Roles within a Collection structure:

- **Collection FQCN**: rstyczynski.github
- **Product Directory**: $repo_root/github_collection
- **Collection Directory**: $repo_root/github_collection/collections/ansible_collections
- **Main Workflow**: $repo_root/github_collection/flow.yml (updated to use roles)
- **Local Development**: Keep collection in ./collections/ansible_collections (no Galaxy publishing)
- **Testing**: Use existing 1.trigger file and handle timeout scenarios
- **Additional Tests**: Propose new tests based on Collection structure

**Source Material**: 16 validated task-sets from Sprint 1 (100% compliant)

**Task-Sets to Transform**:
1. branch_checkout.yml → branch_checkout role
2. branch_delete.yml → branch_delete role
3. branch_pull.yml → branch_pull role
4. branch_push.yml → branch_push role
5. branch_switch.yml → branch_switch role
6. github_auth.yml → github_auth role
7. github_logout.yml → github_logout role
8. github_precheck.yml → github_precheck role
9. pr_comment.yml → pr_comment role
10. pr_create.yml → pr_create role
11. pr_merge.yml → pr_merge role
12. pr_status_check.yml → pr_status_check role
13. pr_status_check_pause.yml → pr_status_check_pause role
14. repo_clone.yml → repo_clone role
15. repo_commit.yml → repo_commit role
16. repo_file_add.yml → repo_file_add role

Plus: flow.yml (orchestration playbook - updated to use roles)

**Technical Approach:**

The transformation follows these principles:

1. **Preserve Functionality**: All task logic remains identical
2. **Update Structure**: Convert flat task files to role directory structure
3. **Enhance Validation**: Migrate from assert to validate_argument_spec
4. **Add Defaults**: Create defaults/main.yml for each role
5. **Add Metadata**: Create meta/main.yml for dependencies
6. **Update Invocation**: Change flow.yml from import_tasks to include_role
7. **Maintain Standards**: Keep variable naming, INPUT/OUTPUT documentation patterns

**Dependencies:**

- Sprint 1 validated task-sets (./github_task-sets)
- ansible-galaxy tool (for collection initialization)
- Existing github_lab repository for testing
- ~/.netrc authentication

**Testing Strategy:**

1. **Functional Test**: Execute flow.yml with Collection roles
2. **Idempotency Test**: Run twice, verify no changes second time
3. **Timeout Scenario**: Test PR status check timeout handling
4. **Comparison Test**: Verify Collection output matches task-set output
5. **Additional Tests**: To be proposed after implementation

**Acceptance Criteria:**

1. Collection structure created with FQCN rstyczynski.github
2. All 16 task-sets transformed to roles
3. flow.yml updated to use include_role (not import_tasks)
4. All roles use validate_argument_spec (not assert)
5. All roles have defaults/main.yml
6. All roles have meta/main.yml
7. Collection has galaxy.yml
8. Collection has README.md
9. Each role has README.md
10. Functional test passes (flow.yml executes successfully)
11. Idempotency maintained
12. No regression in functionality

**Risks/Concerns:**

**Medium Risk** - Collection transformation with multiple changes:

1. **Structural Changes**:
   - Risk: Breaking functionality during role conversion
   - Mitigation: Transform one role at a time, test incrementally

2. **Validation Pattern Change**:
   - Risk: Incorrect validate_argument_spec syntax
   - Mitigation: Follow Ansible BP exactly, test each role

3. **Role Invocation Change**:
   - Risk: Variable passing errors with include_role
   - Mitigation: Careful mapping, reference existing patterns

4. **Collection Path Resolution**:
   - Risk: Ansible not finding roles in local collection
   - Mitigation: Proper ANSIBLE_COLLECTIONS_PATH or ansible.cfg setup

5. **Testing Complexity**:
   - Risk: Hard to test all 16 roles systematically
   - Mitigation: Use flow.yml as integration test

**Compatibility Notes:**

This Sprint builds directly on Sprint 1:
- Uses validated task-sets as source (zero defects baseline)
- Maintains variable naming conventions
- Preserves idempotency patterns
- Keeps GitHub CLI (gh) interface
- Compatible with existing github_lab test repository

## Task-Set to Role Mapping

### Role Structure Template

Each role follows this structure:
```
roles/<role_name>/
├── defaults/
│   └── main.yml          # Default values for role variables
├── tasks/
│   └── main.yml          # Main task file (from task-set)
├── meta/
│   └── main.yml          # Role metadata and dependencies
└── README.md             # Role documentation
```

### Transformation Pattern

**From Task-Set**:
```yaml
# INPUT VARIABLES TABLE
# | name              | type   | description        |
# |-------------------|--------|--------------------|
# | repo_clone_var    | string | Description        |

- name: "Clone: Check input variables"
  ansible.builtin.assert:
    that:
      - repo_clone_var is defined
```

**To Role**:

**defaults/main.yml**:
```yaml
---
# No defaults for required variables
# Optional variables can have defaults here
```

**tasks/main.yml**:
```yaml
---
# INPUT VARIABLES TABLE
# | name              | type   | description        |
# |-------------------|--------|--------------------|
# | repo_clone_var    | string | Description        |

- name: "Clone: Validate arguments"
  ansible.builtin.validate_argument_spec:
    argument_spec:
      repo_clone_var:
        type: str
        required: true
        description: Description

# Rest of tasks from task-set
```

**meta/main.yml**:
```yaml
---
galaxy_info:
  author: rstyczynski
  description: GitHub repository cloning operations
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
dependencies: []
```

### Variable Migration Strategy

**Keep Existing Patterns**:
- Maintain `<role_name>_<variable>` prefix convention
- Preserve variable types from INPUT/OUTPUT tables
- No variable renaming (maintain compatibility)

**Add Validation**:
- Convert `assert` to `validate_argument_spec`
- Use inline argument_spec (not separate file)
- Include type, required, description for each argument

### Flow.yml Transformation

**From import_tasks**:
```yaml
- name: Clone Repository
  ansible.builtin.import_tasks: repo_clone.yml
  vars:
    repo_clone_repo_url: "{{ repo_url }}"
    repo_clone_dest_path: "{{ dest_path }}"
```

**To include_role**:
```yaml
- name: Clone Repository
  ansible.builtin.include_role:
    name: rstyczynski.github.repo_clone
  vars:
    repo_clone_repo_url: "{{ repo_url }}"
    repo_clone_dest_path: "{{ dest_path }}"
```

**Key Changes**:
- Use `include_role` (not `import_role` per Ansible BP)
- Specify FQCN: `rstyczynski.github.<role_name>`
- Variable passing remains same (vars: block)
- Task name describes role purpose

## Collection Structure Analysis

### Directory Layout

```
github_collection/
├── collections/
│   └── ansible_collections/
│       └── rstyczynski/
│           └── github/
│               ├── galaxy.yml
│               ├── README.md
│               ├── meta/
│               │   └── runtime.yml
│               ├── plugins/
│               │   └── README.md
│               └── roles/
│                   ├── branch_checkout/
│                   ├── branch_delete/
│                   ├── branch_pull/
│                   ├── branch_push/
│                   ├── branch_switch/
│                   ├── github_auth/
│                   ├── github_logout/
│                   ├── github_precheck/
│                   ├── pr_comment/
│                   ├── pr_create/
│                   ├── pr_merge/
│                   ├── pr_status_check/
│                   ├── pr_status_check_pause/
│                   ├── repo_clone/
│                   ├── repo_commit/
│                   └── repo_file_add/
├── flow.yml
├── 1.trigger
└── ansible.cfg (optional - for collection path)
```

### Collection Configuration

**galaxy.yml**:
```yaml
namespace: rstyczynski
name: github
version: 1.0.0
readme: README.md
authors:
  - rstyczynski
description: Ansible Collection for GitHub operations using gh CLI
license:
  - MIT
repository: https://github.com/rstyczynski/ansible-tricks
documentation: https://github.com/rstyczynski/ansible-tricks
issues: https://github.com/rstyczynski/ansible-tricks/issues
tags:
  - github
  - git
  - gh
  - cli
dependencies: {}
```

**ansible.cfg** (optional, for local development):
```ini
[defaults]
collections_path = ./collections
```

### Role Dependencies

Most roles are independent, but some logical dependencies exist:

**github_precheck** → Validates gh CLI availability
- Required before: github_auth, all GitHub operations

**github_auth** → Authenticates gh CLI
- Required before: All GitHub operations except github_precheck

**repo_clone** → Clones/updates repository
- Required before: All repository operations

**Dependency Strategy**: Document in role README.md, don't enforce in meta/main.yml (keep roles flexible)

## Overall Sprint Assessment

**Feasibility:** High

Transformation is straightforward with clear patterns:
- Source material is validated (100% compliant)
- Transformation pattern is repetitive (good for consistency)
- Ansible Galaxy collection structure is well-documented
- Testing can reuse existing flow.yml

**Estimated Complexity:** Moderate

- 16 roles to create (repetitive but tedious)
- Each role needs 4 files (defaults, tasks, meta, README)
- flow.yml update (16 role invocations to update)
- Validation pattern change (assert → validate_argument_spec)
- Testing to ensure no regressions

**Prerequisites Met:** Yes

- ✅ Sprint 1 validated task-sets available
- ✅ ansible-galaxy tool available
- ✅ Ansible Best Practices documented
- ✅ github_lab repository accessible
- ✅ Testing workflow established (flow.yml + 1.trigger)

**Open Questions:** None

Requirements are clear and well-specified in GHC-3. Transformation approach is established by Ansible Best Practices.

## Recommended Design Focus Areas

For Elaboration phase, focus on:

1. **Collection Initialization**:
   - ansible-galaxy collection init command
   - Directory structure creation
   - galaxy.yml configuration

2. **Role Structure Template**:
   - Standard defaults/main.yml pattern
   - meta/main.yml template with galaxy_info
   - README.md template structure

3. **Validation Migration**:
   - validate_argument_spec syntax for each variable type (str, bool, dict, int)
   - Mapping from INPUT TABLE to argument_spec
   - Error message handling

4. **flow.yml Update Strategy**:
   - include_role invocation pattern
   - FQCN usage
   - Variable passing verification

5. **Testing Approach**:
   - Functional test plan (flow.yml execution)
   - Idempotency test methodology
   - Timeout scenario handling
   - Additional test proposals

6. **Documentation Standards**:
   - Collection README.md content
   - Role README.md template
   - Variable documentation format
   - Usage examples

## Readiness for Design Phase

**Status:** Confirmed Ready

All requirements analyzed. Clear transformation approach identified. Source material is validated and understood. Ready to design detailed implementation specifications.

## Analysis Methodology

This analysis was conducted through:

1. **Requirements Review**: Read GHC-3 from BACKLOG.md
2. **Source Material Assessment**: Reviewed Sprint 1 validation report
3. **Task-Set Inventory**: Identified all 16 task-sets for transformation
4. **Pattern Analysis**: Determined transformation patterns (task-set → role)
5. **Structure Planning**: Designed Collection directory layout
6. **Risk Assessment**: Identified potential issues and mitigations
7. **Feasibility Verification**: Confirmed technical approach is sound

## Token Usage Statistics

**Inception Phase Token Usage:** ~5,000 tokens (requirement analysis, task-set inventory, transformation planning)

**Cumulative Sprint 2 Token Usage:** ~11,000 tokens (Contracting + Inception)

## Execution Mode Confirmation

**Mode:** Managed (Interactive)

**Mode Detection:** Sprint 2 in PLAN.md contains no "Mode:" field, defaulting to managed mode.

**Behavior Applied:**
- ✓ Human-supervised analysis
- ✓ Complete documentation of transformation approach
- ✓ Risk identification with mitigations
- ✓ Ready to proceed pending Product Owner confirmation

## Summary

Sprint 2 analysis confirms that transforming the 16 validated task-sets into an Ansible Collection is feasible and well-scoped. The transformation follows established patterns from Ansible Best Practices, maintains all functionality and idempotency, and provides clear acceptance criteria.

**Transformation Summary:**
- **16 roles** to create from validated task-sets
- **1 Collection** with FQCN rstyczynski.github
- **1 workflow** (flow.yml) to update for role invocation
- **Validation upgrade** from assert to validate_argument_spec
- **Testing** via existing flow.yml + additional proposed tests

**Recommendation:** Proceed to Elaboration phase to design detailed transformation specifications, role templates, and implementation approach.
