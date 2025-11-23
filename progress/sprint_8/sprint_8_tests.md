# Sprint 8 - Functional Tests

## Test Environment Setup

### Prerequisites
- Ara server accessible via HTTP.
- Ara client installed (`python3 -m pip install --user ara ansible`).
- Ansible configured to allow environment variables for callback plugins.

## GHC-13 Tests

### Test 1: Enable Ara with server URL and token
**Purpose:** Verify env vars are set and callback path resolved.
**Expected Outcome:** Role sets `ARA_API_CLIENT`, `ARA_API_SERVER`, optional `ARA_API_TOKEN`, and `ANSIBLE_CALLBACK_PLUGINS` includes Ara path.
**Test Sequence (planned):**
```bash
cd github_collection
ansible-playbook -i localhost, flow.yml \
  -e "ara_enabled=true" \
  -e "ara_server_url=http://127.0.0.1:8000" \
  -e "ara_token=example" \
  -e "ara_playbook_name='ara-demo'" \
  -e "ara_install=false"
```
**Status:** PENDING

Reference: follow `ARA_USAGE.md` to export callback env vars before running.

**Identification:** include env vars when exporting callbacks, e.g.:
```bash
export ARA_PLAYBOOK_NAME="collection-flow-ghc13"
export ARA_PLAYBOOK_LABELS="sprint-8,GHC-13"
# optional explicit UUID
# export ARA_PLAYBOOK_UUID="<your-uuid>"
```

**Execution/Result:** Manual run recorded in Ara at `http://127.0.0.1:8000/results/578.html` (PASS).

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-13       | 1           | 1      | 0      | completed |

## Overall Test Results

**Total Tests:** 1
**Passed:** 1
**Failed:** 0
**Success Rate:** 100%

## Test Execution Notes
Validated run visible in Ara at `http://127.0.0.1:8000/results/578.html`. Additional negative/disable scenarios can be added later if needed.
