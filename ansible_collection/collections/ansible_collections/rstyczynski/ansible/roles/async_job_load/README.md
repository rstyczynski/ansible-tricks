# async_job_load

Load async job metadata by name for idempotent retrieval (filesystem or OCI backend)

## Synopsis

This role loads previously saved async job metadata by name, enabling idempotent long-running task patterns. Jobs saved with `async_job_save` can be retrieved even after controller restart or in different playbook executions.

## Requirements

- Ansible 2.9 or higher
- For OCI backend: OCI CLI configured with valid credentials

## Role Variables

### Input Variables (Common)

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_load_job_name` | string | yes | - | Unique name for the job to load |
| `async_job_load_playbook_name` | string | no | `{{ ansible_play_name }}` | Playbook identifier to locate job (must match save operation) |
| `async_job_load_host_filter` | string | no | `{{ inventory_hostname }}` | Host filter for job lookup |

### Backend Selection

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_load_backend` | string | no | `filesystem` | Storage backend type (`filesystem` or `oci`) |

### Filesystem Backend Parameters

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_load_state_dir` | string | no | `.ansible_async_state` | Directory where job state files are stored |

### OCI Backend Parameters

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_load_oci_bucket` | string | conditional | - | OCI Object Storage bucket name (required when backend=oci) |
| `async_job_load_oci_namespace` | string | conditional | - | OCI Object Storage namespace (required when backend=oci) |
| `async_job_load_oci_profile` | string | no | `DEFAULT` | OCI CLI profile name |

### Output Variables

| Variable | Type | Description |
|----------|------|-------------|
| `async_job_load_found` | boolean | Whether job was found |
| `async_job_load_ansible_job_id` | string | Ansible job ID for async_status (only if found) |
| `async_job_load_host` | string | Host where job is running (only if found) |
| `async_job_load_metadata` | dict | Job metadata dictionary (only if found) |

## Dependencies

None

## Example Playbook

### Basic Usage (Filesystem Backend)

```yaml
---
- name: Check deployment status
  hosts: web_servers
  gather_facts: true
  tasks:
    - name: Load deployment job by name
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_playbook_name: "web_deployment"
        async_job_load_job_name: "deploy_v2.1.0"

    - name: Display if job was found
      ansible.builtin.debug:
        msg: "Job {{ 'found - checking status' if async_job_load_found else 'not found' }}"

    - name: Check job status (if found)
      ansible.builtin.async_status:
        jid: "{{ async_job_load_ansible_job_id }}"
      register: status
      when: async_job_load_found
      ignore_errors: true

    - name: Display job status
      ansible.builtin.debug:
        msg: |
          Job: deploy_v2.1.0
          Status: {{ 'Completed' if status.finished | default(false) else 'Running' }}
      when: async_job_load_found
```

### OCI Backend Usage

```yaml
---
- name: Check production deployment status
  hosts: production_servers
  gather_facts: true
  tasks:
    - name: Get OCI namespace
      ansible.builtin.command: oci os ns get --query data --raw-output
      register: oci_ns
      delegate_to: localhost
      changed_when: false

    - name: Load job from OCI
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_backend: "oci"
        async_job_load_playbook_name: "production_deployment"
        async_job_load_job_name: "prod_deploy_2025-11-25"
        async_job_load_oci_bucket: "ansible-prod-state"
        async_job_load_oci_namespace: "{{ oci_ns.stdout }}"

    - name: Display loaded metadata
      ansible.builtin.debug:
        var: async_job_load_metadata
      when: async_job_load_found
```

### Idempotent Pattern (with async_job_save)

```yaml
---
- name: Idempotent long-running task
  hosts: app_servers
  gather_facts: true
  vars:
    job_id: "db_migration_v3"
  tasks:
    # STEP 1: Try to load existing job
    - name: Load existing migration job
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_playbook_name: "database_maintenance"
        async_job_load_job_name: "{{ job_id }}"

    - name: Display job status
      ansible.builtin.debug:
        msg: "Migration {{ 'already running' if async_job_load_found else 'not started yet' }}"

    # STEP 2: Start ONLY if not found
    - name: Start migration (only if not exists)
      ansible.builtin.shell: "/opt/db/migrate.sh v3"
      async: 43200  # 12 hours
      poll: 0
      register: migration_task
      when: not async_job_load_found

    # STEP 3: Save if just started
    - name: Save migration job
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_playbook_name: "database_maintenance"
        async_job_save_job_name: "{{ job_id }}"
        async_job_save_ansible_job_id: "{{ migration_task.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
        async_job_save_metadata:
          migration_version: "v3"
          started_at: "{{ ansible_date_time.iso8601 }}"
      when: not async_job_load_found

    # STEP 4: Check status (works for both new and existing)
    - name: Check migration status
      ansible.builtin.async_status:
        jid: "{{ async_job_load_ansible_job_id if async_job_load_found else migration_task.ansible_job_id }}"
      register: status
      ignore_errors: true

    - name: Display migration progress
      ansible.builtin.debug:
        msg: |
          Migration: {{ job_id }}
          Status: {{ 'Completed' if status.finished | default(false) else 'In Progress' }}
          {% if status.failed | default(false) %}
          Error: {{ status.msg | default('Unknown') }}
          {% endif %}
```

