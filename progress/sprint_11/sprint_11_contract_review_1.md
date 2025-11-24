# Sprint 11 - Contracting Phase Review

## Project Overview

**Project Name**: ansible-tricks
**Project Type**: Ansible Collection Development
**Collection FQCN**: rstyczynski.github (existing) and rstyczynski.ansible (new)
**Primary Technology**: Ansible, Python, GitHub CLI (gh)

**Project Goals**:
- GitHub Collection (rstyczynski.github) provides idempotent Ansible roles for GitHub operations (repository management, branches, pull requests, etc.)
- New Ansible Collection (rstyczynski.ansible) provides general-purpose Ansible tools
- First feature: Long-running task support with persistence and resumability

**Development Approach**:
- Follows Rational Unified Process (RUP) with 5 phases
- Sprint-based development with clear Backlog Items
- All work tracked in PROGRESS_BOARD.md

## Current Sprint

**Sprint Number**: Sprint 11
**Sprint Name**: Handling long running task
**Sprint Status**: Progress
**Execution Mode**: YOLO (autonomous execution with documented assumptions)

**Backlog Items**:
- **GHC-15. Long running task**
  - Create new collection `rstyczynski.ansible` for general Ansible tools
  - Implement role(s) supporting long-running tasks using `async` and job persistence
  - Support multiple persistence backends (ara, local filesystem, object storage)
  - Test cases: controller wait, controller exit/resume, host crash handling
  - Collection structure: `ansible_collection/collections/ansible_collections/rstyczynski/ansible/`

## Rule Compliance - Understanding Confirmed

### Generic Rules (Technology-Agnostic)

**1. GENERAL_RULES.md** - ✅ **UNDERSTOOD**

Key Points:
- I act as Implementor through specialized agent roles (Contractor, Analyst, Designer, Constructor, Documentor)
- Focus only on Sprint 11 Backlog Items; others are context only
- Two execution modes: "managed" (interactive) and "YOLO" (autonomous) - Sprint 11 is YOLO
- YOLO mode: make reasonable assumptions, document decisions, proceed autonomously, only stop for critical failures
- All phase documents follow standardized naming: `progress/sprint_11/sprint_11_*.md`
- PROGRESS_BOARD.md is single source of truth for real-time status tracking
- Sprint Status FSM: Planned → Progress → Designed → Implemented → Tested → Done
- Design approval required before implementation (YOLO: 60-second auto-approval)

**2. GIT_RULES.md** - ✅ **UNDERSTOOD**

Key Points:
- Use semantic commit messages (type: description format)
- Type comes BEFORE colon, no text before colon
- Correct format: `docs: (sprint-11) description`
- Incorrect format: `docs(sprint-11): description`
- Push to remote after every commit

**3. PRODUCT_OWNER_GUIDE.md** - ✅ **UNDERSTOOD**

Key Points:
- Product Owner defines vision and requirements
- 5-phase RUP process: Contracting → Inception → Elaboration → Construction → Documentation
- Product Owner reviews after each phase
- Feedback mechanism: proposedchanges.md and openquestions.md
- Intervention types: session limits, technical noncompliance, procedural violations, conceptual defects, late changes
- Clear communication expected, explicit requirements preferred

### Technology-Specific Rules

**4. ANSIBLE_BEST_PRACTICES.md (RUPStrikesBack)** - ✅ **UNDERSTOOD**

Key Points:
- Keep it simple, prefer simplicity over complexity
- Always use `ansible.builtin` modules for generic operations
- Dependencies: requirements.yml for Ansible, requirements.txt for Python
- Python virtual environment: `.venv` in project directory
- Variables: use `ansible.builtin.validate_argument_spec` with `meta/argument_specs.yml` for roles
- Prefix all variables with role name
- Never commit plain text secrets
- Always use `include_role`, never `import_role`
- Use FQCN (fully-qualified collection names)
- Idempotency: every task should be idempotent
- Long-running tasks: use `async` and `poll`
- Testing: Molecule for roles, ansible-test for collections, Podman for test targets
- Documentation: README.md for each playbook and role

**5. input_output_rule_spec.md (local)** - ✅ **UNDERSTOOD**

Key Points:
- Roles use `meta/argument_specs.yml` for argument specification
- Follow pattern in input_output_spec.md
- INPUTS: no prefix in description, may be required
- OUTPUTS: `[OUTPUT]` prefix in description, always `required: false`

**6. input_output_spec.md (local)** - ✅ **UNDERSTOOD**

Key Points:
- Detailed pattern for `argument_specs.yml` structure
- Clear distinction between inputs and outputs
- Outputs must have `[OUTPUT]` prefix and `required: false`

## Responsibilities Enumerated

### As Implementor, I AM ALLOWED TO:

1. **Create and edit Sprint 11 documents**:
   - `progress/sprint_11/sprint_11_analysis.md`
   - `progress/sprint_11/sprint_11_design.md`
   - `progress/sprint_11/sprint_11_implementation.md`
   - `progress/sprint_11/sprint_11_tests.md`
   - `progress/sprint_11/sprint_11_documentation.md`
   - `progress/sprint_11/sprint_11_proposedchanges.md`
   - `progress/sprint_11/sprint_11_openquestions.md`
   - Phase review files with `_${cnt}.md` suffix

2. **Update PROGRESS_BOARD.md** during my respective phases

3. **Create symbolic links** in `progress/backlog/GHC-15/` during Documentation phase

4. **Commit changes** after each phase with semantic commit messages

5. **Push to remote** after each commit

6. **Propose changes** via sprint_11_proposedchanges.md (append-only)

7. **Ask questions** via sprint_11_openquestions.md (append-only)

### I MUST NEVER:

