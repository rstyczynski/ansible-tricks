# Ara 

## Install # Configure server

```
mkdir -p ~/.ara/server
podman run --name api-server --detach --tty \
  --volume ~/.ara/server:/opt/ara -p 8000:8000 \
  quay.io/recordsansible/ara-api:latest
```

```
open http://127.0.0.1:8000
```

Source: https://ara.recordsansible.org

## Install & Configure client

```
python3 -m venv venv
source venv/bin/activate
pip3 install ara ara[server] ansible
source <(python3 -m ara.setup.env)
export ARA_API_CLIENT="http"
export ARA_API_SERVER="http://127.0.0.1:8000"
```
Source: 
1. https://ara.readthedocs.io/en/latest/ansible-configuration.html#ansible-configuration
2. https://ara.readthedocs.io/en/latest/ansible-plugins-and-use-cases.html


## ara_test.yml

```
ansible-playbook ara_test.yml
```

Expected answer:

```
(...)
Operations to perform:
  Apply all migrations: admin, api, auth, contenttypes, db, sessions
Running migrations:
  No migrations to apply.
(...)
```

## playbook - add label

```
ansible-playbook ara_label.yml
```

## playbook - add records

```
ansible-playbook ara_record.yml
```

## API by curl

### get tasks by label

label=os%3AMacOSX-15.7.2

curl http://127.0.0.1:8000/api/v1/playbooks?label=$label

