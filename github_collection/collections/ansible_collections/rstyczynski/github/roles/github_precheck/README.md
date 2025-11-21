# rstyczynski.github.github_precheck

Verify Git and GitHub CLI installation and authentication status.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

None

### Output Variables

- `github_precheck_git_version` (dict): Git version information
- `github_precheck_gh_version` (dict): GitHub CLI version information
- `github_precheck_gh_auth_status` (dict): GitHub CLI authentication status

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Run GitHub precheck
      ansible.builtin.include_role:
        name: rstyczynski.github.github_precheck
```

## License

MIT

## Author

rstyczynski
