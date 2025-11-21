# rstyczynski.github.pr_status_check_pause

Check PR status with retry and pause mechanism.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `pr_status_check_pause_pr_status_check_delay` (int): Seconds to wait between retry attempts
- `pr_status_check_pause_pr_status_check_retries` (int): Number of retry attempts

### Optional Variables

- `pr_status_check_pause_has_pending_checks` (bool): Whether there are pending checks
- `pr_status_check_pause_attempt_number` (int): Current attempt number

### Output Variables

None

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Check PR status with retries
      ansible.builtin.include_role:
        name: rstyczynski.github.pr_status_check_pause
      vars:
        pr_status_check_pause_pr_status_check_delay: 30
        pr_status_check_pause_pr_status_check_retries: 10
        pr_status_check_pause_has_pending_checks: true
        pr_status_check_pause_attempt_number: 1
```

## License

MIT

## Author

rstyczynski
