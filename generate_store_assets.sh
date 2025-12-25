#!/bin/bash
# Generate Store Assets Using GitHub Resources
# Triggers GitHub Actions workflow to generate icons, graphics, screenshots, descriptions

set -e

GITHUB_TOKEN="${GITHUB_TOKEN:-YOUR_GITHUB_TOKEN}"
GITHUB_USER="ahmedmaache"
REPO_NAME="55-flutter-apps"
GITHUB_API="https://api.github.com"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "══════════════════════════════════════════════════════════════"
echo "   🎨 Generate Store Assets"
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

# Parse arguments
if [ $# -lt 2 ]; then
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 <developer> <app_name>"
    echo ""
    echo -e "${BLUE}Example:${NC}"
    echo "  $0 01_giggle_game joke_generator"
    exit 1
fi

DEVELOPER="$1"
APP_NAME="$2"

echo -e "${BLUE}📋 Asset Generation Details:${NC}"
echo "   Developer: $DEVELOPER"
echo "   App Name: $APP_NAME"
echo ""

# Get workflow ID
echo -e "${BLUE}🔍 Finding workflow...${NC}"
WORKFLOWS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows")
WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | grep -v "build-flutter-apps" | grep -v "create-flutter-apps" | head -1 | cut -d':' -f2)

if [ -z "$WORKFLOW_ID" ]; then
    echo -e "${YELLOW}⚠️  Generate Store Assets workflow not found${NC}"
    echo -e "${BLUE}💡 Make sure you've pushed the workflow file to GitHub${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found workflow ID: $WORKFLOW_ID${NC}"

# Prepare inputs
INPUTS=$(cat <<EOF
{
  "developer": "$DEVELOPER",
  "app_name": "$APP_NAME"
}
EOF
)

# Trigger workflow
echo ""
echo -e "${BLUE}🚀 Triggering asset generation...${NC}"
echo ""

RESPONSE=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows/$WORKFLOW_ID/dispatches" "POST" "{\"ref\":\"main\",\"inputs\":$INPUTS}")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "204" ]; then
    echo -e "${GREEN}✅ Asset generation triggered successfully!${NC}"
    echo ""
    echo -e "${BLUE}📊 Monitor generation status:${NC}"
    echo "   https://github.com/$GITHUB_USER/$REPO_NAME/actions"
    echo ""
    echo -e "${BLUE}📦 Assets will include:${NC}"
    echo "   ✅ Icon (512x512px)"
    echo "   ✅ Feature Graphic (1200x500px)"
    echo "   ✅ Screenshots (1080x1920px)"
    echo "   ✅ Descriptions (short + full)"
    echo ""
    echo -e "${BLUE}⏱️  Generation time: ~2-3 minutes${NC}"
else
    echo -e "${RED}❌ Failed to trigger workflow${NC}"
    echo "HTTP Code: $HTTP_CODE"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Asset generation process initiated!${NC}"

