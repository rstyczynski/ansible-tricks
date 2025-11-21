# rstyczynski.github.pr_create

Create GitHub pull requests.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `pr_create_gh_version` (dict): GitHub CLI version check result
- `pr_create_gh_auth_status` (dict): GitHub CLI authentication status
- `pr_create_dest_path` (string): Destination path to the git repository
- `pr_create_base_branch` (string): Base branch for PR

### Optional Variables

- `pr_create_pr_title` (string): PR title (optional)
- `pr_create_pr_body` (string): PR body/description (optional)

### Output Variables

- `pr_create_current_branch` (dict): Current branch name
- `pr_create_remote_branch_check` (dict): Result of checking if branch is pushed
- `pr_create_existing_pr` (dict): Existing PR number if found
- `pr_create_final_pr_title` (string): Final PR title to use
- `pr_create_final_pr_body` (string): Final PR body to use
- `pr_create_pr_create_result` (dict): Result of creating PR

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Create pull request
      ansible.builtin.include_role:
        name: rstyczynski.github.pr_create
      vars:
        pr_create_gh_version: "{{ precheck_gh_version }}"
        pr_create_gh_auth_status: "{{ precheck_gh_auth_status }}"
        pr_create_dest_path: "./repo"
        pr_create_base_branch: "main"
        pr_create_pr_title: "Add new feature"
        pr_create_pr_body: "This PR adds a new feature"
```

## License

MIT

## Author

rstyczynski
