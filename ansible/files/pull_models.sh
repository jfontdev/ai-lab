#!/bin/bash
# ================================================================================
# Ollama Models Helper Script
# ================================================================================
# This script downloads the AI models for the AI Lab.
# 
# IMPORTANT: Models are NOT pulled automatically during the Ansible run.
# This is intentional because:
#   - Large model downloads can take a long time
#   - Network issues may cause failures
#   - You may want to select which models to download
#
# To run this script:
#   1. Log in to the AI Lab server
#   2. Run: bash ~/pull_models.sh
#      (Ansible copies this file to your home directory)
#
# ================================================================================

set -e

echo "AI Lab Models Setup"
echo "=================="
echo ""

# Function to pull a model with retry
pull_model() {
    local model=$1
    echo "Pulling $model..."
    if ollama pull "$model"; then
        echo "[OK] $model pulled successfully"
    else
        echo "[ERR] Failed to pull $model"
        return 1
    fi
}

# Check if Ollama is running
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "[ERR] Ollama is not running. Start it with:"
    echo "   sudo systemctl start ollama"
    exit 1
fi

echo "Available models will be listed after pull."
echo ""

# Uncomment the models you want to pull:

# Fast model - lightweight reasoning, quick responses
# pull_model "gemma4:e2b"

# Primary workhorse - default model for most tasks
# pull_model "gemma4:e4b"

# Heavy model - deep reasoning, complex architecture
# WARNING: Uses ~19GB VRAM, slower to load
# pull_model "gemma4:26b"

# Example: Pull all three (uncomment to enable)
# echo "Pulling gemma4:e2b..."
# ollama pull gemma4:e2b
# echo "Pulling gemma4:e4b..."
# ollama pull gemma4:e4b
# echo "Pulling gemma4:26b..."
# ollama pull gemma4:26b

echo ""
echo "No models selected for pull."
echo ""
echo "To download models, edit this file and uncomment the pull_model commands."
echo ""
echo "After pulling models, verify with:"
echo "  ollama list"
