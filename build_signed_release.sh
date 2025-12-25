#!/bin/bash
# Build Signed Release AAB Files Using GitHub Resources
# This script uses GitHub Actions to build signed release AAB files

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
echo "   🚀 Build Signed Release AAB Files"
echo "   Using GitHub Actions Resources"
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

# Check if secrets are set
echo -e "${BLUE}🔍 Checking GitHub Secrets...${NC}"
SECRETS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/secrets" 2>&1)
HTTP_CODE=$(echo "$SECRETS" | tail -1)

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${YELLOW}⚠️  Cannot check secrets (may need to set them up)${NC}"
    echo ""
    echo -e "${BLUE}📋 Required GitHub Secrets:${NC}"
    echo "   1. KEYSTORE_PASSWORD - Your keystore password"
    echo "   2. KEY_PASSWORD - Your key password"
    echo "   3. KEY_ALIAS - Your key alias (usually 'upload')"
    echo "   4. KEYSTORE_BASE64 - Base64 encoded keystore file"
    echo ""
    echo -e "${BLUE}💡 To set secrets:${NC}"
    echo "   GitHub → Settings → Secrets and variables → Actions → New repository secret"
    echo ""
    read -p "Continue without signing? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ]; then
        exit 1
    fi
else
    echo -e "${GREEN}✅ Secrets check passed${NC}"
fi

# Get workflow ID
echo -e "${BLUE}🔍 Finding workflow...${NC}"
WORKFLOWS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows")
WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

if [ -z "$WORKFLOW_ID" ]; then
    echo -e "${RED}❌ Workflow not found${NC}"
    echo -e "${BLUE}💡 Make sure you've pushed the workflow files to GitHub${NC}"
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
echo ""
echo -e "${BLUE}🚀 Triggering signed release build...${NC}"
echo -e "${BLUE}   Developer: $DEVELOPER${NC}"
if [ -n "$APP_NAME" ]; then
    echo -e "${BLUE}   App: $APP_NAME${NC}"
fi
echo -e "${BLUE}   Build type: Signed Release AAB${NC}"
echo ""

RESPONSE=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows/$WORKFLOW_ID/dispatches" "POST" "{\"ref\":\"main\",\"inputs\":$INPUTS}")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "204" ]; then
    echo -e "${GREEN}✅ Build triggered successfully!${NC}"
    echo ""
    echo -e "${BLUE}📊 Monitor build status:${NC}"
    echo "   https://github.com/$GITHUB_USER/$REPO_NAME/actions"
    echo ""
    echo -e "${BLUE}📦 Download AAB files:${NC}"
    echo "   1. Go to Actions → Latest workflow run"
    echo "   2. Scroll to Artifacts section"
    echo "   3. Download the AAB files"
    echo ""
    echo -e "${BLUE}⏱️  Build time: ~5-10 minutes per app${NC}"
    echo ""
    
    # Wait a bit and check status
    sleep 3
    echo -e "${BLUE}🔍 Checking build status...${NC}"
    RUNS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/runs?per_page=1")
    RUN_URL=$(echo "$RUNS" | grep -o '"html_url":"[^"]*' | head -1 | cut -d'"' -f4)
    
    if [ -n "$RUN_URL" ]; then
        echo -e "${GREEN}✅ Build started: $RUN_URL${NC}"
    fi
else
    echo -e "${RED}❌ Failed to trigger workflow${NC}"
    echo "HTTP Code: $HTTP_CODE"
    echo "Response: $RESPONSE"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Signed release build initiated!${NC}"

