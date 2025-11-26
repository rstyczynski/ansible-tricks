# Ansible temporary directory

To eliminate possibility to overwrite tmp file by different processes, each playbook execution generates new random tmp file.

```yaml
- name: Create random tmp directory
  tempfile:
    state: directory
    suffix: ansible
  register: temp_dir

- name: Use the temp directory
  command: some_command
  environment:
    TMPDIR: "{{ temp_dir.path }}"

- name: Cleanup temp directory
  file:
    path: "{{ temp_dir.path }}"
    state: absent
  when: temp_dir.path is defined
```

```yml
- hosts: all
  module_defaults:
    group/all:
      environment:
        TMPDIR: "{{ temp_dir.path }}"
```