#!/bin/bash
# GitHub Token Setup for Codespaces
# This script configures your GitHub token in Codespaces environment

set -e

GITHUB_TOKEN="${1:-YOUR_GITHUB_TOKEN}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Error: GitHub token not provided"
    echo "Usage: ./setup_codespaces_token.sh [token]"
    exit 1
fi

echo "🔐 Setting up GitHub token for Codespaces..."

# Export token for current session
export GITHUB_TOKEN="$GITHUB_TOKEN"

# Add to bashrc for persistence
if ! grep -q "GITHUB_TOKEN" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# GitHub Token (configured for Codespaces)" >> ~/.bashrc
    echo "export GITHUB_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.bashrc
fi

# Configure git credential helper
git config --global credential.helper store

# Store token in git credentials
echo "https://${GITHUB_TOKEN}@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials

# Configure GitHub CLI if available
if command -v gh &> /dev/null; then
    echo "🔧 Configuring GitHub CLI..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null && echo "✅ GitHub CLI authenticated" || echo "⚠️  GitHub CLI authentication skipped"
fi

# Store token in file (for post-create script)
echo "$GITHUB_TOKEN" > ~/.github_token
chmod 600 ~/.github_token

echo ""
echo "✅ GitHub token configured successfully!"
echo ""
echo "📋 Configuration details:"
echo "   - Token stored in ~/.git-credentials"
echo "   - Token added to ~/.bashrc (environment variable)"
echo "   - Token stored in ~/.github_token (for scripts)"
echo "   - Git credential helper configured"
echo ""
echo "🔍 Test your setup:"
echo "   git config --global --get credential.helper"
echo "   gh auth status"
echo ""

