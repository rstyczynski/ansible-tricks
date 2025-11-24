# Ansible Collection - rstyczynski.ansible

**Version**: 1.0.0

## Overview

General-purpose Ansible utilities. This collection provides lightweight persistence for Ansible's native async task capabilities, enabling playbook exit and resume scenarios.

## Philosophy

**Don't Reinvent the Wheel**: This collection uses Ansible's built-in `async` and `async_status` capabilities. The roles ONLY handle persistence - saving and loading job metadata.

## Roles

### async_job_save

Saves async job metadata (ansible_job_id, host, etc.) to persistent storage for later retrieval.

**What it does**: Persist job_id to filesystem
**What it doesn't do**: Execute async tasks (you use native `async`)

### async_job_load

Loads previously saved job metadata from persistent storage.

**What it does**: Load job_id from filesystem
**What it doesn't do**: Check job status (you use native `async_status`)

## Quick Start

**Example: Start async task, save job_id, wait with native async_status**

```yaml
- name: Long running task with persistence
  hosts: localhost
  tasks:
    # 1. Use native Ansible async
    - name: Start long task
      ansible.builtin.shell: "sleep 60"
      async: 120
      poll: 0
      register: my_task

    # 2. Save job_id for later
    - name: Save job metadata
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_ansible_job_id: "{{ my_task.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
        async_job_save_job_name: "my_long_task"

    # 3. Use native async_status to check
    - name: Wait for completion
      ansible.builtin.async_status:
        jid: "{{ my_task.ansible_job_id }}"
      register: result
      until: result.finished
      retries: 30
      delay: 2
```

**Example: Exit and Resume Pattern**

Start and exit:
```yaml
- name: Start and exit
  hosts: localhost
  tasks:
    - name: Start background task (native async)
      ansible.builtin.shell: "sleep 300"
      async: 600
      poll: 0
      register: bg_task

    - name: Save for resume
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_save
      vars:
        async_job_save_ansible_job_id: "{{ bg_task.ansible_job_id }}"
        async_job_save_host: "{{ inventory_hostname }}"
        async_job_save_job_name: "background_job"

    - debug: msg="Job ID: {{ async_job_save_job_id }}"
```

Resume later:
```yaml
- name: Resume and check
  hosts: localhost
  vars:
    job_id: "background_job_1732450800_a1b2c3d4"
  tasks:
    - name: Load job
      ansible.builtin.include_role:
        name: rstyczynski.ansible.async_job_load
      vars:
        async_job_load_job_id: "{{ job_id }}"

    - name: Check status (native async_status)
      ansible.builtin.async_status:
        jid: "{{ async_job_load_ansible_job_id }}"
      register: status
      delegate_to: "{{ async_job_load_host }}"

    - debug: msg="Finished={{ status.finished }}"
```

## Test Examples

See `long_running_flow.yml` for complete examples:

```bash
# Test 1: Wait for result
ansible-playbook long_running_flow.yml --tags test1

# Test 2: Exit after start
ansible-playbook long_running_flow.yml --tags test2

# Test 3: Resume with job_id
ansible-playbook long_running_flow.yml --tags test3 -e "resume_job_id=<job_id>"

# Test 4: Crash detection
ansible-playbook long_running_flow.yml --tags test4_start
# (kill process, then)
ansible-playbook long_running_flow.yml --tags test4_check -e "crash_job_id=<job_id>"
```

## Requirements

- Ansible 2.9+
- No external dependencies

## Documentation

- Ansible async documentation: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html
- Ansible task keywords: https://docs.ansible.com/projects/ansible/latest/reference_appendices/playbooks_keywords.html#task

## Repository

https://github.com/rstyczynski/ansible-tricks

## License

MIT
