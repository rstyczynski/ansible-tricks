# rstyczynski.github.github_auth

Authenticate GitHub CLI with token from environment variables or ~/.netrc file.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `github_auth_gh_version` (dict): GitHub CLI version check result
- `github_auth_gh_auth_status` (dict): GitHub CLI authentication status

### Output Variables

- `github_auth_github_token` (string): GitHub authentication token
- `github_auth_netrc_file` (dict): Result of checking .netrc file existence
- `github_auth_netrc_token` (dict): Token extracted from .netrc file
- `github_auth_gh_auth_result` (dict): Result of authenticating with GitHub CLI
- `github_auth_gh_auth_verify` (dict): Result of verifying authentication

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Authenticate with GitHub
      ansible.builtin.include_role:
        name: rstyczynski.github.github_auth
      vars:
        github_auth_gh_version: "{{ precheck_gh_version }}"
        github_auth_gh_auth_status: "{{ precheck_gh_auth_status }}"
```

## License

MIT

## Author

rstyczynski
