#!/bin/bash
# Check GitHub Actions Build Status
# Uses your GitHub token to check workflow runs

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
echo "   📊 GitHub Actions Build Status"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Function to make GitHub API calls
gh_api() {
    curl -s -H "Authorization: token $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         "$GITHUB_API$1"
}

# Get recent workflow runs
echo -e "${BLUE}📋 Recent workflow runs:${NC}"
echo ""

RUNS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/runs?per_page=5")

# Parse and display runs
echo "$RUNS" | grep -E '"id"|"name"|"status"|"conclusion"|"created_at"|"html_url"' | \
    sed 's/.*"id":\([0-9]*\).*/Run ID: \1/' | \
    sed 's/.*"name":"\([^"]*\)".*/Workflow: \1/' | \
    sed 's/.*"status":"\([^"]*\)".*/Status: \1/' | \
    sed 's/.*"conclusion":"\([^"]*\)".*/Conclusion: \1/' | \
    sed 's/.*"created_at":"\([^"]*\)".*/Created: \1/' | \
    sed 's/.*"html_url":"\([^"]*\)".*/URL: \1/' | \
    head -30

echo ""
echo -e "${BLUE}🔗 View all runs:${NC}"
echo "   https://github.com/$GITHUB_USER/$REPO_NAME/actions"
echo ""

# Get artifacts if any
echo -e "${BLUE}📦 Checking for artifacts...${NC}"
ARTIFACTS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/artifacts?per_page=10")

ARTIFACT_COUNT=$(echo "$ARTIFACTS" | grep -o '"total_count":[0-9]*' | cut -d':' -f2)
if [ -n "$ARTIFACT_COUNT" ] && [ "$ARTIFACT_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✅ Found $ARTIFACT_COUNT artifacts${NC}"
    echo "$ARTIFACTS" | grep -E '"name"|"created_at"|"size_in_bytes"' | head -15
else
    echo -e "${YELLOW}⚠️  No artifacts found${NC}"
fi

echo ""
echo -e "${GREEN}✅ Status check complete!${NC}"

