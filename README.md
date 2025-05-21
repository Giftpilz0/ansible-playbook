# Ansible Playbooks

![Ansible-Lint](https://github.com/giftpilz0/ansible-playbook/actions/workflows/ci.yml/badge.svg)

Variables are documented here:
<https://giftpilz0.nixpi.de/docs/category/ansible-1>

______________________________________________________________________

## How to get started?

Edit the variables (`inventory/group_vars/`)
Edit the inventory (`inventory/hosts`)

```bash
ansible-playbook play.yml --limit workstation
```
