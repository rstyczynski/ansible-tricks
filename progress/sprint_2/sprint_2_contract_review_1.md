# Sprint 2 - Contracting Phase Review

## Executive Summary

Contracting phase completed for Sprint 2: "Migration to Ansible Collection". All foundation documents, cooperation rules, and technology-specific guidelines have been reviewed and understood. Sprint 2 will transform validated task-sets from Sprint 1 into a formal Ansible Collection structure. Ready to proceed to Inception phase.

## Project Overview

**Project Name**: ansible-tricks / GitHub Collection

**Project Goal**: Transform existing validated task-sets into Ansible Collection (rstyczynski.github) containing roles for GitHub operations using GitHub CLI (gh) to provide idempotent interfaces.

**Current Sprint**: Sprint 2 - Migration to Ansible Collection

**Sprint Status**: Progress

**Execution Mode**: Managed (Interactive) - Human-supervised execution with agent clarification requests

## Active Backlog Items

### GHC-3: GitHub Collection

**Scope**: Transform all existing task-sets from `github_task-sets` directory into Ansible Roles gathered in GitHub Collection

**Key Requirements**:

1. Collection FQCN: `rstyczynski.github`
2. Product directory: `$repo_root/github_collection`
3. Collection working directory: `$repo_root/github_collection/collections/ansible_collections`
4. Main flow.yml location: `$repo_root/github_collection/flow.yml`
5. Transform task-sets to roles
6. Update flow.yml to use roles from collection (not task-sets)
7. Keep collection locally in `./collections/ansible_collections` (no Galaxy publishing yet)
8. Test with existing `1.trigger` file
9. Handle status check timeout scenario (re-execute if needed)
10. Propose additional tests

**Source**: Sprint 1 validated codebase (./github_task-sets) - 100% compliant with standards

**Non-Functional Requirements**:
- Idempotency maintained (from task-sets)
- GitHub CLI (gh) and git utilities continue as interface
- Compatible with existing flow.yml workflow pattern

## Foundation Documents Reviewed

### 1. BACKLOG.md

**Status**: ✓ Reviewed and Understood

**Key Points**:
- GHC-3 specifies Collection transformation details
- Collection FQCN: rstyczynski.github
- Directory structure requirements clearly specified
- flow.yml must use roles (not task-sets)
- Testing requirements specified (1.trigger, status check timeout handling)
- Associated research repository: https://github.com/rstyczynski/github_tricks

### 2. PLAN.md

**Status**: ✓ Reviewed and Understood

**Key Points**:
- Sprint 1: Done (validation complete)
- Sprint 2: Progress (active) - GHC-3 GitHub Collection
- Original GHC-2 (Tools/Techniques) skipped/deferred
- Focus on simplicity and MVP

### 3. PROGRESS_BOARD.md

**Status**: ✓ Reviewed and Understood

**Key Points**:
- Sprint 1: implemented, GHC-1: tested
- Sprint 2: Progress, GHC-3: Planned
- Real-time tracking active

### 4. Sprint 1 Validation Report

**Status**: ✓ Reviewed and Understood

**Key Points**:
- 19 task-sets validated at 100% compliance
- All follow consistent patterns (INPUT/OUTPUT tables, variable prefixes, validation)
- Excellent code quality and idempotency
- Strong foundation for Collection transformation

## Cooperation Rules Reviewed

All rules from Sprint 1 Contracting remain applicable:

### 1. GENERAL_RULES.md

**Status**: ✓ Confirmed Understanding

**Key Points for Sprint 2**:
- Same 5-phase RUP process applies
- PROGRESS_BOARD.md real-time tracking
- Design approval required before construction
- Feedback via proposedchanges.md and openquestions.md
- Document ownership rules strictly enforced
- Backlog traceability with symbolic links

### 2. GIT_RULES.md

**Status**: ✓ Confirmed Understanding

