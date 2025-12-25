#!/bin/bash
# Upload Files to GitHub Storage (Artifacts)
# This script uploads AAB files and other artifacts to GitHub Actions

set -e

GITHUB_TOKEN="${GITHUB_TOKEN:-YOUR_GITHUB_TOKEN}"
GITHUB_USER="ahmedmaache"
REPO_NAME="55-flutter-apps"
GITHUB_API="https://api.github.com"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "══════════════════════════════════════════════════════════════"
echo "   📦 Upload to GitHub Storage"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Function to make GitHub API calls
gh_api() {
    local endpoint="$1"
    local method="${2:-GET}"
    local data="${3:-}"
    
    if [ -n "$data" ]; then
        curl -s -w "\n%{http_code}" -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$GITHUB_API$endpoint"
    else
        curl -s -w "\n%{http_code}" -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "$GITHUB_API$endpoint"
    fi
}

# Check for AAB files
echo -e "${BLUE}🔍 Checking for AAB files...${NC}"
AAB_FILES=$(find store_assets -name "*.aab" 2>/dev/null)

if [ -z "$AAB_FILES" ]; then
    echo -e "${YELLOW}⚠️  No AAB files found in store_assets/${NC}"
    echo -e "${BLUE}💡 AAB files will be automatically uploaded when you build via GitHub Actions${NC}"
    exit 0
fi

AAB_COUNT=$(echo "$AAB_FILES" | wc -l)
echo -e "${GREEN}✅ Found $AAB_COUNT AAB files${NC}"
echo ""

# Note about GitHub Actions artifacts
echo -e "${BLUE}📋 Note:${NC}"
echo "  GitHub Actions automatically uploads AAB files as artifacts"
echo "  when you build apps using the workflow."
echo ""
echo -e "${BLUE}💡 To upload AAB files:${NC}"
echo "  1. Build apps using GitHub Actions: ./build_signed_release.sh"
echo "  2. AAB files will be automatically uploaded as artifacts"
echo "  3. Download from Actions → Artifacts (30-day retention)"
echo ""
echo -e "${BLUE}💡 Alternative: Use Git LFS for large files${NC}"
echo "  Run: ./setup_git_lfs.sh to set up Git LFS for AAB files"
echo ""

