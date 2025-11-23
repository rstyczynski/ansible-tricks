# GitHub Collection

version: 0.1

GitHub Collection is set of Ansible roles to interact with repository, branches, pull requests, etc. It's based on GitHub CLI to provide idempotent interface for Ansible playbooks.

## Overview

Project aim is to deliver all the features listed in a below Backlog. Backlog Items selected for implementation are added to iterations detailed in `PLAN.md`. Full list of Backlog Items presents general direction and aim for this project.

## Testing

flow.yml creates complete end-to-end test flow operating on github_lab repository. Test file added to the repository by `repo_file_add.yml` Task-set is `./github_task-sets/1.trigger`. Change this file before each test to add to the main branch via pull request - coded by `flow.yml`. You may not change the file to cover test of not changed directory - it's important to handle such cases in correct way.

## Non functional requirements

### Idempotency

Each GitHub Role is idempotent, what means that executed multiple times with the same parameters or in the same context doe not provide duplicated change. The desired change is done only one. In some faces additional specification of behavior is required e.g. adding a comment mey require additional argument to control idempotency scope: last comment or full comment history, what should be handled in analysis, design, implementation, etc.

### Toolset

On this stage Collection uses gh (GitHub CLI) and regular git utilities as main interface.

### Associated repositories

GitHub API is being analyzed in `https://github.com/rstyczynski/github_tricks`, where various aspects of GitHub API are investigated. Use knowledge gathered in this place.

## Backlog

### GHC-1. Validation of current codebase

Initial codebase in ./github_task-sets directory consist of authentication, clone, commit, file_add, pull requests, and branch Ansible task file orchestrated together by flow.yml. Development repository is available and cloned to ./github_lab directory; required authentication is in ~/.netrc file available in the system.

Current code has:

1. Task-set input variables enumerated
2. Task-set output variables enumerated
3. Task-set variables prefixed by input file name without prefix
4. Task-set variables check module added as first task
5. flow.yml use external variables co interface with operator
6. flow.yml sets variables using tasks'vars for each Task-set invocation

Notes:

1. Add input / output tables at top of the file
2. Table contains: name, type, description
3. Tables are readable - required white spaces are in place
4. Task level comments are not required and not in place as it’s already known from task name

### GHC-2. Prepare tools and techniques

Project is coded using Ansible on OSX. It is mandatory to document system configuration to prepare for development. It should be validated that user has all tools and required access to github repository. Use git, gh, and `.netrc` to specify token access. Do not describe how to get the toke - it's assumed the user know hows to operate GitHub.

### GHC-3. GitHub Collection

Transform all existing task-sets from `github-task-sets` directory into Ansible Roles gathered in GitHub Collection with FQCN `rstyczynski.github`. Main `flow.yml` uses now roles from this collection. On this stage collection is kept locally in `./collections/ansible_collections` to be available for the playbook without any installation.

|Item|Value|
|---|---|
|Collection FQCN|rstyczynski.github|
|Product directory|$repo_root/github_collection|
|Collection working directory|$repo_root/github_collection/collections/ansible_collections|
|flow.yml location|$repo_root/github_collection/flow.yml|

Having it update trigger file `1.trigger` and process `flow.yml` that should execute. In case of execution failure due to status check timeout, execute again to register success. Propose more tests to be executed.

### GHC-4. GitHub Collection roles support input / output specification

Role validates arguments and document produced attributes following `input_output_rule_spec.md` specification available in Ansible specific rules. The rules are available in RUBStrikesBack or in this project's `rules/specific/ansible` directory.

### GHC-5. GitHub Collection documentation

Produce `ansible-doc` documentation for all the roles concluding this task. In case of missing description for a role - add it. You can do it as we are working with generic GitHub procedures. Use up to five sentences to describe each role. The same for arguments and output attributes.

### GHC-6. GitHub Collection HTML documentation generation

Generate HTML documentation site for the entire collection using `antsibull-docs` tool. The documentation should include all 16 roles with their argument specifications, descriptions, and parameter details in a browsable Sphinx-based format. Provide a script (`generate_html_docs.sh`) that automates the process of initializing the Sphinx site, installing dependencies, and building the HTML documentation. The build artifacts (Sphinx source, build scripts) should remain in the construction directory (`docs_html/`), and only the final HTML output should be copied to the collection's `docs/html/` directory (Ansible standard) at `collections/ansible_collections/rstyczynski/github/docs/html/index.html`. The documentation can be served locally or published to a web server. Follow the official Ansible documentation guide: <https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html>

### GHC-7. Roles uses argument specification at meta

