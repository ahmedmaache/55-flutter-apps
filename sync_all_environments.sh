#!/bin/bash
# Sync workspace across all environments: Local, Remote PC, and GitHub

set -e

WORKSPACE_DIR="/home/maache/55 flutterapps"
REMOTE_HOST="maache@192.168.1.24"
REMOTE_PASS="1234"
REMOTE_WORKSPACE="~/55_flutterapps"

echo "══════════════════════════════════════════════════════════════"
echo "   🔄 Syncing Workspace Across All Environments"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check if git repo exists
if [ ! -d "$WORKSPACE_DIR/.git" ]; then
    echo "⚠️  Git repository not initialized"
    echo "   Run: cd '$WORKSPACE_DIR' && git init && git add . && git commit -m 'Initial commit'"
    exit 1
fi

# Function to sync to remote PC
sync_to_remote() {
    echo "📤 Syncing to Remote PC ($REMOTE_HOST)..."
    rsync -avz --progress --exclude='.git' --exclude='build/' \
        -e "sshpass -p '$REMOTE_PASS' ssh -o StrictHostKeyChecking=no" \
        "$WORKSPACE_DIR/" "$REMOTE_HOST:$REMOTE_WORKSPACE/" 2>&1 | tail -5
    echo "✅ Remote PC sync complete"
    echo ""
}

# Function to sync from remote PC
sync_from_remote() {
    echo "📥 Syncing from Remote PC ($REMOTE_HOST)..."
    rsync -avz --progress --exclude='.git' --exclude='build/' \
        -e "sshpass -p '$REMOTE_PASS' ssh -o StrictHostKeyChecking=no" \
        "$REMOTE_HOST:$REMOTE_WORKSPACE/" "$WORKSPACE_DIR/" 2>&1 | tail -5
    echo "✅ Local sync from remote complete"
    echo ""
}

# Function to sync to GitHub
sync_to_github() {
    echo "📤 Syncing to GitHub..."
    cd "$WORKSPACE_DIR"
    
    # Check if remote exists
    if ! git remote get-url origin &>/dev/null; then
        echo "⚠️  GitHub remote not configured"
        echo "   Run: git remote add origin https://github.com/YOUR_USERNAME/REPO.git"
        return 1
    fi
    
    git add .
    if git diff --staged --quiet; then
        echo "ℹ️  No changes to commit"
    else
        git commit -m "Sync: $(date '+%Y-%m-%d %H:%M:%S')" || true
    fi
    
    git push origin main 2>&1 | tail -5
    echo "✅ GitHub sync complete"
    echo ""
}

# Function to sync from GitHub
sync_from_github() {
    echo "📥 Syncing from GitHub..."
    cd "$WORKSPACE_DIR"
    
    if ! git remote get-url origin &>/dev/null; then
        echo "⚠️  GitHub remote not configured"
        return 1
    fi
    
    git pull origin main 2>&1 | tail -5
    echo "✅ Local sync from GitHub complete"
    echo ""
}

# Main menu
case "${1:-menu}" in
    "to-remote")
        sync_to_remote
        ;;
    "from-remote")
        sync_from_remote
        ;;
    "to-github")
        sync_to_github
        ;;
    "from-github")
        sync_from_github
        ;;
    "all-to-remote")
        sync_to_github
        sync_to_remote
        ;;
    "all-from-remote")
        sync_from_remote
        sync_to_github
        ;;
    "menu"|*)
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  to-remote       - Sync local → remote PC"
        echo "  from-remote    - Sync remote PC → local"
        echo "  to-github      - Sync local → GitHub"
        echo "  from-github    - Sync GitHub → local"
        echo "  all-to-remote  - Sync local → GitHub → remote PC"
        echo "  all-from-remote - Sync remote PC → local → GitHub"
        echo ""
        echo "Example:"
        echo "  $0 to-remote    # Push local changes to remote PC"
        echo "  $0 to-github    # Push local changes to GitHub"
        echo "  $0 all-to-remote # Sync everything to both"
        ;;
esac

echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Sync Complete!"
echo "══════════════════════════════════════════════════════════════"

