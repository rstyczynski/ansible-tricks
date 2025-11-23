# Sprint 8 - Design

## GHC-13. Ara integration

Status: Proposed

### Requirement Summary

Emit task-level audit events from collection playbooks/roles to an Ara server via REST using handlers, following Ara documentation (ara.recordsansible.org). Each execution must have a stable run identifier (provided or generated UUID). Support Ara authentication token when available and allow unauthenticated mode if Ara permits. Integration must be opt-in and non-breaking for existing flows.

### Feasibility Analysis

**API Availability:**  
Ara exposes REST endpoints `/api/v1/playbooks/` (play/run registration) and `/api/v1/results/` (task events) used by Ara’s callback/handlers (see REST API docs at https://ara.readthedocs.io/en/latest/api-documentation.html#built-in-api-browser-interface which lists these endpoints). POSTing JSON via `ansible.builtin.uri` is feasible within handlers.  

**Technical Constraints:**  
- Network access to Ara may be unavailable; must allow mock endpoint.  
- Auth token optional; must never leak in logs.  
- Handler-driven flow means events are sent on notify/flush; ensure timely flush where needed.  

**Risk Assessment:**  
- API schema drift: minimize payload fields and align to docs.  
- Performance overhead: mitigate with opt-in flag and lean payloads.  
- Token leakage: guard with `no_log` and avoid returning token.  
- Unreachable Ara: provide retry/backoff and configurable strictness (`ara_fail_on_error`).

### Design Overview

**Architecture:**  
- Add shared Ara handlers (play-level) referenced from `flow.yml`.  
- Handlers: `ara_register_run` (register run/play) and `ara_send_event` (task-level event).  
- Tasks set `ara_event_payload` facts and `notify` handlers; `meta: flush_handlers` used at checkpoints to send promptly.  
- Run identifier determined once per play (provided or generated UUID) and reused by handlers.  
- Handler/callback approach aligns with Ara guidance on callbacks at https://ara.readthedocs.io/en/latest/ansible-plugins-and-use-cases.html#ara-default-callback-recording-playbooks-from-ansible.  

**Key Components:**  
1. **Run Context Fact:** `ara_run_id` generated via `community.general.uuid` (or Jinja fallback) if not provided.  
2. **Handler `ara_register_run`:** POST to `/api/v1/playbooks/` with identifier/metadata; gated by `ara_enabled` (per Ara run registration workflow in docs).  
3. **Handler `ara_send_event`:** POST to `/api/v1/results/` using `ara_event_payload` (fields: status, task, host, duration, details) with retries/backoff (aligned to Ara result submission in docs).  
4. **Configuration Vars:** `ara_enabled`, `ara_api_base_url`, `ara_api_token` (optional), `ara_verify_ssl` (default true), `ara_run_id`, `ara_default_metadata` (dict), `ara_fail_on_error` (bool).  
5. **Usage Pattern:** Tasks set `ara_event_payload` fact then `notify: ara_send_event`; early task `notify: ara_register_run`; handlers run on `meta: flush_handlers` or play end.  

**Data Flow:**  
Play/role sets Ara vars → establish `ara_run_id` → tasks populate `ara_event_payload` and notify → handlers POST to Ara REST → Ara records events.

### Technical Specification

**APIs Used:**  
- `POST {base_url}/api/v1/playbooks/` with identifier/metadata (referenced in https://ara.readthedocs.io/en/latest/api-documentation.html#built-in-api-browser-interface).  
- `POST {base_url}/api/v1/results/` for task events (status/host/task/duration/details) (same section).  
- Headers: `Authorization: Bearer <token>` when provided; `Content-Type: application/json`.  

**Data Structures (example payloads):**
```json
{
  "identifier": "123e4567-e89b-12d3-a456-426614174000",
  "name": "github_collection_flow",
  "status": "running",
  "metadata": {
    "commit": "abc123",
    "branch": "main"
  }
}
```
```json
{
  "playbook": "123e4567-e89b-12d3-a456-426614174000",
  "task": "pr_status_check",
  "status": "ok",
  "host": "localhost",
  "duration": 1.23,
  "details": {
    "message": "task finished",
    "changed": false
  }
}
```

**Scripts/Tools:**  
- `ansible.builtin.uri`, `ansible.builtin.set_fact`; optional `community.general.uuid` for ID generation. No external scripts.  

**Error Handling:**  
- If `ara_enabled` is false, handlers exit immediately.  
- HTTP failures: retry/backoff and warn; if `ara_fail_on_error` true, fail the play.  
- Token usage marked with `no_log: true`; token never returned in facts.

### Implementation Approach

**Step 1:** Add Ara handler tasks file (e.g., `handlers/ara.yml`) and reference it in `flow.yml` handlers.  
**Step 2:** Define defaults (enable flag, base URL, token, SSL verify, fail_on_error, metadata) in a shared vars file or play vars.  
**Step 3:** Generate `ara_run_id` early if absent; store as fact.  
**Step 4:** Implement handlers `ara_register_run` and `ara_send_event` with `uri`, retries, and `no_log` around token.  
**Step 5:** Update key tasks to set `ara_event_payload` and `notify: ara_send_event`; use `meta: flush_handlers` after major steps to emit promptly.  
**Step 6:** Document handler usage and examples (enable/disable, token/no token, mock testing).  

### Testing Strategy

**Functional Tests:**  
1. Ara disabled: handlers short-circuit; play unaffected.  
2. Mock server: receive registration and task event POSTs with expected fields.  
3. Auth failure simulation: invalid/missing token → failure/warn per `ara_fail_on_error`.  
4. Retry behavior: unreachable host → retries then warn/fail based on strictness flag.  

**Edge Cases:**  
1. Provided `ara_run_id` reused: tolerate existing run (handle 409/duplicate).  
2. SSL verification toggle respected.  
3. Empty metadata handled gracefully.  

**Success Criteria:**  
- Opt-in flag works; existing flows unaffected when disabled.  
- Handler POSTs match expected schema (identifier, task status, host, details).  
- Token guarded with `no_log` and not exposed in outputs.  
- Errors informative without leaking secrets.

### Integration Notes

**Dependencies:** Builtins only; optional `community.general.uuid` if permitted.  
**Compatibility:** Additive; when `ara_enabled` is false no behavior change.  
**Reusability:** Handlers can be reused by other playbooks needing Ara audit.

### Documentation Requirements

- README section on Ara handler usage, variables, and examples (enable/disable, token/no token, mock testing).  
- Reference Ara docs (ara.recordsansible.org) and note security handling (`no_log`, token optional).  

### Design Decisions

**Decision 1:** Use shared handlers (not a new role) with `notify`/`flush_handlers`, aligning with Ara handler integration guidance (https://ara.readthedocs.io/en/latest/ansible-plugins-and-use-cases.html#ara-default-callback-recording-playbooks-from-ansible).  
**Decision 2:** Use `ansible.builtin.uri` with optional token header; avoid external deps.  
**Decision 3:** Generate or accept `ara_run_id` and reuse across events; store only in play scope.  
**Decision 4:** Provide `ara_fail_on_error` to control strictness; default to warn to avoid breaking flows.  

### Open Design Questions

None.

---

# Design Summary

## Overall Architecture

Shared Ara handlers register the play/run and emit task events via REST when notified by tasks. Integration is opt-in, token-aware, and relies on handler flushes to deliver events promptly.

## Shared Components

- Ara handlers for POSTing to `/api/v1/playbooks/` and `/api/v1/results/`.  
- Run ID generator fact reused by handlers.  
- Retry/backoff and `no_log` token handling.  

## Design Risks

- Ara API schema mismatch (mitigate with minimal payloads and mock validation).  
- Performance overhead if overused (mitigate with lean payloads and selective notify).  
- Token leakage (mitigate with `no_log` and scoped facts).  

## Resource Requirements

- Ansible builtins; optional `community.general.uuid`.  
- Access to Ara endpoint or mock server for testing.

## Design Approval Status

Awaiting Review
