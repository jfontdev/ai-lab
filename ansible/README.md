# AI Lab Ansible Playbook

Ansible setup for provisioning the AI Lab stack on Ubuntu Server 24.04.

## Requirements

- Ubuntu Server 24.04
- `sudo` access on target host
- Ansible installed on the machine where you run the command

## Install Ansible Dependencies

```bash
cd ansible
pip install ansible
ansible-galaxy collection install -r requirements.yml
```

## Choose One Execution Mode

### Option A: Remote mode (run from another machine)

1) Edit remote inventory:

```bash
cd ansible
nano inventory.ini
```

2) Run playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

### Option B: Local mode (run directly on target host)

Use this when the repo is already cloned on the target host.

```bash
cd ai-stack/ansible
ANSIBLE_CONFIG=ansible.local.cfg ansible-playbook playbook.yml -K
```

Local mode behavior:
- Uses `localhost` with `ansible_connection=local`
- Skips backend git checkout (`backend_manage_repo=false`)
- Uses existing repo checkout (`app_dir={{ playbook_dir | dirname }}`)

## Common Useful Commands

Run syntax checks:

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml --syntax-check
ANSIBLE_CONFIG=ansible.local.cfg ansible-playbook playbook.yml --syntax-check
```

Run only specific roles:

```bash
ansible-playbook -i inventory.ini playbook.yml --tags base
ansible-playbook -i inventory.ini playbook.yml --tags ollama
ansible-playbook -i inventory.ini playbook.yml --tags docker
ansible-playbook -i inventory.ini playbook.yml --tags backend
```

Override variables:

```bash
ansible-playbook -i inventory.ini playbook.yml \
  -e "openwebui_secret_key=replace-me" \
  -e "ollama_model=gemma4:e4b" \
  -e "app_repo_version=main" \
  -e "backend_manage_repo=true" \
  --ask-become-pass
```

## What Gets Installed

- Base packages + Node.js 22 LTS + Docker repo
- Ollama (`ollama` + `ollama-warmup` services)
- Docker containers: `qdrant`, `open-webui`
- Backend systemd service: `ai-backend`
- Helper scripts in user home: `health.sh`, `logs.sh`, `pull_models.sh`

## Endpoints

- Ollama: `http://localhost:11434`
- OpenWebUI: `http://localhost:8080`
- Qdrant: `http://localhost:6333`
- Backend: `http://localhost:3000`

## Post-Run Verification

Use `VERIFY.md` for the full checklist.

## Versioning

See `CHANGELOG.md`.
