# AI Lab Post-Apply Verification

Use this after running the playbook on the target host.

## 1) Playbook syntax and inventory (control machine)

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml --syntax-check
ansible-inventory -i inventory.ini --graph
```

## 2) Core services status (target host)

```bash
systemctl is-enabled docker ollama ollama-warmup ai-backend
systemctl is-active docker ollama ai-backend
systemctl status ollama --no-pager
systemctl status ai-backend --no-pager
```

Expected:
- `is-enabled` returns `enabled`.
- `is-active` returns `active`.

## 3) Containers (target host)

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

Expected running containers:
- `open-webui`
- `qdrant`

## 4) Endpoint checks (target host)

```bash
curl -fsS http://localhost:11434/api/tags
curl -fsS http://localhost:3000/health
curl -fsS http://localhost:6333/collections
curl -I http://localhost:8080
```

Expected:
- Ollama tags endpoint responds with JSON.
- Backend health responds with `{"status":"ok"}`.
- Qdrant collections endpoint responds with JSON.
- OpenWebUI returns HTTP 200/302.

## 5) Repository checkout checks (target host)

```bash
git -C ~/ai-stack remote -v
git -C ~/ai-stack rev-parse --abbrev-ref HEAD
git -C ~/ai-stack log -1 --oneline
```

Expected:
- Remote URL points to `https://github.com/jfontdev/ai-lab.git`.
- Active branch is `main` (unless you overrode `app_repo_version`).
- Latest commit is visible.

## 6) Installed helper scripts (target host)

```bash
ls -l ~/health.sh ~/logs.sh ~/pull_models.sh
bash ~/health.sh
```

Expected:
- Scripts exist and are executable.
- Health script reports active services.

## 7) Backend model wiring (target host)

```bash
grep '^Environment=OLLAMA_MODEL=' /etc/systemd/system/ai-backend.service
systemctl show ai-backend -p Environment
```

Expected:
- `OLLAMA_MODEL=gemma4:e4b` (or your overridden value).

## 8) Optional model pulls (target host)

```bash
nano ~/pull_models.sh
bash ~/pull_models.sh

# Or manual
ollama pull gemma4:e2b
ollama pull gemma4:e4b
ollama pull gemma4:26b
```

Verify models:

```bash
ollama list
```

## 9) Chat streaming smoke test (target host)

```bash
curl -N -X POST http://localhost:3000/chat \
  -H "Content-Type: application/json" \
  -d '{"prompt":"Say hello in one short sentence."}'
```

Expected:
- Server-sent stream output appears.
- Ends with `[DONE]`.

## 10) If something fails

```bash
journalctl -u ollama -n 100 --no-pager
journalctl -u ai-backend -n 100 --no-pager
docker logs --tail 100 open-webui
docker logs --tail 100 qdrant
```
