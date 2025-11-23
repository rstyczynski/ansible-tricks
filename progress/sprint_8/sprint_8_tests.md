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

### Test 2: Missing server URL when enabled
**Purpose:** Ensure role fails when required URL absent.
**Expected Outcome:** Task fails with clear message.
**Test Sequence (planned):**
```bash
cd github_collection
ansible-playbook -i localhost, flow.yml -e "ara_enabled=true" || true
```
**Status:** PENDING

### Test 3: Disabled flag no-ops safely
**Purpose:** Confirm disabling Ara leaves flow unchanged.
**Expected Outcome:** No Ara env vars set; workflow continues.
**Test Sequence (planned):**
```bash
cd github_collection
ansible-playbook -i localhost, flow.yml -e "ara_enabled=false"
```
**Status:** PENDING

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-13       | 3           | 0      | 0      | pending |

## Overall Test Results

**Total Tests:** 3
**Passed:** 0
**Failed:** 0
**Success Rate:** 0%

## Test Execution Notes
Tests are planned but not executed; requires Ara server and client availability.
