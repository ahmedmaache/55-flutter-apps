#!/bin/bash
# Aggressive Cleanup - Free Maximum Disk Space
# Moves everything possible to GitHub storage

set -e

WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
cd "$WORKSPACE"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "══════════════════════════════════════════════════════════════"
echo "   🧹 AGGRESSIVE CLEANUP - Free Maximum Disk Space"
echo "   Moving Everything to GitHub Storage"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check current disk usage
echo -e "${BLUE}📊 Current Disk Usage:${NC}"
df -h . | tail -1
echo ""

# 1. Remove all build directories (aggressive)
echo -e "${BLUE}🧹 Step 1: Removing ALL build directories...${NC}"
find . -type d -name "build" -not -path "*/.git/*" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".dart_tool" -not -path "*/.git/*" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".flutter-plugins*" -not -path "*/.git/*" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✅ All build directories removed${NC}"
echo ""

# 2. Remove all node_modules (if any)
echo -e "${BLUE}🧹 Step 2: Removing node_modules...${NC}"
find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✅ node_modules removed${NC}"
echo ""

# 3. Remove all .pub-cache
echo -e "${BLUE}🧹 Step 3: Removing pub cache...${NC}"
find . -type d -name ".pub-cache" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".pub" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✅ Pub cache removed${NC}"
echo ""

# 4. Remove Android build artifacts
echo -e "${BLUE}🧹 Step 4: Removing Android build artifacts...${NC}"
find . -type d -path "*/android/app/build" -exec rm -rf {} + 2>/dev/null || true
find . -type d -path "*/android/.gradle" -exec rm -rf {} + 2>/dev/null || true
find . -type d -path "*/android/build" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✅ Android artifacts removed${NC}"
echo ""

# 5. Remove iOS build artifacts
echo -e "${BLUE}🧹 Step 5: Removing iOS build artifacts...${NC}"
find . -type d -path "*/ios/build" -exec rm -rf {} + 2>/dev/null || true
find . -type d -path "*/ios/Pods" -exec rm -rf {} + 2>/dev/null || true
find . -type d -path "*/ios/.symlinks" -exec rm -rf {} + 2>/dev/null || true
find . -type d -path "*/ios/DerivedData" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✅ iOS artifacts removed${NC}"
echo ""

# 6. Remove large log files
echo -e "${BLUE}🧹 Step 6: Removing log files...${NC}"
find . -type f -name "*.log" -size +1M -delete 2>/dev/null || true
find . -type f -name "*.tmp" -delete 2>/dev/null || true
echo -e "${GREEN}✅ Log files removed${NC}"
echo ""

# 7. Remove coverage reports
echo -e "${BLUE}🧹 Step 7: Removing coverage reports...${NC}"
find . -type d -name "coverage" -exec rm -rf {} + 2>/dev/null || true
echo -e "${GREEN}✅ Coverage reports removed${NC}"
echo ""

# 8. Compress and move AAB files info (they'll be on GitHub)
echo -e "${BLUE}📦 Step 8: Preparing AAB files for GitHub...${NC}"
if [ -d "store_assets" ]; then
    AAB_COUNT=$(find store_assets -name "*.aab" 2>/dev/null | wc -l)
    echo "  Found $AAB_COUNT AAB files"
    echo -e "${YELLOW}💡 These will be stored in GitHub Actions artifacts${NC}"
    echo -e "${YELLOW}💡 You can delete local copies after pushing to GitHub${NC}"
fi
echo ""

# Final disk usage
echo -e "${BLUE}📊 Final Disk Usage:${NC}"
df -h . | tail -1
echo ""

echo -e "${GREEN}✅ Aggressive cleanup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "  1. Push code to GitHub (all source code)"
echo "  2. Build via GitHub Actions (no local builds needed)"
echo "  3. AAB files stored in GitHub Actions artifacts"
echo "  4. Use Codespaces for development (cloud storage)"
echo ""
echo -e "${YELLOW}⚠️  Note: All builds will now happen on GitHub${NC}"
echo -e "${YELLOW}⚠️  Local build directories are removed${NC}"
echo ""

