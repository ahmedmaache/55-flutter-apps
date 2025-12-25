#!/bin/bash
# Setup Git LFS for Large Files (AAB files)
# This uses GitHub's Git LFS storage instead of local storage

set -e

WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
cd "$WORKSPACE"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "══════════════════════════════════════════════════════════════"
echo "   📦 Setup Git LFS for GitHub Storage"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check if git-lfs is installed
if ! command -v git-lfs &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git LFS not installed${NC}"
    echo -e "${BLUE}💡 Install with:${NC}"
    echo "   sudo apt-get install git-lfs  # Linux"
    echo "   brew install git-lfs          # macOS"
    exit 1
fi

echo -e "${GREEN}✅ Git LFS is installed${NC}"
echo ""

# Initialize Git LFS
echo -e "${BLUE}🔧 Initializing Git LFS...${NC}"
git lfs install
echo -e "${GREEN}✅ Git LFS initialized${NC}"
echo ""

# Track AAB files
echo -e "${BLUE}📋 Configuring Git LFS to track AAB files...${NC}"
git lfs track "*.aab"
git lfs track "store_assets/**/*.aab"

# Add .gitattributes if not already tracked
if [ ! -f .gitattributes ] || ! grep -q "*.aab" .gitattributes 2>/dev/null; then
    echo "*.aab filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "store_assets/**/*.aab filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo -e "${GREEN}✅ .gitattributes updated${NC}"
fi
echo ""

# Show what will be tracked
echo -e "${BLUE}📊 Files tracked by Git LFS:${NC}"
git lfs ls-files 2>/dev/null || echo "  (No files tracked yet)"
echo ""

echo -e "${GREEN}✅ Git LFS setup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "  1. Add AAB files: git add store_assets/**/*.aab"
echo "  2. Commit: git commit -m 'Add AAB files via Git LFS'"
echo "  3. Push: git push origin main"
echo ""
echo -e "${BLUE}💡 Benefits:${NC}"
echo "  ✅ AAB files stored on GitHub (not local disk)"
echo "  ✅ 1GB free Git LFS storage (GitHub free tier)"
echo "  ✅ Files downloaded only when needed"
echo "  ✅ Saves local disk space"
echo ""