playbook_id=$(curl http://127.0.0.1:8000/api/v1/playbooks?label=$label | jq .results[0].id)

curl 127.0.0.1:8000/api/v1/tasks?playbook=$playbook_id | jq

## API Queries by Use Case

### Overview

This section documents practical curl examples for querying Ara records remotely. After running playbooks with Ara enabled (see "Install & Configure client" section), you can query the Ara database to verify execution, check status, trace playbooks, and retrieve results.

**Tested with:** Ara 1.7.3
**Base URL:** http://127.0.0.1:8000/api/v1/ (adjust for your Ara server)
**Prerequisites:** Ara server accessible, playbook ID known (obtain via `ara playbook list`)

### Use Case 1: List All Playbooks

Query all playbooks recorded by Ara.

```bash
# Generic pattern
curl http://<ara-server>/api/v1/playbooks

# Example (Sprint 8 test data)
curl http://127.0.0.1:8000/api/v1/playbooks
```

Expected output (excerpt):
```json
{
  "count": 30,
  "next": "http://127.0.0.1:8000/api/v1/playbooks?limit=20&offset=20",
  "previous": null,
  "results": [
    {
      "id": 30,
      "status": "completed",
      "duration": "00:00:03.189867",
      "created": "2025-11-23T17:05:27.437353Z",
      "started": "2025-11-23T17:05:57.132856Z",
      "ended": "2025-11-23T17:06:00.322723Z",
      "items": {
        "plays": 1,
        "tasks": 10,
        "results": 10,
        "hosts": 1
      }
      ...
    },
    ...
  ]
}
```

### Use Case 2: Get Specific Playbook by ID

Retrieve detailed information about a particular playbook.

```bash
# Generic pattern
curl http://<ara-server>/api/v1/playbooks/<playbook-id>

# Example (Sprint 8 test data - playbook #26)
curl http://127.0.0.1:8000/api/v1/playbooks/26
```

Expected output (excerpt):
```json
{
  "id": 26,
  "status": "completed",
  "duration": "00:00:02.530123",
  "ansible_version": "2.20.0",
  "controller": "1.0.0.0...ip6.arpa",
  "user": "username",
  "path": "/path/to/ara_test.yml",
  "created": "2025-11-23T17:05:27.437353Z",
  "started": "2025-11-23T17:05:57.132856Z",
  "ended": "2025-11-23T17:06:00.322723Z",
  "items": {
    "plays": 1,
    "tasks": 10,
    "results": 10,
    "hosts": 1,
    "files": 1,
    "records": 0
  }
  ...
}
```

### Use Case 3: Check Playbook Execution Status

Extract status from a playbook using jq (optional but recommended).

```bash
# Get full response and filter with jq
curl -s http://127.0.0.1:8000/api/v1/playbooks/26 | jq '.status'

# Expected output
"completed"
```

Possible status values: `completed`, `failed`, `running`, `unknown`

### Use Case 4: List Recent Playbook Runs

Show most recent playbooks with pagination and ordering.

```bash
# Get last 10 playbooks (descending ID order - most recent first)
curl "http://127.0.0.1:8000/api/v1/playbooks?limit=10&order=-id"

# Filter for completed playbooks only
curl "http://127.0.0.1:8000/api/v1/playbooks?status=completed&limit=10"

# Filter for failed playbooks
curl "http://127.0.0.1:8000/api/v1/playbooks?status=failed"
```

### Use Case 5: Trace Playbook Execution Hierarchy

Trace execution from playbook through plays and tasks to results. This requires multiple queries to build the execution hierarchy.

```bash
# Step 1: Get playbook details
PLAYBOOK_ID=26
curl -s http://127.0.0.1:8000/api/v1/playbooks/$PLAYBOOK_ID | jq '.id, .status'

# Step 2: Get plays in the playbook
curl -s "http://127.0.0.1:8000/api/v1/plays?playbook=$PLAYBOOK_ID" | jq '.results | length'

# Step 3: Get tasks in the playbook
curl -s "http://127.0.0.1:8000/api/v1/tasks?playbook=$PLAYBOOK_ID" | jq '.results | length'

# Step 4: Get execution results (task outcomes per host)
curl -s "http://127.0.0.1:8000/api/v1/results?playbook=$PLAYBOOK_ID" | jq '.results[0] | {task, status, changed, duration}'
```

Example trace for playbook #26:
```bash
#!/bin/bash
PLAYBOOK_ID=26
BASE_URL="http://127.0.0.1:8000/api/v1"

echo "=== Playbook $PLAYBOOK_ID ==="
curl -s "$BASE_URL/playbooks/$PLAYBOOK_ID" | jq '{id, status, duration}'

echo -e "\n=== Plays ==="
curl -s "$BASE_URL/plays?playbook=$PLAYBOOK_ID" | jq '.results[] | {id, name, status}'

echo -e "\n=== Tasks ==="
curl -s "$BASE_URL/tasks?playbook=$PLAYBOOK_ID" | jq '.results[] | {id, name, action}'

echo -e "\n=== Results Summary ==="
curl -s "$BASE_URL/results?playbook=$PLAYBOOK_ID" | jq '.results | group_by(.status) | map({status: .[0].status, count: length})'
```

### Use Case 6: Get Task Results for a Playbook

Retrieve all task execution results (outcomes per host).

```bash
# Get all results for playbook #27
curl "http://127.0.0.1:8000/api/v1/results?playbook=27"

# With jq - show key fields
curl -s "http://127.0.0.1:8000/api/v1/results?playbook=27" | jq '.results[] | {task, status, changed, duration}'

# Filter by result status (ok, changed, failed, skipped)
curl "http://127.0.0.1:8000/api/v1/results?playbook=27&status=ok"
curl "http://127.0.0.1:8000/api/v1/results?playbook=27&status=failed"
```

Expected output (excerpt):
```json
{
  "id": 3008,
  "status": "ok",
  "playbook": 27,
  "play": 26,
  "task": 3016,
  "host": 26,
  "started": "2025-11-23T17:06:00.273098Z",
  "ended": "2025-11-23T17:06:00.280474Z",
  "duration": "00:00:00.007376",
  "changed": false,
  "ignore_errors": false
}
```

### Use Case 7: Access Host Information

Query hosts that participated in a playbook run.

```bash
# Get all hosts for playbook #26
curl "http://127.0.0.1:8000/api/v1/hosts?playbook=26"

# With jq - show hostname and facts
curl -s "http://127.0.0.1:8000/api/v1/hosts?playbook=26" | jq '.results[] | {name, facts}'

# Get specific host by name
curl "http://127.0.0.1:8000/api/v1/hosts?name=localhost"
```

Expected output (excerpt):
```json
{
  "id": 26,
  "name": "localhost",
  "playbook": 26,
  "facts": {
    "ansible_distribution": "MacOSX",
    "ansible_distribution_version": "15.7.2",
    ...
  }
}
```

### Use Case 8: Authentication Patterns

Ara servers may require authentication. Use these patterns based on your deployment.

**Pattern 1: Unauthenticated (default for Sprint 8 setup)**

```bash
curl http://127.0.0.1:8000/api/v1/playbooks
```

**Pattern 2: HTTP Basic Authentication**

```bash
curl -u username:password http://ara-server/api/v1/playbooks
curl -u admin:secretpassword http://127.0.0.1:8000/api/v1/playbooks
```

**Pattern 3: Token-Based Authentication (Bearer Token)**

```bash
curl -H "Authorization: Bearer <token>" http://ara-server/api/v1/playbooks
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
     http://127.0.0.1:8000/api/v1/playbooks
```

## Advanced Techniques

### JSON Formatting with jq

Pretty-print JSON responses (requires jq; optional):

```bash
# Pretty-print entire response
curl -s http://127.0.0.1:8000/api/v1/playbooks/26 | jq .

# Extract specific field
curl -s http://127.0.0.1:8000/api/v1/playbooks/26 | jq '.status'

# Extract multiple fields
curl -s http://127.0.0.1:8000/api/v1/playbooks/26 | jq '{id: .id, status: .status, duration: .duration}'

# Filter array results
curl -s http://127.0.0.1:8000/api/v1/results?playbook=26 | jq '.results[] | select(.status == "failed")'

# Count results by status
curl -s http://127.0.0.1:8000/api/v1/results?playbook=26 | jq '.results | group_by(.status) | map({status: .[0].status, count: length})'
```

### Troubleshooting

**Error: 404 Not Found**
```bash
Request:  curl http://127.0.0.1:8000/api/v1/playbooks/999999
Response: {"detail": "Not found."}
Solution: Verify playbook ID exists via `ara playbook list` or list query
```

**Error: Connection Refused**
```bash
Request:  curl http://127.0.0.1:8000/api/v1/playbooks
Response: curl: (7) Failed to connect to 127.0.0.1 port 8000: Connection refused
Solution: Ensure Ara server is running: podman ps | grep api-server
```

**Error: 401 Unauthorized**
```bash
Request:  curl http://ara-server/api/v1/playbooks
Response: {"detail": "Authentication credentials were not provided."}
Solution: Add authentication via -u or -H "Authorization: ..."
```

**Error: Empty Results**
```bash
Request:  curl "http://127.0.0.1:8000/api/v1/playbooks?status=running"
Response: {"count": 0, "results": []}
Solution: This is valid - no playbooks match the filter; try different filter
```

## Reference

### API Endpoints Summary

| Endpoint | Purpose | Query Parameters |
|----------|---------|------------------|
| `/api/v1/playbooks` | List all playbooks | `status`, `limit`, `offset`, `order` |
| `/api/v1/playbooks/<id>` | Get specific playbook | - |
| `/api/v1/plays` | List plays | `playbook`, `limit`, `offset` |
| `/api/v1/tasks` | List tasks | `playbook`, `play`, `limit`, `offset` |
| `/api/v1/results` | List task results | `playbook`, `task`, `host`, `status`, `limit` |
| `/api/v1/hosts` | List hosts | `playbook`, `name`, `limit` |

### Sprint 8 Test Data (Ara IDs #25-30)

- **ID #26:** Test 1 - Environment variable integration (Status: completed)
- **ID #27:** Test 3 - UUID auto-generation (Status: completed)
- **ID #28:** Test data (Status: available)
- **ID #29:** Test 4 - Missing server URL behavior (Status: completed)
- **ID #30:** Test 5 - Custom controller name (Status: completed)

### Common Query Parameters

| Parameter | Values | Example |
|-----------|--------|---------|
| `status` | completed, failed, running, unknown | `?status=failed` |
| `limit` | Integer (default: varies) | `?limit=10` |
| `offset` | Integer | `?offset=20` |
| `order` | Field name, use `-` for descending | `?order=-id` |

## Collection

### Deploy API

```yml
- name: Install ARA with default settings and no persistent API server
  hosts: all
  gather_facts: yes
  roles:
    - ara_api
```

Source: https://galaxy.ansible.com/ui/repo/published/recordsansible/ara/
