# Ara Callback Quickstart

Follow Ara's basic instructions to emit task-level events from this collection's playbooks.

## Install Ara client

```bash
python3 -m pip install --user ansible ara
```

## Export callback environment

```bash
export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"
export ARA_API_CLIENT=http
export ARA_API_SERVER=http://127.0.0.1:8000   # change to your Ara server
# optional:
# export ARA_API_TOKEN=your_token
# export ARA_PLAYBOOK_NAME="collection-flow"
# export ARA_PLAYBOOK_LABELS="github,ci"
```

## Run the playbook with Ara enabled

```bash
cd github_collection
ansible-playbook -i localhost, flow.yml
```

After the run, inspect results via Ara UI/API, e.g.:

```bash
ara playbook list
```

Notes:
- UUID is generated automatically by Ara if not provided.
- Keep the Ara server reachable from the controller; token is optional if the server allows anonymous access.
