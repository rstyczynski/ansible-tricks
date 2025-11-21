# rstyczynski.github.github_logout

Logout from GitHub CLI.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `github_logout_gh_version` (dict): GitHub CLI version check result
- `github_logout_gh_auth_result` (dict): GitHub CLI authentication result

### Output Variables

- `github_logout_gh_logout_result` (dict): Result of logging out from GitHub CLI

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Logout from GitHub
      ansible.builtin.include_role:
        name: rstyczynski.github.github_logout
      vars:
        github_logout_gh_version: "{{ precheck_gh_version }}"
        github_logout_gh_auth_result: "{{ auth_result }}"
```

## License

MIT

## Author

rstyczynski
