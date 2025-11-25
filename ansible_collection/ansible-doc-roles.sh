#!/bin/bash
# Helper script to view role documentation with ansible-doc

# Set collection path
export ANSIBLE_COLLECTIONS_PATH="$(cd "$(dirname "$0")/collections" && pwd)"

echo "Collection path: $ANSIBLE_COLLECTIONS_PATH"
echo ""

if [ $# -eq 0 ]; then
    echo "Usage: $0 <role_name>"
    echo ""
    echo "Available roles:"
    echo "  async_job_save  - Save async job metadata by name"
    echo "  async_job_load  - Load async job metadata by name"
    echo ""
    echo "Examples:"
    echo "  $0 async_job_save"
    echo "  $0 async_job_load"
    echo ""
    echo "Or use directly:"
    echo "  export ANSIBLE_COLLECTIONS_PATH=\$(pwd)/collections"
    echo "  ansible-doc -t role rstyczynski.ansible.async_job_save"
    exit 1
fi

ROLE_NAME="$1"
ansible-doc -t role "rstyczynski.ansible.${ROLE_NAME}"
