# Sprint 7 - Design

## GHC-12. Barrier on a comment

Status: Proposed (YOLO auto-accepted)

### Requirement Summary
An Ansible role that waits for a required comment to appear on a GitHub pull request (or issue), resuming when any provided pattern matches. Inputs include pattern list, timeout, polling interval (default 5s), and a selector for latest comment vs full history. Role should integrate into `flow.yml` and include Molecule validation.

### Feasibility Analysis

**API Availability:**
- Use `gh api repos/{owner}/{repo}/issues/{number}/comments` to fetch comments for PRs (PR comments exposed via issues API). Filtering is local via Jinja/regex. gh CLI already used elsewhere in the collection.

**Technical Constraints:**
- Requires authenticated gh CLI and repo context (`github_lab`).
- Polling must respect timeout/interval to avoid rate limiting.
- No custom modules; rely on Ansible + gh CLI.

**Risk Assessment:**
- Rate limiting if interval too small; mitigate with minimum 5s default.
- Regex complexity leading to false positives; document patterns and use multiline-safe search.
- Testing with live GitHub may be flaky; rely on fixtures/Molecule for deterministic checks.

### Design Overview

**Architecture:**
- Role `comment_barrier` under `collections/ansible_collections/rstyczynski/github/roles/`.
- Tasks: validate args, compute retries from timeout/interval, poll comments via gh, evaluate patterns, set outputs, fail on timeout.

**Key Components:**
1. `meta/argument_specs.yml` – defines inputs/outputs per input_output_spec pattern.
2. `tasks/main.yml` – validation, polling loop using `ansible.builtin.command` with gh, JSON parsing, regex matching via `selectattr`/Jinja tests.
3. Optional `README.md` (if time allows) – usage examples and parameters.

**Data Flow:**
- Input vars → validation → compute retries/delay → loop calling gh API → collect comments → match patterns → set `comment_barrier_matched`, `comment_barrier_matched_body`, `comment_barrier_matched_author`, `comment_barrier_matched_at` → exit success; otherwise continue until timeout and fail.

### Technical Specification

**APIs Used:**
- Endpoint: `GET /repos/{owner}/{repo}/issues/{issue_number}/comments`
  - Method: GET (via `gh api`)
  - Purpose: retrieve comments for PR/issue
  - Documentation: https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#list-issue-comments

**Data Structures:**
```yaml
comment_barrier_patterns: ["/approved", "LGTM"]
comment_barrier_repo: rstyczynski/github_lab
comment_barrier_issue_number: 123
comment_barrier_timeout: 300
comment_barrier_interval: 5
comment_barrier_latest_only: true
```

**Scripts/Tools:**
- File: `tasks/main.yml`
  - Purpose: execute polling and matching
  - Interface: role variables as above
  - Dependencies: `gh` CLI, Ansible core

**Error Handling:**
- Fail early if gh not available/authenticated.
- Fail with message after timeout describing patterns searched and time waited.
- Handle empty comment lists gracefully.

### Implementation Approach

**Step 1:** Add `meta/argument_specs.yml` for role inputs/outputs with `[OUTPUT]` prefixes for emitted fields.
**Step 2:** Implement validation task using `ansible.builtin.validate_argument_spec` to enforce required inputs and defaults.
**Step 3:** Compute retries: `retries = ceil(timeout / interval)`; ensure at least 1.
**Step 4:** Poll with `until` loop calling `gh api` to fetch comments, optionally restricting to latest by slicing last item when `comment_barrier_latest_only` true.
**Step 5:** Evaluate regex patterns with Jinja `search` against comment body; on match, register match data and set fact outputs; break loop by `until: comment_barrier_matched`.
**Step 6:** On timeout, fail with clear message summarizing attempts and last comment snippet.
**Step 7:** Integrate role into `github_collection/flow.yml` after existing checks to gate subsequent steps.
**Step 8:** Add Molecule scenario to simulate comment payloads (using vars file) and assert match/timeout behavior; include copy-paste test commands in docs.

### Testing Strategy

**Functional Tests:**
1. Happy path: pattern `/approved` present; role exits success and sets outputs.
2. Pattern list match: multiple patterns, match second one.
3. Timeout path: no matching comments within timeout → fails with message.
4. Latest-only vs full-history toggle: ensure latest-only restricts search.

**Edge Cases:**
1. Empty comments response.
2. gh CLI auth failure → fail fast.

**Success Criteria:**
- Outputs set correctly on first match.
- No custom modules; idempotent and clean retries.

### Integration Notes

**Dependencies:**
- gh CLI installed and authenticated; repo available.
- flow.yml updates must not break previous steps.

**Compatibility:**
- Reuse existing gh usage patterns from other roles.

**Reusability:**
- Pattern-matching logic can be reused for other comment-based controls.

### Documentation Requirements
- Role README with variables, examples (polling for `/approved`), and outputs.
- Update flow docs if applicable.

### Design Decisions

**Decision 1:** Use gh CLI with `gh api` rather than raw curl or custom module.
**Rationale:** Consistent with existing collection, avoids new dependencies.
**Alternatives Considered:** direct GitHub REST via uri module; rejected for added auth handling.

**Decision 2:** Compute retries from timeout/interval and use `until`/`delay` instead of `async` loops.
**Rationale:** Simpler and aligns with idempotent polling.
**Alternatives Considered:** custom while loop with `pause`; unnecessary.

### Open Design Questions
None (YOLO mode).

## Design Summary

## Overall Architecture
Single role plus flow.yml integration; relies on gh CLI and Ansible core modules.

## Shared Components
- Argument spec/validation pattern shared with other roles.

## Design Risks
- Testing without live GitHub may reduce confidence.
- Regex handling must avoid false matches; document expectations.

## Resource Requirements
- gh CLI access, Molecule environment.

## Design Approval Status
Accepted (YOLO auto-approval)

## YOLO Mode Decisions
This sprint was designed in YOLO (autonomous) mode. The following design decisions were made:

### Decision 1: Scope includes PR comments via issues API
**Context:** Requirement mentions comments but not target object.
**Decision Made:** Focus on PR comments (issues endpoint) with flexibility for issues via `comment_barrier_issue_number`.
**Rationale:** PR workflows primary in flow.yml; issues can reuse same endpoint.
**Alternatives Considered:** Separate flags for PR vs issue; unnecessary.
**Risk:** Medium – may need tweaks for review comments endpoint.

### Decision 2: Latest-only flag slices final comment client-side
**Context:** Need option to check only latest comment.
**Decision Made:** Implement boolean toggle to restrict search to last comment.
**Rationale:** Simple and avoids extra API calls.
**Alternatives Considered:** Additional API params; not required.
**Risk:** Low – relies on sorted API response.

### Decision 3: Timeout-driven retries via until/retries
**Context:** Need polling without custom module.
**Decision Made:** Calculate retries and use `until` with `delay` for polling.
**Rationale:** Native Ansible pattern, easy to audit.
**Alternatives Considered:** `async` jobs; more complex.
**Risk:** Low.

## LLM Tokens
Not measurable in this environment; token usage not recorded.
