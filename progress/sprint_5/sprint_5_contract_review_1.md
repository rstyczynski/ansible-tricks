# Sprint 5 - Contracting Phase Review

**Date:** 2025-01-XX
**Sprint:** Sprint 5 - Role argument specification fix
**Status:** Contracting Complete - Ready for Inception

## Project Overview

This project is developing a GitHub Collection (`rstyczynski.github`) - a set of Ansible roles for interacting with GitHub repositories, branches, pull requests, and other GitHub operations. The collection uses GitHub CLI (gh) to provide idempotent interfaces for Ansible playbooks.

**Current Sprint:** Sprint 5 focuses on ensuring all roles use argument specification at meta directory only, removing inline argument specifications from tasks.

## Current Sprint Information

**Sprint 5 - Role argument specification fix**
- **Status:** Progress
- **Mode:** Managed (Interactive) - No Mode field specified, defaulting to managed
- **Backlog Item:** GHC-7. Roles uses argument specification at meta

**Backlog Item GHC-7 Requirements:**
- Make sure that all roles use argument specification at meta directory
- Do not keep argument specification for rules inline
- All 16 roles must be updated to remove inline `validate_argument_spec` tasks
- Keep only `meta/argument_specs.yml` files for argument specification
- Ansible automatically validates arguments from `meta/argument_specs.yml` when roles are invoked

## Rule Compliance Confirmation

### Generic Rules (Technology-Agnostic)

#### GENERAL_RULES.md
**Understanding Confirmed:** ✓
- Multi-agent architecture with specialized agents (Contractor, Analyst, Designer, Constructor, Documentor)
- Sprint-based development following RUP phases
- PROGRESS_BOARD.md is single source of truth for status tracking
- Design must be approved (Status: Accepted) before implementation
- Implementation must follow approved design exactly
- Testing requirements: copy-paste-able shell sequences, no `exit` commands
- Documentation must be copy-paste-able and tested
- Backlog traceability via symbolic links in `progress/backlog/`
- Status tokens owned by Product Owner (except initial "Proposed" status)
- Prohibited edits: PLAN.md, Test data, status tokens in phase documents
- Allowed edits: Design, Implementation Notes, Test documents, Analysis documents, Proposed changes, Open questions, PROGRESS_BOARD.md (during respective phases)

#### GIT_RULES.md
**Understanding Confirmed:** ✓
- Use semantic commit messages (type: description format)
- Type comes before colon, no parentheses before colon
- Correct format: `docs: (sprint-5) add functional tests documentation`
- Incorrect format: `docs(sprint-5): add functional tests documentation`
- Push to remote after commit

#### PRODUCT_OWNER_GUIDE.md
**Understanding Confirmed:** ✓
- Product Owner owns vision, process control, quality assurance
- Agents must follow structured phases
- Design approval required before implementation
- Test loops up to 10 attempts per failing test
- Intervention mechanisms for deviations

### Technology-Specific Rules

#### ANSIBLE_BEST_PRACTICES.md
**Understanding Confirmed:** ✓
- Prefer simplicity over complexity
- Always use `ansible.builtin` modules for generic operations
- Use `requirements.yml` for Ansible dependencies with version specification
- Use `requirements.txt` for Python dependencies with version specification
- Always use Python virtual environment (`.venv` in project directory)
- **For roles**: Use `meta/argument_specs.yml` to define argument specifications
- This enables `ansible-doc` documentation and is the standard Ansible approach
- Optionally, also use inline `ansible.builtin.validate_argument_spec` in `tasks/main.yml` for runtime validation
- **Key Point**: The backlog item GHC-7 requires removing inline validation and using only meta/argument_specs.yml
- Prefix all variables with role's name
- Use `loop_control: { loop_var: role_name_item }` instead of default `item`
- Always store sensitive data externally, never commit plain text secrets
- Always use `include_role`, never `import_role`
- Always use FQCN in Ansible content
- Avoid shell/command when possible, use native modules
- Use `become` instead of sudo
- Every task should be idempotent
- Use Molecule for role testing, ansible-test for collection testing

#### input_output_spec.md
**Understanding Confirmed:** ✓
- Use `meta/argument_specs.yml` for role argument specification
- INPUTS: No prefix in description, may be required
- OUTPUTS: Must start with `[OUTPUT]` prefix, always `required: false`
- Follow pattern structure with `argument_specs.main.options`

#### input_output_rule_spec.md
**Understanding Confirmed:** ✓
- All roles use `meta/argument_specs.yml` to specify arguments
- When creating or updating `meta/argument_specs.yml` files, follow the pattern specified in `input_output_spec.md`

