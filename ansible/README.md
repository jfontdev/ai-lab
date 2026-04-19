# AI Lab Ansible Playbook

Ansible playbook for provisioning the AI Lab stack on Ubuntu Server 24.04.

## Requirements

- Ubuntu Server 24.04 (fresh install)
- SSH access to the target host
- sudo privileges on the target host

## Quick Start

```bash
# 1) Install Ansible and required collections
pip install ansible
ansible-galaxy collection install -r requirements.yml

# 2) Update inventory with your host/IP and user
nano inventory.ini

# 3) Run playbook
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

## Execution Modes

### Remote mode (run from another machine over SSH)

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

### Local mode (run directly on target host)

```bash
cd ai-stack/ansible
ANSIBLE_CONFIG=ansible.local.cfg ansible-playbook playbook.yml -K
```

Notes:
- Local mode does not use SSH transport.
- Local mode skips backend git checkout (`backend_manage_repo=false`) and uses the already cloned repo.
- `-K` is required to provide sudo password for privileged tasks.

## File Structure

```text
ansible/
  playbook.yml
  inventory.ini
  ansible.cfg
  requirements.yml
  files/
    pull_models.sh
  roles/
    base/
    docker/
    ollama/
    backend/
    ssh/
```

## What Gets Installed

### Base
- Core packages (curl, unzip, git, python3, pip)
- Node.js 22.x LTS (NodeSource repo)
- Docker CE repo setup

### Docker
- Docker engine and compose plugin
- Qdrant container on port 6333
- OpenWebUI container on port 8080
- Persistent OpenWebUI data at `{{ app_dir }}/openwebui_data`

### Ollama
- Ollama install from official script
- `ollama` systemd service
- `ollama-warmup` service (preloads `gemma4:e4b`)

### Backend
- Backend code is deployed by git clone/update from public repo (`main` by default)
- Node.js backend service (`ai-backend`)
- Health and logs scripts in the app user home:
  - `~/health.sh`
  - `~/logs.sh`
  - `~/pull_models.sh`

### User Agnostic Defaults
- `app_user` defaults to `ansible_user`
- `app_home` defaults to `ansible_user_dir` (or `/home/<user>`)
- `app_dir` defaults to `{{ app_home }}/ai-stack`
- `backend_manage_repo` defaults to `true` (set to `false` in local profile)

### SSH
- Writes an SSH alias config in `~/.ssh/config`

## Model Pulling

Models are not pulled automatically by default.

```bash
# On target host
nano ~/pull_models.sh
bash ~/pull_models.sh

# Or manual pulls
ollama pull gemma4:e2b
ollama pull gemma4:e4b
ollama pull gemma4:26b
```

## Useful Role Tags

```bash
ansible-playbook -i inventory.ini playbook.yml --tags base
ansible-playbook -i inventory.ini playbook.yml --tags ollama
ansible-playbook -i inventory.ini playbook.yml --tags docker
ansible-playbook -i inventory.ini playbook.yml --tags backend
ansible-playbook -i inventory.ini playbook.yml --tags ssh
```

## Variable Overrides

```bash
ansible-playbook -i inventory.ini playbook.yml \
  -e "openwebui_secret_key=replace-me" \
  -e "ollama_model=gemma4:e4b" \
  -e "app_repo_version=main" \
  -e "backend_manage_repo=true" \
  -e "ollama_pull_models=false" \
  --ask-become-pass
```

## Service Endpoints

- Ollama: `http://localhost:11434`
- OpenWebUI: `http://localhost:8080`
- Qdrant: `http://localhost:6333`
- Backend API: `http://localhost:3000`

## Security Notes

- Set `openwebui_secret_key` before use in shared networks
- Review SSH defaults in `roles/ssh/defaults/main.yml`

## Verification

After applying the playbook, follow `VERIFY.md` for a complete post-run checklist.

## Versioning

Project change history is tracked in `CHANGELOG.md`.
