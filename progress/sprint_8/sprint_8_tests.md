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

**Status:** PENDING  
**Notes:** Not executed here (requires GitHub credentials/gh access).

---

### Test 2: Ara handler posts to mock server

**Purpose:** Validate registration and event POSTs reach an HTTP endpoint.  
**Expected Outcome:** Mock server logs POST requests to `/api/v1/playbooks/` and `/api/v1/results/` with JSON bodies containing `identifier` and `task/status`.  

**Test Sequence:**
```bash
# Start mock server to capture POSTs
python - <<'PY'
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def _send(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(b'{}')
    def do_POST(self):
        length = int(self.headers.get("content-length", 0))
        body = self.rfile.read(length).decode()
        print("PATH", self.path)
        print("BODY", body)
        self._send()

HTTPServer(("0.0.0.0", 5000), Handler).serve_forever()
PY

# In another shell, run the flow with Ara enabled
cd github_collection
ansible-playbook flow_ara.yml -e "ara_enabled=true ara_api_base_url=http://127.0.0.1:5000 ara_verify_ssl=false"
```

**Status:** PENDING  
**Notes:** Not executed here (no mock server running in this environment). When run, verify console output from mock server shows registration and result POSTs.

---

### Test 3: Auth failure path

**Purpose:** Ensure strict mode fails on auth errors.  
**Expected Outcome:** Play fails when mock server returns 401; failure surfaced due to `ara_fail_on_error=true`.  

**Test Sequence:**
```bash
# Start mock server that returns 401
python - <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(401)
        self.end_headers()

HTTPServer(("0.0.0.0", 5001), Handler).serve_forever()
PY

# Run flow with strict failure on Ara errors
cd github_collection
ansible-playbook flow_ara.yml -e "ara_enabled=true ara_api_base_url=http://127.0.0.1:5001 ara_fail_on_error=true ara_verify_ssl=false"
```

**Status:** PENDING  
**Notes:** Not executed here (no mock server running in this environment). Expect task failure on POST due to 401.

---

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-13       | 3           | 0      | 0      | pending (not run in env) |

## Overall Test Results

**Total Tests:** 3  
**Passed:** 0  
**Failed:** 0  
**Success Rate:** 0% (execution pending)

## Test Execution Notes

Tests not executed in this environment; requires running mock or real Ara endpoint and GitHub credentials for full flow.
