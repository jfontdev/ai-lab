# Changelog

All notable changes to the AI Lab Ansible project are documented in this file.

The format follows Keep a Changelog style and uses Semantic Versioning.

## [0.2.1] - 2026-04-18

### Fixed
- OpenWebUI container task compatibility by replacing unsupported `extra_hosts` with supported `etc_hosts` in `community.docker.docker_container`.

### Changed
- Refactored `README.md` to provide clearer, command-first guidance for remote and local execution modes.

## [0.2.0] - 2026-04-18

### Added
- Local execution profile with `ansible.local.cfg` and `inventory.local.yml`.
- Playbook preflight check for working sudo/become access.
- `backend_manage_repo` toggle to skip git checkout when repo is already cloned.

### Changed
- User defaults made more robust with `ansible_user | default(ansible_user_id)` fallback.
- Backend git repository tasks now run conditionally based on `backend_manage_repo`.
- Documentation expanded with remote/local execution instructions and validation steps.

## [0.1.0] - 2026-04-18

### Added
- Initial role-based Ansible setup for base, Ollama, Docker, backend, and SSH.
- User-agnostic defaults (`app_user`, `app_home`, `app_dir`) and dynamic SSH alias defaults.
- Backend deploy from public git repo (`https://github.com/jfontdev/ai-lab.git`) tracking `main`.
- Verification checklist in `VERIFY.md` and helper model script workflow.