Make sure that all roles use argument specification at meta directory. Do not keep argument specification for rules inline, having them in meta directory. Use `ansible.builtin.validate_argument_spec` module with spec taken from meta directory.

```
- name: "Branch: Validate arguments"
  ansible.builtin.validate_argument_spec:
    argument_spec: "{{ (lookup('file', role_path + '/meta/argument_specs.yml') | from_yaml).argument_specs.main.options }}"
```

### GHC-8. GitHub Pages deploy workflow preparation

Prepare and configure GitHub Pages deployment workflow for the collection documentation. The workflow should automatically build HTML documentation using `generate_html_docs.sh` and deploy it to GitHub Pages whenever changes are pushed to the main branch. Configure repository settings to enable GitHub Pages with GitHub Actions as the source. 

Update `galaxy.yml` documentation URL to point to the published GitHub Pages site. The workflow file is located at `.github/workflows/docs.yml` and should trigger on pushes to `master`/`main` branch when files in `github_collection/` directory change. 

Follow GitHub's official documentation for Pages deployment: <https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site>

### GHC-9. GitHub TOKEN is removed as soon as it's possible from facts.

GitHub token taken from netrc file is a secret accessible only for login time. On a file system netrc file is protected with 600 access rights, and the same pattern must be seen in GitHub Collection i.e. TOKEN may never leave very specific context.

Strict requirements is to remove it from exposed outputs, and keep in facts as short time as possible.

### GHC-10. gh assumes authentication is in place

It's not required to additionally control authentication status with `github_precheck_gh_auth_status` variable. It may be keeps in exposed variables, however GitHub Collection should never explicitly use it, as it's clearly not required. gh CLI will react in its way on improper authentication context. Remove all precheck variable checks from all the roles e.g.

```
- name: "PR Status: Fail if gh CLI is not authenticated"
 ansible.builtin.fail:
    msg: "GitHub CLI is not authenticated. Please run: gh auth login"
 when: pr_status_check_gh_version.rc == 0 and pr_status_check_gh_auth_status.rc != 0
```

### GHC-11. Precheck role halts task flow in case of missing dependencies

Precheck role set some output values, but no other role uses it on this stage. Intention  of precheck is to halt processing with error in case of missing dependencies, not to expose variables for further use. Remove all instances of using precheck outputs by other role e.g. ` github_auth_gh_version`.

### GHC-12. Barrier on a comment

Role waits for a comments to release continuation of the work. Expected comment is defined as regexp, jinja, anything else whatever will make expected comment definition flexible using regular Ansible capabilities. Custom module is not permitted; just pure Ansible / Jinja2 features.

It's expected that role will take at least following arguments:

1. pattern list to release operation
2. timeout waiting for comment
3. pooling interval with default value of 5 seconds
4. latest comment / all comments

### GHC-13. Ara integration

Playbook emits task level audit events to Ara server trough REST interface for remote traceability and audit log. The play is identified by unique identifier that is provided or when not available gets UUID.

Ara server runs in the network and is accessible via REST API. Authentication to Ara is performed via token if Ara supports it. If not propose authentication method.

Use bests practices and general architecture from Ara http://ara.recordsansible.org

To init ara:

```
# Install ansible (or ansible-core) with ara (excluding API server dependencies)
python3 -m pip install --user ansible ara

# Configure Ansible to enable ara
export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"

# Set up the ara callback to know where the API server is located
export ARA_API_CLIENT="http"
export ARA_API_SERVER="http://127.0.0.1:8000"
```
Source:https://ara.recordsansible.org

To apply labels:

```
ansible-playbook -i hosts playbook.yaml \
    -e ara_playbook_name="deploy prod" \
    -e ara_playbook_labels=deploy,prod
```
Source: https://ara.readthedocs.io/en/latest/ansible-plugins-and-use-cases.html#playbook-names-and-labels


### GHC-14. Long running task

Prepare new collection: ansible with support for long running tasks. Use already available task with async, storing job identifier for further use. Job identifier is stored in a map next to host, playbook name, and play identifier (look at GHC-13) flushed to persistent storage. Potential option is to use Ara server as persistence for this, if it's possible to easily get value from Ara REST API for a given search pattern. Persistence is configurable - may be ara, local file system, object storage.

Goal is to be able to exit the playbook. Start the play after some time, and see task in progress or completed.

Test case must cover:

1. controller playbook wait for result
2. controller playbook exit after invoke of the task
3. controller playbook return with host and job_id to check result. finish cleanly when task is done
4. managed host crashed and lost the process. controller handles it.
