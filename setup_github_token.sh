#!/bin/bash
# Secure GitHub Token Setup Script
# This script helps you configure your GitHub token for git operations

set -e

GITHUB_TOKEN="${1:-YOUR_GITHUB_TOKEN}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Error: GitHub token not provided"
    echo "Usage: ./setup_github_token.sh [token]"
    exit 1
fi

echo "🔐 Setting up GitHub authentication..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
fi

# Set up git credential helper (stores credentials securely)
echo "💾 Configuring git credential helper..."
git config --global credential.helper store

# Set up remote URL with token (if remote exists, update it)
if git remote get-url origin &>/dev/null; then
    REMOTE_URL=$(git remote get-url origin)
    # Extract repo path (remove https://github.com/ or git@github.com:)
    REPO_PATH=$(echo "$REMOTE_URL" | sed 's|https://github.com/||' | sed 's|git@github.com:||' | sed 's|\.git$||')
    
    if [ -n "$REPO_PATH" ]; then
        echo "🔗 Updating remote URL with token authentication..."
        git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${REPO_PATH}.git"
        echo "✅ Remote URL updated"
    fi
else
    echo "ℹ️  No remote configured yet. When you add a remote, use:"
    echo "   git remote add origin https://${GITHUB_TOKEN}@github.com/YOUR_USERNAME/YOUR_REPO.git"
fi

# Set up GitHub CLI authentication (if gh is installed)
if command -v gh &> /dev/null; then
    echo "🔧 Setting up GitHub CLI authentication..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    echo "✅ GitHub CLI authenticated"
fi

# Store token in environment variable (for current session)
export GITHUB_TOKEN="$GITHUB_TOKEN"
echo "export GITHUB_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.bashrc

echo ""
echo "✅ GitHub token setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. If you haven't created a GitHub repo yet:"
echo "      - Go to https://github.com/new"
echo "      - Create repository (e.g., '55-flutter-apps')"
echo "   2. Add remote (if not already done):"
echo "      git remote add origin https://${GITHUB_TOKEN}@github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "   3. Push your code:"
echo "      git add ."
echo "      git commit -m 'Initial commit'"
echo "      git branch -M main"
echo "      git push -u origin main"
echo ""
echo "⚠️  Security Note:"
echo "   - Token is stored in ~/.git-credentials (secure location)"
echo "   - Token is added to ~/.bashrc for environment access"
echo "   - Never commit token files to git (already in .gitignore)"
echo ""

