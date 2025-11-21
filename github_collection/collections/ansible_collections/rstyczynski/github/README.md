# Ansible Collection - rstyczynski.github

Ansible Collection for GitHub operations using the GitHub CLI (gh).

## Description

This collection provides a comprehensive set of roles for automating GitHub workflows, including repository management, branch operations, and pull request handling. All roles are designed to work with the GitHub CLI and support idempotent operations.

## Requirements

- **GitHub CLI (gh)**: Version 2.0+ installed and configured
- **Git**: Version 2.0+ for repository operations
- **Ansible**: Version 2.9 or higher
- **Authentication**: GitHub authentication via `~/.netrc` or gh CLI authentication

## Installation

### Local Installation (Development)

This collection is designed for local development and use. Clone the repository and use the collection from the local path:

```bash
# Clone the repository
git clone https://github.com/rstyczynski/ansible-tricks.git
cd ansible-tricks/github_collection

# The collection is ready to use via the collections/ directory
# Configure ansible.cfg to use local collections:
cat <<EOF > ansible.cfg
[defaults]
collections_path = ./collections
EOF
```

### Using in Playbooks

Reference roles using the Fully Qualified Collection Name (FQCN):

```yaml
- name: Example workflow
  hosts: localhost
  tasks:
    - name: Clone repository
      ansible.builtin.include_role:
        name: rstyczynski.github.repo_clone
      vars:
        repo_clone_repo_url: "https://github.com/user/repo.git"
        repo_clone_dest_path: "./repo"
        repo_clone_base_branch: "main"
        repo_clone_new_branch: "feature"
```

## Included Roles

### GitHub Authentication
- **github_precheck**: Verify Git and GitHub CLI installation and authentication status
- **github_auth**: Authenticate GitHub CLI with token from environment or netrc
- **github_logout**: Logout from GitHub CLI

### Repository Operations
- **repo_clone**: Clone and manage GitHub repositories with branch handling
- **repo_file_add**: Add files to Git repository staging area
- **repo_commit**: Commit changes to Git repository

### Branch Operations
- **branch_checkout**: Checkout or create Git branches with remote synchronization
- **branch_switch**: Switch to a different Git branch
- **branch_push**: Push current branch to remote repository
- **branch_pull**: Pull latest changes from remote branch
- **branch_delete**: Delete Git branches locally and remotely with safety checks

### Pull Request Operations
- **pr_create**: Create GitHub pull requests
- **pr_comment**: Add comments to GitHub pull requests
- **pr_status_check**: Check GitHub pull request status checks
- **pr_status_check_pause**: Check PR status with retry and pause mechanism
- **pr_merge**: Merge GitHub pull requests with status check validation

## Usage Example

Complete workflow example using multiple roles:

```yaml
---
- name: GitHub workflow example
  hosts: localhost
  connection: local
  gather_facts: true

  vars:
    repo_url: "https://github.com/user/repo.git"
    dest_path: "./repo"
    base_branch: "main"
    new_branch: "feature-branch"

  tasks:
    - name: Precheck GitHub CLI
      ansible.builtin.include_role:
        name: rstyczynski.github.github_precheck

    - name: Authenticate
      ansible.builtin.include_role:
        name: rstyczynski.github.github_auth
      vars:
        github_auth_gh_version: "{{ github_precheck_gh_version }}"
        github_auth_gh_auth_status: "{{ github_precheck_gh_auth_status }}"

    - name: Clone repository
      ansible.builtin.include_role:
        name: rstyczynski.github.repo_clone
      vars:
        repo_clone_repo_url: "{{ repo_url }}"
        repo_clone_dest_path: "{{ dest_path }}"
        repo_clone_base_branch: "{{ base_branch }}"
        repo_clone_new_branch: "{{ new_branch }}"

    - name: Create feature branch
      ansible.builtin.include_role:
        name: rstyczynski.github.branch_checkout
      vars:
        branch_checkout_new_branch: "{{ new_branch }}"
        branch_checkout_dest_path: "{{ dest_path }}"
        branch_checkout_base_branch: "{{ base_branch }}"
        branch_checkout_push_new_branch: true
```

## Testing

The collection includes a complete workflow playbook (flow.yml) for testing:

```bash
# Syntax check
ansible-playbook flow.yml --syntax-check

# Run complete workflow
ansible-playbook flow.yml

# Verify idempotency (run twice)
ansible-playbook flow.yml
ansible-playbook flow.yml
```

## Variable Naming Convention

All roles follow a consistent variable naming pattern:
- Input variables: `<role_name>_<variable>`
- Output variables: `<role_name>_<variable>`

Example for repo_clone role:
- Input: `repo_clone_repo_url`, `repo_clone_dest_path`
- Output: `repo_clone_repo_exists`, `repo_clone_git_result`

## Idempotency

All roles are designed to be idempotent:
- Repository operations check if resources exist before creating
- Branch operations verify current state before making changes
- PR operations skip if already completed

## Documentation

Each role includes comprehensive documentation:
- Role-specific README.md with usage examples
- Input/Output variable tables in task files
- Variable validation using `validate_argument_spec`

For role-specific documentation, see:
```
roles/<role_name>/README.md
```

## Contributing

This collection is part of the ansible-tricks repository. For issues or contributions:

**Repository**: https://github.com/rstyczynski/ansible-tricks
**Issues**: https://github.com/rstyczynski/ansible-tricks/issues

## License

MIT

## Author

rstyczynski <rstyczynski@users.noreply.github.com>

## Version

1.0.0
