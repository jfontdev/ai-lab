# AI Lab Setup - GEEKOM HX370
## Version 0.2.0

This document describes the current state of a local AI development environment running on a GEEKOM mini PC with AMD Ryzen AI 9 HX 370.

It has evolved from a basic setup into a stable multi-model AI inference and development platform.

---

# 🧠 System Overview

This AI lab is designed as a local-first AI backend system for:

- LLM inference (multi-model)
- RAG experimentation (Qdrant-based)
- Backend development (Node.js / TypeScript)
- AI workflow orchestration
- Offline AI experimentation

---

# 💻 Hardware

- GEEKOM Mini PC
- CPU: AMD Ryzen AI 9 HX 370
- RAM: 32GB (upgrade planned to 64–128GB)
- Storage: 1TB NVMe SSD

---

# 🐧 Operating System

## Base OS
- Ubuntu Server 24.04 LTS
- XFCE desktop installed (optional GUI layer)

## Storage
- LVM full-disk setup
- Root volume expanded to ~936GB usable space

---

# 🧠 AI Model Strategy

The system uses a tiered model architecture:

## 🟡 Primary Model (Workhorse)
- gemma4:e4b
- Default model for OpenWebUI + backend
- Used for:
  - coding assistance
  - system design
  - RAG synthesis
  - general chat

## 🟢 Fast Model
- gemma4:e2b
- Used for:
  - quick responses
  - lightweight reasoning
  - routing tasks (future use)

## 🔴 Heavy Model
- gemma4:26b-moe
- Used for:
  - deep reasoning tasks
  - complex architecture design
  - advanced RAG synthesis
- Manually triggered due to high memory usage (~19GB VRAM)

---

# 🧠 Model Runtime Behavior (Ollama)

- Models are loaded on-demand (lazy loading)
- Recently used models remain cached in memory
- No manual preloading required
- E4B is warmed at system startup via systemd service

---

# ⚙️ Boot Optimization

## E4B Warmup Service

Ensures fast first response after reboot:

- systemd service triggers Ollama request
- preloads gemma4:e4b into memory

Behavior:
- reduces cold start latency
- ensures OpenWebUI responsiveness

---

# 🧱 Installed Services

## 🧠 Ollama
- Local LLM runtime
- API: http://localhost:11434

## 🌐 OpenWebUI
- Docker-based LLM UI
- Connected to Ollama backend
- Persistent restart enabled

## 🧬 Qdrant
- Vector database for future RAG system
- Docker deployment
- API: http://localhost:6333

## ⚙️ Node.js Backend
- Custom AI API layer
- Systemd-managed service
- Will evolve into AI gateway + RAG orchestrator

---

# 🐳 Docker Services

- OpenWebUI
- Qdrant
- Restart policy: unless-stopped

---

# 🧪 System Health Tools

## Health Check Script

~/ai-stack/health.sh

Checks:
- Ollama status
- Node backend
- Docker services
- Qdrant availability

---

## Log Inspection Tool

~/ai-stack/logs.sh

Provides:
- backend logs
- Ollama runtime logs

---

# ⚙️ Systemd Services

## ai-backend
- Node.js backend service
- Auto-restart enabled
- Depends on:
  - network.target
  - ollama.service
  - docker.service

## ollama-warmup
- Ensures E4B is loaded on boot
- Prevents cold start delays

---

# 🚀 Model Access Pattern

## OpenWebUI
- Default model: gemma4:e4b

## Direct API
- Ollama REST API used for backend integration

---

# 🔧 Windows Dev Access

## SSH Setup

### SSH Agent
- Enabled for passphrase caching
- Key added via ssh-add

---

## SSH Config Alias 

Host ai-lab
    HostName 192.168.1.33
    User jordi
    IdentityFile C:\Users\jordi\Documents\ai

Usage:
ssh ai-lab

---

# 🧠 Architecture Overview

User → OpenWebUI / Node API
           ↓
        Ollama
   ┌───────┼────────┐
   ▼       ▼        ▼
 E2B     E4B     26B MoE
   │       │        │
   └───────┴────────┘
           ↓
        Qdrant (RAG)

---

# 🧪 Performance Notes

- E4B: stable workhorse (~balanced performance)
- E2B: ultra-fast responses
- 26B MoE: ~19GB memory usage, ~10 tokens/sec
- GPU/memory usage is expected behavior during inference teardown

---

# 🔐 Stability Improvements (0.2.0)

- systemd restart policies enabled
- service dependency ordering fixed
- Ollama warmup added
- Docker services auto-restart
- SSH access simplified via agent + alias

---

# 📌 Current System State

✔ Multi-model inference working  
✔ OpenWebUI connected  
✔ Qdrant running  
✔ Node backend stable  
✔ SSH access streamlined  
✔ Boot warmup implemented  
✔ System health tooling added  

---

# 🚀 Next Evolution (0.3.0 roadmap)

- RAG pipeline (Qdrant + embeddings)
- TypeScript backend rewrite
- Streaming chat endpoint
- Smart model router
- Observability dashboard

---

# 🧠 Summary

Stable multi-model local AI development environment with controlled boot lifecycle and tiered inference strategy.
