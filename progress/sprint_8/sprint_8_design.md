# Sprint 8 - Design

## GHC-13. Ara integration

Status: Proposed (YOLO auto-accepted)

### Requirement Summary
Configure playbooks to emit task-level audit events to an Ara server via REST, with optional token authentication and labels. Provide UUID when absent and document usage.

### Feasibility Analysis

**API Availability:**
- Ara callback plugin available via `python3 -m ara.setup.callback_plugins`.
- REST endpoint configured via env vars `ARA_API_CLIENT=http` and `ARA_API_SERVER=<url>`; optional token via `ARA_API_TOKEN`.

**Technical Constraints:**
- Requires Ara client packages installed in Python environment.
- Requires reachable Ara server; may not be available in this environment.

**Risk Assessment:**
- Network/pip restrictions could block installs; provide optional install steps.
- No live server may limit validation; document manual verification path.

### Design Overview

**Architecture:**
- Add role `ara_setup` (within collection) to configure Ara callback environment variables and optionally install Ara client if enabled.
- Role outputs effective env vars and generated UUID for playbook name when missing.
- Provide sample play vars to set Ara server URL, token, labels.
- Include documentation and test commands.

**Key Components:**
1. `roles/ara_setup/meta/argument_specs.yml` – inputs/outputs.
2. `roles/ara_setup/tasks/main.yml` – validate args, optionally install Ara client (if `ara_setup_install` true), compute callback path, set facts for env vars and playbook UUID.
3. Update `flow.yml` to optionally include ara_setup when `ara_enabled` true.

**Data Flow:**
- Inputs: `ara_enabled`, `ara_server_url`, `ara_token`, `ara_playbook_name`, `ara_labels`, `ara_install`.
- Tasks: validate → optionally pip install → compute callback plugin path → set env facts → export for subsequent roles/play.
- Outputs: `ara_env`, `ara_playbook_uuid`, `ara_labels_effective`.

### Technical Specification

**APIs Used:**
- Ara REST via callback env; no direct API calls in role.

**Scripts/Tools:**
- `python3 -m ara.setup.callback_plugins` to obtain callback path.
- `python3 -m pip install --user ara ansible` (optional, behind flag).

**Ara Identification:**
- Set `ARA_PLAYBOOK_NAME` to tag runs (e.g., `collection-flow-ghc13`).
- Optionally set `ARA_PLAYBOOK_UUID` if you need a specific identifier; otherwise Ara generates one.
- Set `ARA_PLAYBOOK_LABELS` (comma-separated) for sprint/backlog tags (e.g., `sprint-8,GHC-13`).

**Error Handling:**
- Fail if `ara_enabled` and server URL missing.
- Warn (not fail) if install flag true but pip fails when `ara_install_optional` true.

### Implementation Approach

**Step 1:** Add `ara_setup` role with argument spec covering enable flag, server URL, token optional, playbook name/uuid, labels, install toggle.
**Step 2:** Implement tasks to resolve callback path, set env vars, and return outputs.
**Step 3:** Update `flow.yml` to include role when `ara_enabled` true, exporting env vars for downstream tasks.
**Step 4:** Document usage and manual verification steps.

### Testing Strategy

**Functional Tests:**
1. Enabled with server URL and token → verify env facts set.
2. Disabled flag → role no-ops safely.
3. Missing server URL when enabled → fails.

**Edge Cases:**
- Install disabled with missing ara → warn user.

**Success Criteria:**
- Env vars prepared; no breaking changes when disabled.

### Integration Notes
- Keep default `ara_enabled: false` to avoid dependency issues.
- Do not force install unless explicitly requested.

### Design Decisions

**Decision 1:** Use optional install flag
**Rationale:** Avoid failing in restricted environments.

**Decision 2:** Provide UUID generation when playbook name not provided
**Rationale:** Meets requirement for unique identifiers without external dependencies.

### Open Design Questions
None (YOLO mode).

## Design Summary

## Overall Architecture
Optional `ara_setup` role gating Ara env configuration; flow.yml inclusion behind flag.

## Shared Components
- Uses common validate_argument_spec pattern.

## Design Risks
- Without server/install, functionality remains unverified.

## Resource Requirements
- Python/pip, Ara packages, Ara server access.

## Design Approval Status
Accepted (YOLO auto-approval)

## YOLO Mode Decisions
- Proceed without guaranteeing Ara server availability.
- Make installation optional to avoid failures.

## LLM Tokens
Not measurable in this environment; token usage not recorded.
