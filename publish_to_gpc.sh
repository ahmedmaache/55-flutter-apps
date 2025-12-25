#!/bin/bash
# Publish Android App to Google Play Console
# Complete workflow: Build AAB + Generate Assets + Publish

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
echo "   📱 Publish to Google Play Console"
echo "   Complete Workflow Using GitHub Resources"
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

# Parse arguments
if [ $# -lt 3 ]; then
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 <developer> <app_name> <release_track>"
    echo ""
    echo -e "${BLUE}Release Tracks:${NC}"
    echo "  - internal  (Internal testing)"
    echo "  - alpha     (Alpha testing)"
    echo "  - beta      (Beta testing)"
    echo "  - production (Production release)"
    echo ""
    echo -e "${BLUE}Example:${NC}"
    echo "  $0 01_giggle_game joke_generator production"
    exit 1
fi

DEVELOPER="$1"
APP_NAME="$2"
RELEASE_TRACK="$3"

# Validate release track
if [[ ! "$RELEASE_TRACK" =~ ^(internal|alpha|beta|production)$ ]]; then
    echo -e "${RED}❌ Invalid release track: $RELEASE_TRACK${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Publishing Details:${NC}"
echo "   Developer: $DEVELOPER"
echo "   App Name: $APP_NAME"
echo "   Release Track: $RELEASE_TRACK"
echo ""

# Get workflow ID
echo -e "${BLUE}🔍 Finding workflow...${NC}"
WORKFLOWS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows")
WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | grep "publish-to-gpc" | head -1 | cut -d':' -f2)

if [ -z "$WORKFLOW_ID" ]; then
    # Try to find by name
    WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    if [ -z "$WORKFLOW_ID" ]; then
        echo -e "${RED}❌ Publish workflow not found${NC}"
        echo -e "${BLUE}💡 Make sure you've pushed the workflow file to GitHub${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Found workflow ID: $WORKFLOW_ID${NC}"

# Prepare inputs
INPUTS=$(cat <<EOF
{
  "developer": "$DEVELOPER",
  "app_name": "$APP_NAME",
  "release_track": "$RELEASE_TRACK"
}
EOF
)

# Trigger workflow
echo ""
echo -e "${BLUE}🚀 Triggering publish workflow...${NC}"
echo -e "${BLUE}   This will:${NC}"
echo "   1. Build signed AAB file"
echo "   2. Generate store assets (icons, graphics, screenshots, descriptions)"
echo "   3. Package everything"
echo "   4. Upload to Google Play Console (if configured)"
echo ""

RESPONSE=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows/$WORKFLOW_ID/dispatches" "POST" "{\"ref\":\"main\",\"inputs\":$INPUTS}")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "204" ]; then
    echo -e "${GREEN}✅ Publish workflow triggered successfully!${NC}"
    echo ""
    echo -e "${BLUE}📊 Monitor publish status:${NC}"
    echo "   https://github.com/$GITHUB_USER/$REPO_NAME/actions"
    echo ""
    echo -e "${BLUE}📦 Package will include:${NC}"
    echo "   ✅ Signed AAB file"
    echo "   ✅ Icon (512x512px)"
    echo "   ✅ Feature Graphic (1200x500px)"
    echo "   ✅ Screenshots"
    echo "   ✅ Descriptions (short + full)"
    echo ""
    echo -e "${BLUE}⏱️  Estimated time: ~10-15 minutes${NC}"
    echo ""
    echo -e "${YELLOW}💡 Note: GPC upload requires API setup${NC}"
    echo -e "${YELLOW}💡 See GPC_API_SETUP.md for instructions${NC}"
else
    echo -e "${RED}❌ Failed to trigger workflow${NC}"
    echo "HTTP Code: $HTTP_CODE"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Publish process initiated!${NC}"

