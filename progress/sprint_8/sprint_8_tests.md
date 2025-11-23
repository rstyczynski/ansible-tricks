# Sprint 8 - Functional Tests

## Test Environment Setup

### Prerequisites
- Network access to a real Ara API server (e.g., http://127.0.0.1:8000).  
- Ara API token if required by the server.  
- `ansible-playbook` available.  
- `github_collection/flow.yml` and `flow_ara.yml` present.  
- If you need a local server, start with podman:  
```bash
podman run --name ara-api --detach -p 8000:8000 quay.io/recordsansible/ara-api:latest
```

## GHC-13 Tests

### Test 1: Ara disabled (no-op path)

**Purpose:** Verify flow runs without Ara emission when `ara_enabled=false`.  
**Expected Outcome:** Play completes normally; no POSTs attempted.  

**Test Sequence:**
```bash
cd github_collection
ansible-playbook flow.yml -e "ara_enabled=false"
```

**Status:** FAIL  
**Notes:** Run against local Ara (podman) aborted during gh authentication (gh auth login failed despite netrc token); workflow did not complete.

---

### Test 2: Ara handler posts to real Ara server

**Purpose:** Validate registration and event POSTs reach Ara API.  
**Expected Outcome:** Ara server receives POSTs to `/api/v1/playbooks/` and `/api/v1/results/` with expected payloads; workflow succeeds.  

**Test Sequence:**
```bash
cd github_collection
export ARA_TOKEN="REPLACE_WITH_TOKEN"
ansible-playbook flow_ara.yml \
  -e "ara_enabled=true ara_api_base_url=http://127.0.0.1:8000 ara_api_token=${ARA_TOKEN} ara_verify_ssl=false"
```

**Status:** FAIL  
**Notes:** Did not reach Ara POSTs; flow aborted at gh authentication failure (same as Test 1) with local podman Ara running on 8000.

---

### Test 3: Strict mode with real Ara server

**Purpose:** Confirm strict mode succeeds when Ara returns 2xx; would fail on auth errors.  
**Expected Outcome:** Play succeeds with `ara_fail_on_error=true` against real server (valid token).  

**Test Sequence:**
```bash
cd github_collection
export ARA_TOKEN="REPLACE_WITH_TOKEN"
ansible-playbook flow_ara.yml \
  -e "ara_enabled=true ara_api_base_url=http://127.0.0.1:8000 ara_api_token=${ARA_TOKEN} ara_fail_on_error=true ara_verify_ssl=false"
```

**Status:** FAIL  
**Notes:** Did not reach Ara POSTs; flow aborted at gh authentication failure before strict-mode validation (podman Ara running).

---

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-13       | 3           | 0      | 3      | failed (gh auth login failed) |

## Overall Test Results

**Total Tests:** 3  
**Passed:** 0  
**Failed:** 3  
**Success Rate:** 0%

## Test Execution Notes

Tests failed: gh CLI authentication failed despite netrc token; workflow aborted before Ara POSTs. Provide valid GitHub token or adjust auth to rerun.