**Key Points**:
- Semantic commit format: `type: (sprint-2) description`
- Push after each phase commit
- No breaking changes without documentation

### 3. ANSIBLE_BEST_PRACTICES.md

**Status**: ✓ Confirmed Understanding - **CRITICAL FOR SPRINT 2**

**Key Requirements for Collection/Roles**:

1. **Dependencies**:
   - Use requirements.yml for Ansible dependencies
   - Use requirements.txt for Python dependencies
   - Use .venv in project directory
   - Add .venv to .gitignore

2. **Variables**:
   - Use `ansible.builtin.validate_argument_spec` for role argument validation
   - Use inline argument specifications
   - Prefix variables with role name
   - Use custom loop_var (role_name_item)

3. **Role Invocation**:
   - **Always use `include_role`** (not import_role)
   - Avoid static `roles:` keyword
   - Variable isolation via include_role

4. **Code Semantics**:
   - Use ansible-lint
   - FQCN required (ansible.builtin.*)
   - Avoid shell/command when possible
   - Use `become` not sudo

5. **Idempotency**:
   - Every task must be idempotent
   - Document non-idempotent operations

6. **Testing**:
   - Use Molecule for role testing
   - Use ansible-test for collection testing
   - Test with Podman
   - Test idempotency
   - Syntax validation required

7. **Documentation**:
   - Each role needs README.md
   - Document purpose, variables, usage examples
   - Collection-level README.md

**Critical Changes from Task-Sets:**
- Transition from `assert` to `validate_argument_spec`
- Change from `import_tasks` to `include_role`
- Add role defaults in `defaults/main.yml`
- Create role meta in `meta/main.yml`

## Implementor Responsibilities Enumerated

### Allowed Actions

1. **Create Collection Structure**:
   - Initialize Collection: `ansible-galaxy collection init rstyczynski.github`
   - Create roles directory structure
   - Create galaxy.yml with Collection metadata

2. **Transform Task-Sets to Roles**:
   - Convert each task-set to role
   - Move tasks to `roles/<role_name>/tasks/main.yml`
   - Create `defaults/main.yml` for default variables
   - Create `meta/main.yml` for role metadata
   - Update variable validation (assert → validate_argument_spec)

3. **Update flow.yml**:
   - Change from `import_tasks` to `include_role`
   - Update variable passing pattern
   - Maintain workflow logic

4. **Create Phase Documents**:
   - `progress/sprint_2/sprint_2_analysis.md`
   - `progress/sprint_2/sprint_2_design.md`
   - `progress/sprint_2/sprint_2_implementation.md`
   - `progress/sprint_2/sprint_2_tests.md`

5. **Test Implementation**:
   - Execute flow.yml with Collection roles
   - Verify idempotency maintained
   - Handle status check timeout scenario
   - Propose additional tests

6. **Update PROGRESS_BOARD.md**:
   - Track Sprint 2 and GHC-3 status through phases

7. **Create Git Commits**:
   - Semantic commits for each phase
   - Push after each commit

### Prohibited Actions

1. **Never Modify**:
   - PLAN.md (unless Product Owner instructs)
   - BACKLOG.md
   - Status tokens (owned by Product Owner)
   - Sprint 1 completed documents

2. **Never Break**:
   - Existing functionality from validated task-sets
   - Idempotency patterns
   - Variable naming conventions
   - Error handling

3. **Never Skip**:
   - Design approval before implementation
   - Testing before marking complete
   - Documentation phase

## Communication Protocol

### Propose Changes

**File**: `progress/sprint_2/sprint_2_proposedchanges.md`

**Use**: Suggest improvements or deviations from requirements

### Request Clarifications

**File**: `progress/sprint_2/sprint_2_openquestions.md`

**Use**: Ask about ambiguous requirements or design choices

## Constraints and Boundaries

### Technical Constraints

