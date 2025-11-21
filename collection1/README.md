# Collection Quick Start

## TL;DR - Use Collections Without Building

```bash
# 1. Initialize collection directly in ansible_collections structure
mkdir -p collections/ansible_collections
cd collections/ansible_collections
ansible-galaxy collection init acme.tools
cd ../..

# 2. Initialize role
ansible-galaxy role init calc --init-path collections/ansible_collections/acme/tools/roles

# 3. copy calc tasks to the role
mkdir -p collections/ansible_collections/acme/tools/roles/calc/tasks
cat calc.yml >> collections/ansible_collections/acme/tools/roles/calc/tasks/main.yml

mkdir -p collections/ansible_collections/acme/tools/roles/calc/defaults
cat > collections/ansible_collections/acme/tools/roles/calc/defaults/main.yml <<EOF
---
calc_show_result: true
calc_title: "Math calculation"
EOF

