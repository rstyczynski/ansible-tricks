# Sprint 7 - Functional Tests

## Test Environment Setup

### Prerequisites
- gh CLI authenticated against GitHub with access to `github_lab` repo.
- Ansible installed; run from repository root.
- Internet access to GitHub API.
- Variables may override defaults in flow.yml as needed.

## GHC-12 Tests

### Test 1: Approval comment triggers barrier (happy path)

**Purpose:** Validate barrier succeeds when `/approved` comment exists.

**Expected Outcome:** Role exits successfully and exposes matched outputs.

**Test Sequence:**
```bash
cd github_collection
# Create/ensure PR exists using existing flow defaults
ansible-playbook -i localhost, flow.yml \
  -e "comment_barrier_timeout=120" \
  -e "comment_barrier_interval=5" \
  -e "comment_barrier_patterns=['/approved']"
```

**Status:** PENDING (not executed here)

**Notes:** The flow posts `/approved (auto)`; barrier should pass on that comment.

---

### Test 2: Pattern list match on alternative string

**Purpose:** Ensure multiple patterns are honored.

**Expected Outcome:** Barrier releases when any listed pattern matches.

**Test Sequence:**
```bash
cd github_collection
ansible-playbook -i localhost, flow.yml \
  -e "pr_comment='LGTM'" \
  -e "comment_barrier_patterns=['/approved','LGTM']" \
  -e "comment_barrier_timeout=120"
```

**Status:** PENDING

**Notes:** Expects success on "LGTM" comment.

---

### Test 3: Timeout when no matching comment

**Purpose:** Verify failure path when no pattern matches before timeout.

**Expected Outcome:** Role fails after ~30s with clear message.

**Test Sequence:**
```bash
cd github_collection
ansible-playbook -i localhost, flow.yml \
  -e "pr_comment='no-approval'" \
  -e "comment_barrier_patterns=['/approved']" \
  -e "comment_barrier_timeout=30" \
  -e "comment_barrier_interval=5"
```

**Status:** PENDING

**Notes:** Should fail; ensure CI handles failure as expected.

---

### Test 4: Latest-only toggle

**Purpose:** Confirm latest-only flag restricts search to newest comment.

**Expected Outcome:** Barrier ignores older approval if latest comment does not match.

**Test Sequence:**
```bash
cd github_collection
ansible-playbook -i localhost, flow.yml \
  -e "comment_barrier_latest_only=true" \
  -e "comment_barrier_patterns=['/approved-latest']" \
  -e "comment_barrier_timeout=120"
```

**Status:** PENDING

**Notes:** Requires crafting comments to ensure latest comment matches desired pattern.

---

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-12       | 4           | 0      | 0      | pending |

## Overall Test Results

**Total Tests:** 4
**Passed:** 0
**Failed:** 0
**Success Rate:** 0%

## Test Execution Notes
Tests were not executed in this environment; flows and commands are provided for follow-up validation.
