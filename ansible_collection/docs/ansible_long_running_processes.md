# Ansible long running processes

## Overview

Ansible operates on managed hosts via SSH connections, controlling execution from the controller host. For long-running operations, the controller and the network are critical resources: failure of either causes the remote process to become orphaned and be killed by the local kernel. Additionally, dealing with `stdout` requires special attention, as Ansible tasks buffer the entire `stdout` before flushing it to the Ansible log, preventing real-time output visibility.

## Problem showcase

Let's examine a simple playbook that executes a bash script to demonstrate the `stdout` buffering problem.

```yaml
---
- name: Regular task execution example
  hosts: localhost
  gather_facts: false
  vars:
    progress_count: 10
    script_path: "{{ playbook_dir }}/scripts/generate_progress.sh"

  tasks:
    - name: "Execute script, expecting to see progress in realtime"
      ansible.builtin.command: "{{ script_path }} {{ progress_count }}"
      register: result

    - name: "Display final output"
      ansible.builtin.debug:
        msg: "{{ result.stdout_lines }}"
```

Run it using the file in this repository:

```bash
cd ansible_collection
ansible-playbook problem_01_regular.yml
```

You'll observe that live stdout streaming does not occur. All output is buffered and flushed to a variable, which is only displayed by the next task after the command completes.

```text
PLAY [Regular task execution example] **************************************************************************************

TASK [Execute script, expecting to see progress in realtime] ***************************************************************
changed: [localhost]

TASK [Display final output] ************************************************************************************************
ok: [localhost] => {
    "msg": [
        "Progress: Step 1 of 10",
        "Progress: Step 2 of 10",
        "Progress: Step 3 of 10",
        "Progress: Step 4 of 10",
        "Progress: Step 5 of 10",
        "Progress: Step 6 of 10",
        "Progress: Step 7 of 10",
        "Progress: Step 8 of 10",
        "Progress: Step 9 of 10",
        "Progress: Step 10 of 10"
    ]
}

PLAY RECAP *****************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## Summary

When designing support for long-running processes, architects must address three critical challenges:

* Controller host failure resilience: The process must survive controller crashes or restarts
* Network failure resilience: The process must continue running even if the network connection between controller and managed host is interrupted
* Real-time output streaming: Long-running process responses must be shipped to the controller host without blocking or losing visibility

## More details about the `stdout` problem

To fully understand the `stdout` buffering problem and explore solution approaches, examine these additional examples:

* `problem_02_async_naive.yml` - Demonstrates a naive async approach with basic monitoring
* `problem_03_async.yml` - Shows an improved async pattern with proper log file monitoring

## Ansible async mode

The general solution for all the identified problems is provided by Ansible's task `async` mode, which is described in this document: [Ansible Async Overview](ansible_async_overview.md). Async mode is a foundational capability that, when used properly, addresses the challenges identified above.

## Ansible Async Patterns

Ansible async mode must be combined with idempotency to deliver business value. The pattern works as follows:

1. First run: The playbook triggers the process in detached mode on the managed host, captures the job identifier associated with the host, and stores it in remote (controller-independent) storage.

2. Subsequent runs: The playbook discovers the existing job identifier for the given host and runs in `async_check` mode, providing resilience for controller and network failures without affecting the main process.

3. Persistent storage: Integration with OCI Object Storage (or other controller-independent storage) completes the resilience architecture by ensuring job state survives controller failures.

4. Output handling: Stdout capture requires additional attention, but async mode opens possibilities to address this issue through log file monitoring and periodic polling.

All patterns are presented and described in detail in the document [Ansible Async Patterns](ansible_async_patterns.md).