1. **Collection Structure**: Must follow Ansible Galaxy collection standards
2. **FQCN**: rstyczynski.github (namespace.name)
3. **Local Development**: No Galaxy publishing, local collections/ directory
4. **Backward Compatibility**: Maintain workflow behavior from task-sets
5. **Testing**: Must use existing github_lab repository and 1.trigger file

### Operational Constraints

1. **Scope**: Only GHC-3 in Sprint 2
2. **Execution Mode**: Managed (interactive)
3. **Phase Sequence**: Contracting → Inception → Elaboration → Construction → Documentation
4. **Design Approval**: Required before construction
5. **Source Material**: Sprint 1 validated task-sets (./github_task-sets)

### Quality Constraints

1. **Ansible Best Practices**: Full compliance required
2. **Idempotency**: Must be maintained from task-sets
3. **Testing**: Functional tests with flow.yml execution
4. **Documentation**: Role README.md + Collection README.md required
5. **Code Quality**: ansible-lint compliance

## Sprint 2 Specific Considerations

### Migration Strategy

**From Task-Sets to Roles**:
1. One role per task-set (e.g., repo_clone task-set → repo_clone role)
2. Preserve variable names and patterns
3. Maintain idempotency logic
4. Update validation pattern (assert → validate_argument_spec)

**Role Structure** (per role):
```
roles/repo_clone/
├── defaults/main.yml    # Default variables
├── tasks/main.yml       # Main task file (from task-set)
├── meta/main.yml        # Role metadata
└── README.md            # Role documentation
```

**Collection Structure**:
```
github_collection/
├── collections/
│   └── ansible_collections/
│       └── rstyczynski/
│           └── github/
│               ├── galaxy.yml
│               ├── README.md
│               ├── meta/runtime.yml
│               └── roles/
│                   ├── repo_clone/
│                   ├── repo_commit/
│                   ├── pr_create/
│                   └── ... (all task-sets as roles)
└── flow.yml             # Updated to use roles
```

### Testing Strategy

1. **Functional Test**: Execute flow.yml with Collection
2. **Idempotency Test**: Run flow.yml twice, verify no changes on second run
3. **Timeout Test**: Verify status check timeout handling
4. **Additional Tests**: Propose based on collection structure

### Design Decisions Needed

1. **Role Naming**: Keep task-set names or rename?
2. **Variable Defaults**: Which variables should have defaults?
3. **Meta Dependencies**: Define role dependencies in meta/main.yml?
4. **Testing Approach**: Molecule setup or simple playbook tests?

## Open Questions

None at this time. Requirements are clear from GHC-3 specification. Any ambiguities will be raised during Inception/Elaboration phases.

## Readiness Assessment

**Understanding Confirmed**: ✓ Yes

**Rules Compliance Capability**: ✓ Yes

**Technology Requirements**: ✓ Yes (Ansible, ansible-galaxy, gh, git)

**Execution Mode**: ✓ Managed (Interactive)

**Current Phase**: ✓ Contracting Complete

**Next Phase**: ✓ Ready for Inception

## Status

**Contracting Phase**: COMPLETE

**Readiness**: READY FOR INCEPTION

## Token Usage Statistics

**Sprint 2 Contracting Phase**: ~6,000 tokens (requirements review, rule confirmation, Sprint 1 validation review)

## Artifacts Created

- `progress/sprint_2/sprint_2_contract_review_1.md` (this document)

## Next Phase

**Phase 2: Inception** - Analyst Agent will:
1. Analyze GHC-3 requirements in detail
2. Review Sprint 1 validated task-sets as source material
3. Plan Collection structure and role mapping
4. Identify transformation approach
5. Update PROGRESS_BOARD.md to `under_analysis`
6. Create analysis document
7. Confirm readiness for design

## Signature

**Agent Role**: Contractor Agent

**Phase**: Contracting (1/5)

**Sprint**: Sprint 2

**Date**: 2025-11-21

**Status**: Complete - Ready for Inception
