# Sprint 8 - Functional Tests

## Test Environment Setup

### Prerequisites
- Python 3 available to run a simple mock HTTP server (for Ara endpoint simulation).  
- Network access to chosen host/port (e.g., localhost:5000).  
- `ansible-playbook` available.  
- `github_collection/flow.yml` present.
- Optional: Ara server for end-to-end run  
```bash
docker run --name ara-api --detach -p 8000:8000 docker.io/recordsansible/ara-api:latest
# then run:
# cd github_collection
# ansible-playbook flow_ara.yml -e "ara_enabled=true ara_api_base_url=http://127.0.0.1:8000 ara_verify_ssl=false"
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

**Status:** PASS  
**Notes:** Executed (with GitHub/gh access) while Ara server running; no Ara POSTs issued as expected.

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

**Status:** PASS  
**Notes:** Executed against real Ara server; observed POSTs to `/api/v1/playbooks/` and `/api/v1/results/` with expected payloads.

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

**Status:** PASS  
**Notes:** Executed against real Ara server with valid token; strict mode satisfied (would fail on 4xx).

---

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-13       | 3           | 3      | 0      | tested |

## Overall Test Results

**Total Tests:** 3  
**Passed:** 3  
**Failed:** 0  
**Success Rate:** 100%

## Test Execution Notes

Tests executed against real Ara server with GitHub flow; all passed.
