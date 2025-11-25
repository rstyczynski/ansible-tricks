# Ansible Async Mode: Technical Overview

## Introduction

Ansible's asynchronous execution mode allows long-running tasks to execute independently of the controller's SSH connection, protecting operations from network failures and freeing controller resources. This feature is essential for tasks that exceed typical SSH timeout windows (10+ minutes) or when managing multiple long-running operations concurrently.

## How Async Mode Works

### Basic Mechanism

When a task is marked with `async` parameter, Ansible:

1. Starts the task as a detached process on the managed host
2. Creates a tracking file in `~/.ansible_async/<job_id>` containing PID and status information
3. Closes the SSH connection (with `poll: 0`) or periodically reconnects to check status (with `poll: N`)
4. Returns control to the controller immediately or after completion

```yaml
- name: Long database migration
  ansible.builtin.command: /opt/db_migrate.sh
  async: 43200        # Maximum runtime: 12 hours
  poll: 0             # Fire-and-forget mode
  register: job_info
```

![Async/Idempotent job model](model_vanilla.png)

### Polling Modes

**`poll: 0` (Fire-and-Forget):** Controller starts the task and continues immediately. Status must be checked manually using `async_status` module, potentially in a separate playbook execution hours or days later.

**`poll: N` (Automatic Monitoring):** Controller checks task status every N seconds until completion or timeout. Connection is re-established only for status checks, not maintained continuously.

## Key Technical Details

### Process Isolation

The detached process survives:

- Controller shutdown or crash
- Network connectivity issues
- SSH session timeouts

### Tracking File Location

On Managed Host Ansible async maintains `~/.ansible_async/<random_job_id>` file. It's configurable via: `async_dir` in `ansible.cfg` or `ANSIBLE_ASYNC_DIR` environment variable.

The file contains JSON-formatted status data including:

- Process PID
- Start time
- Return code (when completed)
- stdout/stderr output

### Status Checking

```yaml
- name: Check job status later
  ansible.builtin.async_status:
    jid: "{{ job_info.ansible_job_id }}"
  register: result
  until: result.finished
  retries: 300
  delay: 60
```

## Limitations

### Ansible Native Async

- Task output buffered in memory on managed host
- Requires sufficient disk space in `async_dir`
- No progress reporting during execution
- Callback plugins don't receive intermediate updates
- Results file survives process death but not managed host crash

## Design patterns

Refer to `ansible_async_patterns.md` to get information about design patterns.

## References

### Ansible Official Documentation
- [Asynchronous Actions and Polling](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html)
- [async_status Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/async_status_module.html)
- [async_dir Configuration](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#async-dir)