### Checking Multiple Jobs

```yaml
---
- name: Check status of multiple batch jobs
  hosts: batch_servers
  gather_facts: true
  vars:
    batch_jobs:
      - "batch_001"
      - "batch_002"
      - "batch_003"
  tasks:
    - name: Check each batch job
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_playbook_name: "batch_processing"
        async_job_load_job_name: "{{ item }}"
      loop: "{{ batch_jobs }}"
      register: job_checks

    - name: Display all job statuses
      ansible.builtin.debug:
        msg: "Job {{ item.item }}: {{ 'Found' if item.async_job_load_found else 'Not Found' }}"
      loop: "{{ job_checks.results }}"
```

## Output Variable Usage

### Check if Job Exists

```yaml
- ansible.builtin.include_role:
    name: rstyczynski.ansible.async_job_load
  vars:
    async_job_load_playbook_name: "my_playbook"
    async_job_load_job_name: "my_job"

- ansible.builtin.debug:
    msg: "Job exists!"
  when: async_job_load_found
```

### Use Job ID with async_status

```yaml
- ansible.builtin.async_status:
    jid: "{{ async_job_load_ansible_job_id }}"
  when: async_job_load_found
  register: job_status
```

### Access Metadata

```yaml
- ansible.builtin.debug:
    msg: |
      Job started by: {{ async_job_load_metadata.operator }}
      Ticket: {{ async_job_load_metadata.ticket }}
      Version: {{ async_job_load_metadata.version }}
  when: async_job_load_found
```

## Best Practices

### Always Check async_job_load_found

Before using output variables, always check if the job was found:

```yaml
# Good
- ansible.builtin.async_status:
    jid: "{{ async_job_load_ansible_job_id }}"
  when: async_job_load_found

# Bad - will fail if job not found
- ansible.builtin.async_status:
    jid: "{{ async_job_load_ansible_job_id }}"
```

### Match playbook_name with Save Operation

The `playbook_name` must match what was used in `async_job_save`:

```yaml
# Save
async_job_save_playbook_name: "web_deployment"
async_job_save_job_name: "deploy"

# Load - must use same playbook_name
async_job_load_playbook_name: "web_deployment"  # ← Same
async_job_load_job_name: "deploy"
```

### Use Conditional Logic for Idempotency

```yaml
# Load first
- ansible.builtin.include_role:
    name: rstyczynski.ansible.async_job_load

# Conditional execution based on found status
- name: Start task
  when: not async_job_load_found

- name: Check status
  when: async_job_load_found
```

### Handle Job Not Found Gracefully

```yaml
- ansible.builtin.include_role:
    name: rstyczynski.ansible.async_job_load
  vars:
    async_job_load_playbook_name: "my_playbook"
    async_job_load_job_name: "my_job"

- name: Handle not found case
  ansible.builtin.debug:
    msg: "Job not found - starting new one"
  when: not async_job_load_found

- name: Handle found case
  ansible.builtin.debug:
    msg: "Job found - checking status"
  when: async_job_load_found
```

## Troubleshooting

### Job Not Found After Controller Restart

**Symptom:** `async_job_load_found: false` for known running job

**Cause:** Filesystem backend lost (controller rebuilt, disk wiped)

**Solution:** Use OCI backend for production to survive controller failures

### Undefined Variable Error

**Error:** `'async_job_load_playbook_name' is undefined`

**Solution:** Always provide `playbook_name` parameter (or rely on default):

```yaml
vars:
  async_job_load_playbook_name: "my_playbook"  # Explicit
  # OR rely on default: {{ ansible_play_name }}
```

### Wrong Job Loaded

**Symptom:** Loaded job ID doesn't match expected task

**Cause:** Multiple playbooks using same `job_name` without unique `playbook_name`

**Solution:** Use different `playbook_name` for each playbook:

```yaml
# Playbook A
async_job_load_playbook_name: "deployment_app1"
async_job_load_job_name: "deploy"

# Playbook B
async_job_load_playbook_name: "deployment_app2"
async_job_load_job_name: "deploy"
```

### OCI Authentication Failure

**Error:** OCI CLI command fails

**Solution:**
```bash
oci setup config      # Configure OCI CLI
oci os ns get         # Test authentication
oci iam region list   # Verify profile works
```

## State File Location

### Filesystem Backend

```
.ansible_async_state/
└── <host>/
    └── <playbook_name>/
        └── <job_name>.json
```

Example: `.ansible_async_state/localhost/my_deployment/deploy_app.json`

### OCI Backend

```
oci://<bucket>/
└── <host>/
    └── <playbook_name>/
        └── <job_name>.json
```

Example: `oci://ansible-state/localhost/my_deployment/deploy_app.json`

## See Also

- `async_job_save` - Save job metadata for later retrieval
- [Ansible Async Documentation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html)
- Collection documentation: `docs/ansible_async_overview.md`

## License

MIT

## Author

rstyczynski
