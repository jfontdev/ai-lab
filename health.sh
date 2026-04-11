#!/bin/bash

echo "🧠 AI LAB HEALTH CHECK"
echo "----------------------"

echo ""
echo "📦 Docker:"
systemctl is-active docker

echo ""
echo "🧠 Ollama:"
systemctl is-active ollama
curl -s http://localhost:11434/api/tags | head -c 80 && echo ""

echo ""
echo "⚙️ Node Backend:"
systemctl is-active ai-backend

echo ""
echo "🧬 Qdrant:"
curl -s http://localhost:6333/collections | head -c 80 && echo ""

echo ""
echo "🌐 OpenWebUI:"
docker ps --format "table {{.Names}}\t{{.Status}}"
