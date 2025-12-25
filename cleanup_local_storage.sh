#!/bin/bash
# Cleanup Local Storage and Use GitHub Storage Instead
# This script frees up local disk space by moving files to GitHub

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
echo "   🧹 Cleanup Local Storage - Use GitHub Storage"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Function to get directory size
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1 || echo "0"
}

# Check current disk usage
echo -e "${BLUE}📊 Current Disk Usage:${NC}"
df -h . | tail -1
echo ""

# Calculate space that can be freed
TOTAL_FREED=0

# 1. Clean Flutter build directories
echo -e "${BLUE}🧹 Step 1: Cleaning Flutter build directories...${NC}"
BUILD_DIRS=$(find . -type d -name "build" -not -path "*/.git/*" 2>/dev/null | head -20)
if [ -n "$BUILD_DIRS" ]; then
    for dir in $BUILD_DIRS; do
        SIZE=$(get_size "$dir")
        echo "  Removing: $dir ($SIZE)"
        rm -rf "$dir"
        TOTAL_FREED=$((TOTAL_FREED + 1))
    done
    echo -e "${GREEN}✅ Build directories cleaned${NC}"
else
    echo -e "${YELLOW}⚠️  No build directories found${NC}"
fi
echo ""

# 2. Clean Flutter cache
echo -e "${BLUE}🧹 Step 2: Cleaning Flutter cache...${NC}"
if [ -d ".dart_tool" ]; then
    SIZE=$(get_size ".dart_tool")
    echo "  Removing .dart_tool ($SIZE)"
    rm -rf .dart_tool
    echo -e "${GREEN}✅ Dart tool cache cleaned${NC}"
fi

if [ -f ".flutter-plugins" ] || [ -f ".flutter-plugins-dependencies" ]; then
    echo "  Removing Flutter plugin files"
    rm -f .flutter-plugins .flutter-plugins-dependencies
    echo -e "${GREEN}✅ Flutter plugin files cleaned${NC}"
fi
echo ""

# 3. Clean pub cache (if in workspace)
echo -e "${BLUE}🧹 Step 3: Cleaning pub cache...${NC}"
if [ -d ".pub-cache" ]; then
    SIZE=$(get_size ".pub-cache")
    echo "  Removing .pub-cache ($SIZE)"
    rm -rf .pub-cache
    echo -e "${GREEN}✅ Pub cache cleaned${NC}"
fi
echo ""

# 4. Move AAB files to GitHub (upload as artifacts)
echo -e "${BLUE}📦 Step 4: Preparing AAB files for GitHub storage...${NC}"
if [ -d "store_assets" ]; then
    AAB_COUNT=$(find store_assets -name "*.aab" 2>/dev/null | wc -l)
    if [ "$AAB_COUNT" -gt 0 ]; then
        echo "  Found $AAB_COUNT AAB files in store_assets/"
        echo -e "${YELLOW}💡 These will be stored in GitHub Actions artifacts${NC}"
        echo -e "${YELLOW}💡 Run: ./upload_to_github_storage.sh to upload them${NC}"
    else
        echo -e "${YELLOW}⚠️  No AAB files found${NC}"
    fi
fi
echo ""

# 5. Clean Android build artifacts
echo -e "${BLUE}🧹 Step 5: Cleaning Android build artifacts...${NC}"
ANDROID_BUILDS=$(find . -type d -path "*/android/app/build" -not -path "*/.git/*" 2>/dev/null | head -20)
if [ -n "$ANDROID_BUILDS" ]; then
    for dir in $ANDROID_BUILDS; do
        SIZE=$(get_size "$dir")
        echo "  Removing: $dir ($SIZE)"
        rm -rf "$dir"
    done
    echo -e "${GREEN}✅ Android build artifacts cleaned${NC}"
else
    echo -e "${YELLOW}⚠️  No Android build directories found${NC}"
fi
echo ""

# 6. Clean iOS build artifacts
echo -e "${BLUE}🧹 Step 6: Cleaning iOS build artifacts...${NC}"
IOS_BUILDS=$(find . -type d -path "*/ios/build" -not -path "*/.git/*" 2>/dev/null | head -20)
if [ -n "$IOS_BUILDS" ]; then
    for dir in $IOS_BUILDS; do
        SIZE=$(get_size "$dir")
        echo "  Removing: $dir ($SIZE)"
        rm -rf "$dir"
    done
    echo -e "${GREEN}✅ iOS build artifacts cleaned${NC}"
else
    echo -e "${YELLOW}⚠️  No iOS build directories found${NC}"
fi
echo ""

# 7. Clean temporary files
echo -e "${BLUE}🧹 Step 7: Cleaning temporary files...${NC}"
TEMP_FILES=$(find . -type f \( -name "*.log" -o -name "*.tmp" -o -name ".DS_Store" \) -not -path "*/.git/*" 2>/dev/null | head -50)
if [ -n "$TEMP_FILES" ]; then
    echo "$TEMP_FILES" | while read -r file; do
        rm -f "$file"
    done
    echo -e "${GREEN}✅ Temporary files cleaned${NC}"
else
    echo -e "${YELLOW}⚠️  No temporary files found${NC}"
fi
echo ""

# Final disk usage
echo -e "${BLUE}📊 Final Disk Usage:${NC}"
df -h . | tail -1
echo ""

echo -e "${GREEN}✅ Cleanup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "  1. Push code to GitHub: git add . && git commit -m 'Cleanup local storage' && git push"
echo "  2. Use GitHub Actions for builds (no local storage needed)"
echo "  3. Download AAB files from GitHub Actions artifacts when needed"
echo "  4. Use Codespaces for development (cloud storage)"
echo ""

