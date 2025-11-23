# ansible-tricks

Ansible examples and GitHub Collection development project.

## Key Features

### GitHub Collection (rstyczynski.github)

The `./github_collection` directory contains the Ansible Collection with 16 roles for GitHub operations:

**Collection Information:**
- **FQCN**: rstyczynski.github
- **Version**: 1.0.0
- **License**: MIT
- **Ansible Version**: >= 2.9

**Collection Structure:**
- 16 comprehensive roles organized by operation type
- Complete documentation (Collection + role READMEs)
- Variable validation using validate_argument_spec
- Idempotent operations throughout
- FQCN-based role invocation

**Role Categories:**

**Branch Operations** (5 roles):
- `branch_checkout` - Checkout or create Git branches with remote synchronization
- `branch_delete` - Delete Git branches locally and remotely with safety checks
- `branch_pull` - Pull latest changes from remote branch with fast-forward only strategy
- `branch_push` - Push current branch to remote repository
- `branch_switch` - Switch to a different Git branch

**GitHub Authentication** (3 roles):
- `github_precheck` - Verify Git and GitHub CLI installation and authentication status
- `github_auth` - Authenticate GitHub CLI with token from environment or netrc
- `github_logout` - Logout from GitHub CLI

**Pull Request Operations** (5 roles):
- `pr_create` - Create GitHub pull requests
- `pr_comment` - Add comments to GitHub pull requests
- `pr_status_check` - Check GitHub pull request status checks
- `pr_status_check_pause` - Check PR status with retry and pause mechanism
- `pr_merge` - Merge GitHub pull requests with status check validation

**Repository Operations** (3 roles):
- `repo_clone` - Clone and manage GitHub repositories with proper branch handling
- `repo_file_add` - Add files to Git repository staging area
- `repo_commit` - Commit changes to Git repository

**Usage Example:**

```yaml
---
- name: GitHub workflow using Collection
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

## Getting Started

### Prerequisites

- Ansible (version 2.9+)
- Python 3.x
- GitHub CLI (gh)
- Git
- macOS environment (current focus)

### Authentication Setup

GitHub operations require authentication via ~/.netrc file:

```bash
# Create or edit ~/.netrc
cat > ~/.netrc << EOF
machine github.com
login your-github-username
password your-github-token
EOF

# Set proper permissions
chmod 600 ~/.netrc
```

## Recent Updates

### Sprint 8 - Ara integration (tested)

- Added Ara-enabled workflow variant `github_collection/flow_ara.yml` with handler-based REST emission to Ara API.  
- Default `flow.yml` remains without Ara; Ara path is opt-in via `ara_enabled` variables.  
- Documentation and tests: `progress/sprint_8/sprint_8_implementation.md`, `progress/sprint_8/sprint_8_tests.md`, `progress/sprint_8/sprint_8_design.md`, `progress/sprint_8/sprint_8_analysis.md`.
