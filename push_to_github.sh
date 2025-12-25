#!/bin/bash
# Script to push all GitHub workflows and configurations to GitHub

set -e

echo "══════════════════════════════════════════════════════════════"
echo "   🚀 Pushing GitHub Resources Setup to GitHub"
echo "══════════════════════════════════════════════════════════════"
echo ""

WORKSPACE="/home/maache/55 flutterapps"
cd "$WORKSPACE"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
    echo "✅ Git initialized"
fi

# Check if remote exists
if ! git remote get-url origin &>/dev/null; then
    echo ""
    echo "⚠️  No remote repository configured!"
    echo ""
    echo "Please add your GitHub repository:"
    echo "  git remote add origin https://YOUR_GITHUB_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo ""
    echo "Or run: ./setup_github_token.sh"
    echo ""
    exit 1
fi

# Add all new files
echo "📝 Adding files..."
git add .github/
git add .devcontainer/
git add setup_github_token.sh
git add GITHUB_TOKEN_SETUP.md
git add .gitignore

# Show what will be committed
echo ""
echo "📋 Files to be committed:"
git status --short | head -20
echo ""

# Commit
echo "💾 Committing changes..."
git commit -m "🚀 Add comprehensive GitHub Actions workflows for GPC management

- Add 7 GitHub Actions workflows:
  * Build Flutter Apps (parallel builds, auto-releases)
  * Publish to Google Play Console
  * Manage Store Assets
  * Test Flutter Apps
  * Storage Optimization
  * Automated GPC Management
  * Compute Optimization

- Add Codespaces devcontainer configuration
- Add GitHub token setup scripts
- Add comprehensive documentation
- Update .gitignore for security

Uses all GitHub resources: compute, storage, and Actions for complete GPC management."

# Push
echo ""
echo "📤 Pushing to GitHub..."
git branch -M main 2>/dev/null || true
git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "📋 Next steps:"
echo "   1. Go to your repository on GitHub"
echo "   2. Go to Settings → Secrets → Actions"
echo "   3. Add secrets:"
echo "      - GPC_SERVICE_ACCOUNT_JSON"
echo "      - GPC_PACKAGE_NAME"
echo "   4. Go to Actions tab to see your workflows"
echo "   5. Test a workflow: Actions → Build Flutter Apps → Run workflow"
echo ""

