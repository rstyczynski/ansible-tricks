# Ansible Collection - rstyczynski.ansible

**Version**: 1.0.0

## Overview

Lightweight persistence for Ansible's native async capabilities, enabling **idempotent** exit-and-resume patterns.

## Philosophy

**Don't Reinvent the Wheel**: Uses Ansible's built-in `async` and `async_status`. Roles ONLY handle job_id persistence by name.

**Idempotent Pattern**: Run the same playbook multiple times - first run starts the task, later runs check status. No special "resume" mode needed.

## Roles

### async_job_save

Saves async job metadata under a **user-provided name** for later retrieval.

### async_job_load

Loads job metadata by name. Returns `async_job_load_found: false` if job doesn't exist (doesn't fail).

## Idempotent Pattern

The key insight: **identify jobs by NAME, not generated ID**.

```yaml
- name: Idempotent long-running task
  hosts: localhost
  vars:
    job_name: "my_data_processing"  # Fixed name
  tasks:
    # STEP 1: Try to load existing job
    - include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_job_name: "{{ job_name }}"

    # STEP 2: Start ONLY if not found
    - shell: "python process_data.py"
      async: 3600
      poll: 0
      register: new_task
      when: not async_job_load_found

    # STEP 3: Save if just started
    - include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_job_name: "{{ job_name }}"
        async_job_save_ansible_job_id: "{{ new_task.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
      when: not async_job_load_found

    # STEP 4: Check status (native async_status)
    - async_status:
        jid: "{{ async_job_load_ansible_job_id if async_job_load_found else new_task.ansible_job_id }}"
      register: status

    - debug:
        msg: "Status: {{ 'DONE' if status.finished else 'RUNNING' }}"
```

**Usage**:
```bash
# First run - starts task
ansible-playbook my_playbook.yml
# Output: "Job 'my_data_processing' NOT FOUND - will start new task"
# Output: "Status: RUNNING"

# Second run - checks status (same command!)
ansible-playbook my_playbook.yml
# Output: "Job 'my_data_processing' FOUND - will check status"
# Output: "Status: RUNNING"

# Third run - sees completion
ansible-playbook my_playbook.yml
# Output: "Status: DONE"
```

## Quick Examples

**Basic wait loop**:
```yaml
- name: Start or check job
  include_role:
    name: rstyczynski.ansible.async_job_load
  vars:
    async_job_load_job_name: "backup_job"

- shell: "/opt/backup.sh"
  async: 7200
  poll: 0
  register: task
  when: not async_job_load_found

- include_role:
    name: rstyczynski.ansible.async_job_save
  vars:
    async_job_save_job_name: "backup_job"
    async_job_save_ansible_job_id: "{{ task.ansible_job_id }}"
    async_job_save_host: "{{ inventory_hostname }}"
  when: not async_job_load_found

# Native async_status with retry
- async_status:
    jid: "{{ async_job_load_ansible_job_id if async_job_load_found else task.ansible_job_id }}"
  register: result
  until: result.finished
  retries: 60
  delay: 10
```

**Parameterized job**:
```bash
ansible-playbook playbook.yml -e "job_name=export_2024"
# Later: run again with same job_name to check
ansible-playbook playbook.yml -e "job_name=export_2024"
```

## Test Scenarios

Four complete examples demonstrating different usage patterns:

**Scenario 1: Basic Idempotent Pattern**
```bash
# Run multiple times - first run starts, later runs check status
ansible-playbook scenario_01_idempotent_basic.yml

# With custom job name
ansible-playbook scenario_01_idempotent_basic.yml -e "job_name=my_job"
```

**Scenario 2: Parameterized Jobs**
```bash
# Accept all parameters from command line
ansible-playbook scenario_02_parameterized.yml \
  -e "cli_job_name=batch_001" \
  -e "cli_command='./process.sh'" \
  -e "cli_timeout=3600"
```

**Scenario 3: Wait Loop with Retries**
```bash
# Automatically wait for completion using native async_status retries
ansible-playbook scenario_03_wait_loop.yml
```

**Scenario 4: Crash Detection**
```bash
# Start long-running task
ansible-playbook scenario_04_crash_detection.yml
# Kill the process manually: pkill -f "sleep 300"
# Run again to detect crash
ansible-playbook scenario_04_crash_detection.yml
```

**Legacy**: All scenarios also available in `long_running_flow.yml` with tags.

## State Files

Jobs saved as: `.ansible_async_state/<job_name>.json`

```json
{
  "job_name": "my_data_processing",
  "host": "localhost",
  "ansible_job_id": "123456.789",
  "save_time": "2025-11-24T16:30:00Z",
  "metadata": {}
}
```

## Requirements

- Ansible 2.9+
- No external dependencies
- No custom modules

## Documentation

- **Ansible async**: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html
- **Task keywords**: https://docs.ansible.com/projects/ansible/latest/reference_appendices/playbooks_keywords.html#task
- **async_status module**: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/async_status_module.html

## Why This Works

1. **Named jobs**: Job identified by user-provided name, not generated ID
2. **Graceful load**: `async_job_load` returns `found: false` if job doesn't exist
3. **Conditional start**: Task only starts when `not async_job_load_found`
4. **Native async**: All async handling via Ansible built-ins

## Repository

https://github.com/rstyczynski/ansible-tricks

## License

MIT