## Responsibilities Enumerated

As Implementor (via specialized agents), I am responsible for:

### Allowed Actions:
1. **Design Documents** - Create and edit `sprint_5_design.md` during Elaboration phase
2. **Implementation Notes** - Create and edit `sprint_5_implementation.md` during Construction phase (excluding status tokens)
3. **Test Documents** - Create and edit `sprint_5_tests.md` during Construction phase
4. **Analysis Documents** - Create and edit `sprint_5_analysis.md` during Inception phase
5. **Proposed Changes** - Append to `sprint_5_proposedchanges.md` (never edit existing)
6. **Open Questions** - Append to `sprint_5_openquestions.md` (never edit existing)
7. **PROGRESS_BOARD.md** - Update during respective phases (allowed exception)
8. **README.md** - Update during Documentation phase
9. **Role Task Files** - Edit `tasks/main.yml` files to remove inline `validate_argument_spec` tasks

### Prohibited Actions:
1. **PLAN.md** - Read-only, never modify
2. **BACKLOG.md** - Read-only, never modify
3. **Status Tokens** - Never modify (owned by Product Owner, except initial "Proposed" status)
4. **Test Data** - Never modify
5. **Documents from Other Sprints** - Only edit current Sprint documents
6. **Completed Work** - Changes go through Proposed changes process
7. **meta/argument_specs.yml** - Do not modify these files (they are already correct)

### Communication Protocol:
1. **Propose Changes** - Write to `progress/sprint_5/sprint_5_proposedchanges.md`
2. **Request Clarifications** - Write to `progress/sprint_5/sprint_5_openquestions.md`
3. **Status Updates** - Update PROGRESS_BOARD.md during phase transitions
4. **Git Commits** - Follow semantic commit conventions, push after commit

## Constraints Identified

1. **Design Approval Required** - Cannot proceed to Construction until design Status = `Accepted`
2. **Test Requirements** - All tests must be copy-paste-able, no `exit` commands
3. **Documentation Requirements** - All examples must be copy-paste-able and tested
4. **Idempotency** - All operations must be idempotent
5. **FQCN Usage** - Must use fully-qualified collection names
6. **Argument Validation** - Must use only `meta/argument_specs.yml` (no inline validation)
7. **Virtual Environment** - Python dependencies must use `.venv` in project directory
8. **Preserve Existing Functionality** - Removing inline validation must not break role functionality
9. **Verify ansible-doc** - Ensure `ansible-doc` still works correctly after changes

## Technology Stack

- **Ansible** - Automation platform
- **GitHub CLI (gh)** - Interface for GitHub operations
- **Python** - Required for collection development

## Project Context

**Previous Sprints:**
- Sprint 1: Review of current codebase (Done)
- Sprint 2: Migration to Ansible Collection (Done) - GHC-3 implemented
- Sprint 3: Role interface specification (Done) - GHC-4 and GHC-5 implemented
- Sprint 4: Comprehensive GitHub Collection documentation (Done) - GHC-6 implemented

**Current State:**
- Collection has 16 roles with `meta/argument_specs.yml` files (already exist)
- All roles currently have inline `validate_argument_spec` tasks in `tasks/main.yml`
- All roles have `ansible-doc` documentation working
- Collection structure is complete in `github_collection/collections/ansible_collections/rstyczynski/github/`

**Target State:**
- All 16 roles should use only `meta/argument_specs.yml` for argument specification
- All inline `validate_argument_spec` tasks should be removed from `tasks/main.yml`
- Ansible will automatically validate arguments from `meta/argument_specs.yml` when roles are invoked
- `ansible-doc` should continue to work correctly

## Open Questions

**None** - All requirements and rules are clear.

## Readiness Confirmation

**Contracting phase complete - ready for Inception**

All foundation documents reviewed and understood:
- ✓ Project scope (BACKLOG.md)
- ✓ Implementation plan (PLAN.md)
- ✓ General cooperation rules (from RUPStrikesBack)
- ✓ Git rules (from RUPStrikesBack)
- ✓ Product Owner guide (from RUPStrikesBack)
- ✓ Ansible best practices (ANSIBLE_BEST_PRACTICES.md)
- ✓ Input/output specification pattern (input_output_spec.md)
- ✓ Input/output rule specification (input_output_rule_spec.md)

All responsibilities enumerated, constraints identified, and communication protocols understood.

Ready to proceed to Phase 2: Inception.

