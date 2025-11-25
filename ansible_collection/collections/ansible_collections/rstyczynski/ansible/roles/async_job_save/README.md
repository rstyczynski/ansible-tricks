# async_job_save

Save async job metadata by name for idempotent retrieval (filesystem or OCI backend)

## Synopsis

This role saves async job metadata with a human-readable name, enabling idempotent long-running task patterns. The job can later be retrieved by name using the `async_job_load` role, even after controller restart or playbook re-execution.

## Requirements

- Ansible 2.9 or higher
- For OCI backend: OCI CLI configured with valid credentials

## Role Variables

### Input Variables (Common)

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_save_job_name` | string | yes | - | Unique name for this job (used as identifier) |
| `async_job_save_ansible_job_id` | string | yes | - | Ansible job ID from async task (from register variable) |
| `async_job_save_host` | string | yes | - | Target host where async task is running |
| `async_job_save_playbook_name` | string | no | `{{ ansible_play_name }}` | Playbook identifier to ensure unique job keys across playbooks |
| `async_job_save_metadata` | dict | no | `{}` | Optional metadata dictionary for job tagging |

### Backend Selection

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_save_backend` | string | no | `filesystem` | Storage backend type (`filesystem` or `oci`) |

### Filesystem Backend Parameters

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_save_state_dir` | string | no | `.ansible_async_state` | Directory to store job state files |

### OCI Backend Parameters

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `async_job_save_oci_bucket` | string | conditional | - | OCI Object Storage bucket name (required when backend=oci) |
| `async_job_save_oci_namespace` | string | conditional | - | OCI Object Storage namespace (required when backend=oci) |
| `async_job_save_oci_profile` | string | no | `DEFAULT` | OCI CLI profile name |

### Output Variables

| Variable | Type | Description |
|----------|------|-------------|
| `async_job_save_state_file` | string | Full path to job state file or OCI URI |

## State File Structure

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

## Dependencies

None

## Example Playbook

### Basic Usage (Filesystem Backend)

```yaml
---
- name: Deploy application with persistent job tracking
  hosts: web_servers
  gather_facts: true
  tasks:
    - name: Start long-running deployment
      ansible.builtin.shell: "/opt/deploy/deploy.sh"
      async: 3600
      poll: 0
      register: deploy_task

    - name: Save deployment job metadata
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_playbook_name: "web_deployment"
        async_job_save_job_name: "deploy_v2.1.0"
        async_job_save_ansible_job_id: "{{ deploy_task.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
        async_job_save_metadata:
          version: "2.1.0"
          operator: "{{ ansible_user_id }}"
          timestamp: "{{ ansible_date_time.iso8601 }}"
```

### OCI Backend Usage

```yaml
---
- name: Deploy with OCI-based job tracking
  hosts: production_servers
  gather_facts: true
  tasks:
    - name: Get OCI namespace
      ansible.builtin.command: oci os ns get --query data --raw-output
      register: oci_ns
      delegate_to: localhost
      changed_when: false

    - name: Start deployment task
      ansible.builtin.shell: "/opt/deploy/deploy.sh"
      async: 7200
      poll: 0
      register: deploy_task

    - name: Save job to OCI Object Storage
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_backend: "oci"
        async_job_save_playbook_name: "production_deployment"
        async_job_save_job_name: "prod_deploy_{{ ansible_date_time.date }}"
        async_job_save_ansible_job_id: "{{ deploy_task.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
        async_job_save_oci_bucket: "ansible-prod-state"
        async_job_save_oci_namespace: "{{ oci_ns.stdout }}"
        async_job_save_metadata:
          environment: "production"
          ticket: "DEPLOY-12345"
```

### Idempotent Pattern (with async_job_load)

```yaml
---
- name: Idempotent deployment pattern
  hosts: app_servers
  gather_facts: true
  vars:
    deployment_id: "deploy_v3.0.0"
  tasks:
    # Try to load existing job
    - name: Check if deployment already running
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_playbook_name: "app_deployment"
        async_job_load_job_name: "{{ deployment_id }}"

    # Start ONLY if not found
    - name: Start deployment (only if not exists)
      ansible.builtin.shell: "/opt/deploy/deploy.sh"
      async: 3600
      poll: 0
      register: new_deploy
      when: not async_job_load_found

    # Save if just started
    - name: Save deployment job
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_playbook_name: "app_deployment"
        async_job_save_job_name: "{{ deployment_id }}"
        async_job_save_ansible_job_id: "{{ new_deploy.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
      when: not async_job_load_found

    # Check status (works for both new and existing)
    - name: Check deployment status
      ansible.builtin.async_status:
        jid: "{{ async_job_load_ansible_job_id if async_job_load_found else new_deploy.ansible_job_id }}"
      register: status
      ignore_errors: true

    - name: Display deployment status
      ansible.builtin.debug:
        msg: "Deployment {{ 'completed' if status.finished else 'in progress' }}"
```

## State File Format

The role saves a JSON file with the following structure:

```json
{
  "job_name": "deploy_app",
  "host": "web01.example.com",
  "ansible_job_id": "j889214147243.9938",
  "save_time": "2025-11-25T10:30:45Z",
  "metadata": {
    "version": "2.1.0",
    "operator": "admin",
    "ticket": "DEPLOY-12345"
  }
}
```

## Best Practices

### Job Naming

Use descriptive, unique names:

```yaml
# Good
async_job_save_job_name: "db_migration_v2.1_{{ ansible_date_time.date }}"
async_job_save_job_name: "backup_{{ environment }}_{{ inventory_hostname }}"

# Avoid
async_job_save_job_name: "job1"
async_job_save_job_name: "test"
```

### Playbook Name

The `playbook_name` parameter prevents collisions when multiple playbooks use the same `job_name`:

```yaml
# Playbook A
async_job_save_playbook_name: "web_deployment"
async_job_save_job_name: "deploy"

# Playbook B (different playbook_name prevents collision)
async_job_save_playbook_name: "api_deployment"
async_job_save_job_name: "deploy"
```

### Metadata Usage

Store operational context for troubleshooting:

```yaml
async_job_save_metadata:
  operator: "{{ ansible_user_id }}"
  ticket: "OPS-12345"
  environment: "production"
  start_time: "{{ ansible_date_time.iso8601 }}"
  command: "{{ deploy_command }}"
  timeout: "{{ deploy_timeout }}"
```

### Backend Selection

**Use Filesystem when:**
- Single operator environment
- Development/testing
- Fast iteration needed
- Controller is stable

**Use OCI when:**
- Multiple operators/teams
- Production deployments
- Controller may be rebuilt
- Disaster recovery requirements

## Troubleshooting

### Undefined Variable Error

**Error:** `'async_job_save_playbook_name' is undefined`

**Solution:** Always provide `playbook_name` parameter (or rely on default):

```yaml
vars:
  async_job_save_playbook_name: "my_playbook"  # Explicit
  # OR rely on default: {{ ansible_play_name }}
```

### OCI Authentication Failure

**Error:** OCI CLI command fails

**Solution:**
```bash
oci setup config      # Configure OCI CLI
oci os ns get         # Test authentication
```

### Permission Denied

**Error:** Cannot create state directory

**Solution:** Ensure write permissions for `async_job_save_state_dir` (default: `.ansible_async_state`)

## See Also

- `async_job_load` - Load saved job metadata by name
- [Ansible Async Documentation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html)
- Collection documentation: `docs/ansible_async_overview.md`

## License

MIT

## Author

rstyczynski
