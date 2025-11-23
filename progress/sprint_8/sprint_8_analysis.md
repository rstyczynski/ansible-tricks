# Sprint 8 - Analysis

Status: Complete

## Sprint Overview
Integrate Ara audit logging into playbook runs (GHC-13), emitting task-level events to an Ara server via REST with optional token auth and labels/IDs.

## Backlog Items Analysis

### GHC-13. Ara integration

**Requirement Summary:**
Enable playbooks to send task-level audit events to Ara server via REST. Identify playbook with provided or generated UUID; support token auth if available. Provide labels, names, and configuration for Ara callback.

**Technical Approach:**
- Reuse Ara callback plugin setup via `ara.setup.callback_plugins` as in official docs.
- Provide wrapper tasks/role to set required environment vars (`ARA_API_CLIENT=http`, `ARA_API_SERVER=...`, optional token) and ensure `ANSIBLE_CALLBACK_PLUGINS` includes Ara path.
- Add variables for playbook name/labels and UUID generation when missing.
- Provide helper script or role to install Ara client deps in venv (local-only) if not present.

**Dependencies:**
- Python with Ara installed; internet/pip access may be required.
- Access to Ara server endpoint.
- Existing flow/playbook structure.

**Testing Strategy:**
- Dry-run using http endpoint with mock or local Ara; verify callback env vars set.
- Unit-style check via `ansible.builtin.debug` of env vars when Ara server unreachable.
- Provide manual test commands to run playbook with Ara vars and inspect Ara UI/API.

**Risks/Concerns:**
- No live Ara server in this environment; testing may be limited.
- Network restrictions may block pip installs or Ara calls.
- Callback path varies by Python env; must resolve dynamically via `python3 -m ara.setup.callback_plugins`.

**Compatibility Notes:**
- Should avoid altering existing roles; add new role or tasks for Ara setup to flow.

## Overall Sprint Assessment

**Feasibility:** Medium – straightforward env configuration but requires Ara availability.

**Estimated Complexity:** Moderate – install/setup + flow integration.

**Prerequisites Met:** Partially; need Ara dependency install and server endpoint.

**Open Questions:** None (YOLO assumptions).

## Recommended Design Focus Areas
- Parameterize Ara server URL/token/playbook name/labels.
- Safe UUID generation when missing.
- Idempotent env setup without persistent side effects.
- Provide opt-out if Ara endpoint unreachable.

## Readiness for Design Phase
Confirmed Ready

## YOLO Mode Decisions
### Assumption: No live Ara server
**Issue:** Testing against Ara may be blocked.
**Assumption Made:** Proceed with configuration role and document manual test; mark tests pending.
**Risk:** Medium – behavior unverified until real server available.

### Assumption: Install via pip optional
**Issue:** Env may not allow installing Ara.
**Assumption Made:** Document pip install steps and allow role to skip install if disabled.
**Risk:** Medium – users must install manually if blocked.

## LLM Tokens
Not measurable in this environment; token usage not recorded.
