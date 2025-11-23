# Sprint 8 - Analysis

Status: Complete

## Sprint Overview

Ara integration to emit task-level audit events from GitHub Collection playbooks/roles to an Ara server via REST, ensuring traceability with provided or auto-generated execution identifiers and optional authentication token support.

## Backlog Items Analysis

### GHC-13. Ara integration

**Requirement Summary:**  
Add REST-based emission of task-level audit events to Ara for traceability. Each play execution should be identifiable by a provided identifier or a generated UUID when absent. Support Ara authentication (token if available) and propose alternatives if tokenless. Follow Ara best practices/documentation (ara.recordsansible.org).

**Technical Approach:**  
- Provide a dedicated role (or callback-style helper) that wraps Ara REST calls using `ansible.builtin.uri`.  
- Accept inputs: `ara_api_base_url`, `ara_api_token` (optional), `ara_verify_ssl`, `ara_run_id` (provided or generated), `ara_extra_metadata`.  
- Emit events at task boundaries: start, success/fail, and optionally summary. Use idempotent identifier per play/run to relate events.  
- Centralize HTTP interaction in a shared task file to avoid duplication and enable retries/backoff.  
- Respect `no_log` for token-bearing tasks and avoid leaking request payloads with secrets.  
- Keep integration opt-in through feature flag variable (e.g., `ara_enabled`) to avoid breaking existing flows.

**Dependencies:**  
- Reachable Ara server endpoint (REST API) with correct base URL and version.  
- Valid token if Ara instance enforces auth; otherwise, allow unauthenticated mode when supported.  
- Existing collection roles/playbook flows (flow.yml) to inject Ara integration without breaking current behavior.

**Testing Strategy:**  
- Unit-style checks with localhost by mocking Ara via a local HTTP listener (simple Python HTTP server capturing POSTs) to validate payload structure and error handling.  
- Negative tests for unreachable Ara host and auth failures.  
- Idempotency check: repeated sends with same `ara_run_id` should not duplicate run creation logic beyond initial creation/lookup.  
- Dry-run of flow.yml with ara disabled to ensure no regressions.

**Risks/Concerns:**  
- Unknown exact Ara REST schema/version; need to align payload paths with ara.recordsansible.org docs.  
- Network access to real Ara may be unavailable locally; must rely on mock testing.  
- Avoiding performance impact if emitting on every task—may need batching or minimal payloads.

**Compatibility Notes:**  
- Must not alter existing role interfaces unless adding optional Ara variables with defaults.  
- Preserve idempotency and FQCN usage; avoid changing flow.yml semantics when Ara is disabled.  
- Keep secrets masked (`no_log`) and avoid storing tokens in facts beyond immediate use.

## Overall Sprint Assessment

**Feasibility:** Medium – REST approach is straightforward; primary unknown is Ara API schema and availability of a test endpoint.  

**Estimated Complexity:** Moderate – Requires new integration tasks, error handling, and tests/mocks but limited scope to one feature area.  

**Prerequisites Met:** Partially – Need confirmed Ara API base path and auth expectations; mock server can unblock development if real endpoint is unavailable.  

**Open Questions:** None at this time; defaults assume configurable base URL/token and mockable endpoint.  

## Recommended Design Focus Areas

- Define clear variables and defaults for Ara integration (enable flag, base URL, token, SSL verification, run id).  
- Establish payload schema and endpoint paths based on Ara docs; plan fallbacks if minimal schema is acceptable.  
- Structure code to minimize overhead when Ara is disabled (short-circuit early).  
- Robust retry/backoff and error messaging without leaking secrets.

## Readiness for Design Phase

Confirmed Ready – proceed to elaboration with attention to Ara API schema and mock testing plan.