1. **Modify PLAN.md** - owned by Product Owner
2. **Modify BACKLOG.md** - owned by Product Owner
3. **Edit status tokens** in phase documents (Status: lines) - owned by Product Owner
4. **Edit documents from other Sprints** - only Sprint 11 documents
5. **Edit already-existing feedback paragraphs** - append-only for proposedchanges and openquestions
6. **Use `exit` commands** in copy-paste examples (user terminal will close)
7. **Commit secrets** - use environment variables or external secret managers
8. **Skip design approval** - must wait for Status: Accepted (YOLO: 60s auto-approval)
9. **Modify test data** - marked as prohibited

### My Phase-Specific Responsibilities:

**Phase 1 - Contracting (Current)**:
- Review project scope, plan, and all rules
- Confirm understanding
- Create contract review document
- Commit and push

**Phase 2 - Inception**:
- Analyze GHC-15 requirements
- Review previous Sprint artifacts for compatibility
- Update PROGRESS_BOARD.md to `under_analysis`
- Create analysis and inception review documents
- Commit and push

**Phase 3 - Elaboration**:
- Create detailed technical design
- Perform feasibility analysis against Ansible capabilities
- Update PROGRESS_BOARD.md to `under_design`
- Set design Status to `Proposed`
- Wait 60 seconds for approval (YOLO mode)
- Create elaboration review document
- Commit and push

**Phase 4 - Construction**:
- Implement code based on approved design
- Update PROGRESS_BOARD.md to `under_construction`
- Create functional tests (copy-paste-able)
- Run test loops (up to 10 attempts per failing test)
- Document implementation with user-facing documentation
- Update PROGRESS_BOARD.md with final statuses
- Commit and push

**Phase 5 - Documentation**:
- Validate all Sprint documentation
- Verify code snippets are copy-paste-able
- Create symbolic links in `progress/backlog/GHC-15/`
- Update README.md with recent developments
- Create documentation summary
- Commit and push

## Communication Protocol

### Proposing Changes:
- File: `progress/sprint_11/sprint_11_proposedchanges.md`
- Format: Subchapter per proposal
- Include Status field (initially "None")
- Product Owner marks as PROPOSED, ACCEPTED, REJECTED, or POSTPONED
- Append-only: never edit existing paragraphs

### Requesting Clarifications:
- File: `progress/sprint_11/sprint_11_openquestions.md`
- Format: Subchapter per question
- Include Status, Problem to clarify, Answer fields
- Product Owner provides answers
- Append-only: never edit existing paragraphs

### Status Updates:
- Update PROGRESS_BOARD.md at phase transitions
- Sprint statuses: under_analysis, analysed, under_design, designed, under_construction, implemented, implemented_partially, tested, failed
- Backlog Item statuses: under_analysis, analysed, under_design, designed, under_construction, implemented, tested, failed

### YOLO Mode Behaviors:
- Make reasonable assumptions for ambiguous requirements
- Document all assumptions in implementation docs with rationale and risk assessment
- Auto-approve designs after 60-second wait
- Proceed with partial test success
- Auto-fix simple issues
- Only stop for critical failures

## Constraints and Prohibited Actions

1. **No modification of**:
   - PLAN.md (Implementation Plan)
   - BACKLOG.md (Project scope)
   - Status tokens (owned by Product Owner)
   - Test data
   - Documents from other Sprints

2. **No commit of**:
   - Plain text secrets (passwords, tokens, API keys)
   - .venv directory (add to .gitignore)

3. **No use of**:
   - `exit` commands in documentation examples
   - `import_role` (use `include_role` instead)
   - Non-FQCN module names
   - Shell/command when native modules exist

4. **Required practices**:
   - Semantic commit messages with correct format
   - Push after every commit
   - Idempotent tasks
   - Copy-paste-able test sequences
   - Virtual environment for Python dependencies

## Open Questions

**None** - All requirements and rules are clear.

## YOLO Mode Specific Notes

**Execution Mode**: YOLO (Autonomous)

**Decision Authority**:
- Will make reasonable assumptions for ambiguous technical details
- Will auto-approve design after 60-second wait
- Will proceed with partial test success if documented
- Will auto-fix simple issues without asking

**Decision Logging**:
All autonomous decisions will be documented in implementation and design documents with:
1. What was ambiguous
2. What assumption was made
3. Rationale for the decision
4. Risk assessment

**Stop Conditions**:
Will only stop execution for:
- Critical technical impossibilities (API limitations)
- Contradictory requirements
- Security concerns
- Data loss risks

## Status

**Contracting Status**: ✅ **COMPLETE - READY FOR INCEPTION**

**Understanding Confirmed**:
- ✅ Project scope and goals
- ✅ Sprint 11 requirements (GHC-15)
- ✅ All generic rules (GENERAL_RULES, GIT_RULES, PRODUCT_OWNER_GUIDE)
- ✅ Ansible best practices
- ✅ Local project-specific rules
- ✅ Responsibilities and constraints
- ✅ Communication protocols
- ✅ YOLO mode behaviors

**Ready to Proceed**: Yes

**Clarifications Needed**: None

## Artifacts Created

- `progress/sprint_11/sprint_11_contract_review_1.md` (this document)

## Token Usage Statistics

**Phase**: Contracting
**Model**: claude-sonnet-4-5-20250929
**Approximate Token Usage**: 50,000 tokens (reading rules, BACKLOG, PLAN, creating contract)
**Context Windows Read**: 6 major documents + project files

## Next Phase

**Phase 2 - Inception (Analysis)**

**Actions**:
1. Analyze GHC-15 requirements in detail
2. Review Sprints 1-10 artifacts for compatibility
3. Design new collection structure
4. Create analysis document
5. Update PROGRESS_BOARD.md

**Ready to Proceed**: ✅ Yes - All rules understood, no open questions
