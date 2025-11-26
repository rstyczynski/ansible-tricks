# Ansible Async Mode: Technical Overview

Ansible playbooks are sets of sequentially executed tasks on managed hosts. This default sequential and blocking execution nature makes it difficult to handle long-running subprocesses that are frequently used in database operations, for example. What is straightforward in Ansible for short-lived operations requires more engineering for long-running processes. This document describes methods to handle long-running processes efficiently.

## Challenges

Ansible operates on managed hosts via SSH connections, controlling execution from the controller host. For long-running operations, the controller and the network are critical resources: failure of either causes the remote process to become orphaned and be killed by the local kernel. Additionally, dealing with stdout requires special attention, as Ansible tasks buffer the entire stdout before flushing it to the Ansible log, preventing real-time output visibility.

## Asynchronous mode

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

On the managed host, Ansible async maintains a tracking file at `~/.ansible_async/<random_job_id>`. This location is configurable via `async_dir` in `ansible.cfg` or the `ANSIBLE_ASYNC_DIR` environment variable.

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
- Results file survives process death but not managed host crash

## Design Patterns

Refer to [Ansible Async Patterns](ansible_async_patterns.md) for detailed information about design patterns that extend async mode with idempotency and persistent state management.

## References

### Ansible Official Documentation

- [Asynchronous Actions and Polling](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html)
- [async_status Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/async_status_module.html)
