#!/bin/bash

echo "📜 AI LAB LOGS"
echo "--------------"

echo "🧠 Backend:"
journalctl -u ai-backend -n 20 --no-pager

echo ""
echo "🧠 Ollama:"
journalctl -u ollama -n 20 --no-pager
