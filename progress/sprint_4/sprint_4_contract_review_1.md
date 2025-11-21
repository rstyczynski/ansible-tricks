# Sprint 4 - Contracting Phase Review

**Date:** 2024-12-19
**Sprint:** Sprint 4 - Comprehensive GitHub Collection documentation
**Status:** Contracting Complete - Ready for Inception

## Project Overview

This project is developing a GitHub Collection (`rstyczynski.github`) - a set of Ansible roles for interacting with GitHub repositories, branches, pull requests, and other GitHub operations. The collection uses GitHub CLI (gh) to provide idempotent interfaces for Ansible playbooks.

**Current Sprint:** Sprint 4 focuses on generating comprehensive HTML documentation for the entire collection using `antsibull-docs` tool.

## Current Sprint Information

**Sprint 4 - Comprehensive GitHub Collection documentation**
- **Status:** Progress
- **Mode:** Managed (Interactive)
- **Backlog Item:** GHC-6. GitHub Collection HTML documentation generation

**Backlog Item GHC-6 Requirements:**
- Generate HTML documentation site for the entire collection using `antsibull-docs` tool
- Documentation should include all 16 roles with their argument specifications, descriptions, and parameter details
- Provide a script (`generate_html_docs.sh`) that automates the process
- Generated documentation should be accessible via `docs_html/build/html/index.html`
- Follow official Ansible documentation guide: https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html

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
- Correct format: `docs: (sprint-14) add functional tests documentation`
- Incorrect format: `docs(sprint-14): add functional tests documentation`
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
- Always use `ansible.builtin.validate_argument_spec` for argument validation
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

## Responsibilities Enumerated

As Implementor (via specialized agents), I am responsible for:

### Allowed Actions:
1. **Design Documents** - Create and edit `sprint_${no}_design.md` during Elaboration phase
2. **Implementation Notes** - Create and edit `sprint_${no}_implementation.md` during Construction phase (excluding status tokens)
3. **Test Documents** - Create and edit `sprint_${no}_tests.md` during Construction phase
4. **Analysis Documents** - Create and edit `sprint_${no}_analysis.md` during Inception phase
5. **Proposed Changes** - Append to `sprint_${no}_proposedchanges.md` (never edit existing)
6. **Open Questions** - Append to `sprint_${no}_openquestions.md` (never edit existing)
7. **PROGRESS_BOARD.md** - Update during respective phases (allowed exception)
8. **README.md** - Update during Documentation phase

### Prohibited Actions:
1. **PLAN.md** - Read-only, never modify
2. **BACKLOG.md** - Read-only, never modify
3. **Status Tokens** - Never modify (owned by Product Owner, except initial "Proposed" status)
4. **Test Data** - Never modify
5. **Documents from Other Sprints** - Only edit current Sprint documents
6. **Completed Work** - Changes go through Proposed changes process

### Communication Protocol:
1. **Propose Changes** - Write to `progress/sprint_${no}/sprint_${no}_proposedchanges.md`
2. **Request Clarifications** - Write to `progress/sprint_${no}/sprint_${no}_openquestions.md`
3. **Status Updates** - Update PROGRESS_BOARD.md during phase transitions
4. **Git Commits** - Follow semantic commit conventions, push after commit

## Constraints Identified

1. **Design Approval Required** - Cannot proceed to Construction until design Status = `Accepted`
2. **Test Requirements** - All tests must be copy-paste-able, no `exit` commands
3. **Documentation Requirements** - All examples must be copy-paste-able and tested
4. **Idempotency** - All operations must be idempotent
5. **FQCN Usage** - Must use fully-qualified collection names
6. **Argument Validation** - Must use `validate_argument_spec` for all role arguments
7. **Virtual Environment** - Python dependencies must use `.venv` in project directory

## Technology Stack

- **Ansible** - Automation platform
- **GitHub CLI (gh)** - Interface for GitHub operations
- **antsibull-docs** - Tool for generating Ansible collection documentation
- **Sphinx** - Documentation framework (used by antsibull-docs)
- **Python** - Required for antsibull-docs and collection development

## Project Context

**Previous Sprints:**
- Sprint 1: Review of current codebase (Done)
- Sprint 2: Migration to Ansible Collection (Done) - GHC-3 implemented
- Sprint 3: Role interface specification (Done) - GHC-4 and GHC-5 implemented

**Current State:**
- Collection has 16 roles with argument specifications
- All roles have `ansible-doc` documentation
- Collection structure is complete in `github_collection/collections/ansible_collections/rstyczynski/github/`
- Script `generate_html_docs.sh` exists but needs to be completed/validated

## Open Questions

**None** - All requirements and rules are clear.

## Readiness Confirmation

**Contracting phase complete - ready for Inception**

All foundation documents reviewed and understood:
- ✓ Project scope (BACKLOG.md)
- ✓ Implementation plan (PLAN.md)
- ✓ General cooperation rules (GENERAL_RULES.md)
- ✓ Git rules (GIT_RULES.md)
- ✓ Product Owner guide (PRODUCT_OWNER_GUIDE.md)
- ✓ Ansible best practices (ANSIBLE_BEST_PRACTICES.md)
- ✓ Input/output specification pattern (input_output_spec.md)

All responsibilities enumerated, constraints identified, and communication protocols understood.

Ready to proceed to Phase 2: Inception.

