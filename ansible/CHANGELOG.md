# Changelog

All notable changes to the AI Lab Ansible project are documented in this file.

The format follows Keep a Changelog style and uses Semantic Versioning.

## [0.1.0] - 2026-04-18

### Added
- Initial role-based Ansible setup for base, Ollama, Docker, backend, and SSH.
- User-agnostic defaults (`app_user`, `app_home`, `app_dir`) and dynamic SSH alias defaults.
- Backend deploy from public git repo (`https://github.com/jfontdev/ai-lab.git`) tracking `main`.
- Verification checklist in `VERIFY.md` and helper model script workflow.
