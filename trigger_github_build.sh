#!/bin/bash
# Trigger GitHub Actions Build
# Uses your GitHub token to trigger workflows via API

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
echo "   🚀 Trigger GitHub Actions Build"
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

# Get workflow ID
echo -e "${BLUE}🔍 Finding workflow...${NC}"
WORKFLOWS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows")
WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

if [ -z "$WORKFLOW_ID" ]; then
    echo -e "${YELLOW}⚠️  Workflow not found. Make sure you've pushed the workflow files to GitHub.${NC}"
    echo -e "${BLUE}💡 Push your code first:${NC}"
    echo "   git add .github/workflows/"
    echo "   git commit -m 'Add GitHub Actions workflows'"
    echo "   git push origin main"
    exit 1
fi

echo -e "${GREEN}✅ Found workflow ID: $WORKFLOW_ID${NC}"

# Parse arguments
DEVELOPER="${1:-all}"
APP_NAME="${2:-}"

# Prepare inputs
INPUTS="{\"developer\":\"$DEVELOPER\""
if [ -n "$APP_NAME" ]; then
    INPUTS="$INPUTS,\"app_name\":\"$APP_NAME\""
fi
INPUTS="$INPUTS}"

# Trigger workflow
echo -e "${BLUE}🚀 Triggering workflow...${NC}"
echo -e "${BLUE}   Developer: $DEVELOPER${NC}"
if [ -n "$APP_NAME" ]; then
    echo -e "${BLUE}   App: $APP_NAME${NC}"
fi
echo ""

RESPONSE=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows/$WORKFLOW_ID/dispatches" "POST" "{\"ref\":\"main\",\"inputs\":$INPUTS}")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "204" ]; then
    echo -e "${GREEN}✅ Workflow triggered successfully!${NC}"
    echo ""
    echo -e "${BLUE}📊 View build status:${NC}"
    echo "   https://github.com/$GITHUB_USER/$REPO_NAME/actions"
    echo ""
    echo -e "${BLUE}💡 Monitor the build:${NC}"
    echo "   curl -H \"Authorization: token $GITHUB_TOKEN\" \\"
    echo "        https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/actions/runs | jq '.workflow_runs[0]'"
else
    echo -e "${RED}❌ Failed to trigger workflow${NC}"
    echo "HTTP Code: $HTTP_CODE"
    echo "Response: $RESPONSE"
    exit 1
fi

