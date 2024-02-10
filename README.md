# How to get started?

Edit the variables (`inventory/group_vars/`)
Edit the inventory (`inventory/hosts`)

The variables are documented here:
<https://giftpilz0.github.io/projectdocs/ansible/>

```bash
ansible-playbook play.yml --limit server
ansible-playbook play.yml --limit workstation
```
