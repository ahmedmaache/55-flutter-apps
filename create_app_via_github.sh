#!/bin/bash
# Create New Flutter App Using GitHub Resources
# This script uses GitHub Actions to create new Flutter apps

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
echo "   🚀 Create New Flutter App"
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

# Developer account mapping
declare -A DEVELOPER_ORGS=(
    ["01_giggle_game"]="org.gloven.giggle"
    ["02_playpal_creations"]="org.gloven.playpal"
    ["03_olaf"]="org.gloven.olaf"
    ["04_good_kids"]="org.gloven.goodkids"
    ["05_apocalypse_never"]="org.gloven.apocalypse"
    ["06_atomizer"]="org.gloven.atomizer"
    ["07_okkyes"]="org.gloven.okkyes"
    ["08_insightful_apps"]="org.gloven.insight"
    ["09_build_deploy_labs"]="org.gloven.devlabs"
    ["10_micho"]="org.gloven.micho"
    ["11_playtime_programmers"]="org.gloven.playcode"
)

# Parse arguments or prompt
if [ $# -lt 2 ]; then
    echo -e "${BLUE}📋 Available Developer Accounts:${NC}"
    for dev in "${!DEVELOPER_ORGS[@]}"; do
        echo "   - $dev"
    done
    echo ""
    read -p "Enter developer account (e.g., 01_giggle_game): " DEVELOPER
    read -p "Enter app name (e.g., joke_generator): " APP_NAME
else
    DEVELOPER="$1"
    APP_NAME="$2"
fi

# Validate developer
if [ -z "${DEVELOPER_ORGS[$DEVELOPER]}" ]; then
    echo -e "${RED}❌ Invalid developer account: $DEVELOPER${NC}"
    exit 1
fi

PACKAGE_ORG="${DEVELOPER_ORGS[$DEVELOPER]}"

echo -e "${BLUE}📋 App Creation Details:${NC}"
echo "   Developer: $DEVELOPER"
echo "   App Name: $APP_NAME"
echo "   Package: $PACKAGE_ORG"
echo ""

# Get workflow ID
echo -e "${BLUE}🔍 Finding workflow...${NC}"
WORKFLOWS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows")
WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | grep -v "build-flutter-apps" | head -1 | cut -d':' -f2)

if [ -z "$WORKFLOW_ID" ]; then
    echo -e "${YELLOW}⚠️  Create workflow not found. Using build workflow as fallback...${NC}"
    WORKFLOW_ID=$(echo "$WORKFLOWS" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
fi

if [ -z "$WORKFLOW_ID" ]; then
    echo -e "${RED}❌ No workflows found${NC}"
    echo -e "${BLUE}💡 Make sure you've pushed the workflow files to GitHub${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Found workflow ID: $WORKFLOW_ID${NC}"

# Prepare inputs
INPUTS=$(cat <<EOF
{
  "developer": "$DEVELOPER",
  "app_name": "$APP_NAME",
  "package_org": "$PACKAGE_ORG",
  "create_all": "false"
}
EOF
)

# Trigger workflow
echo ""
echo -e "${BLUE}🚀 Triggering app creation...${NC}"
echo ""

RESPONSE=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/workflows/$WORKFLOW_ID/dispatches" "POST" "{\"ref\":\"main\",\"inputs\":$INPUTS}")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)

if [ "$HTTP_CODE" = "204" ]; then
    echo -e "${GREEN}✅ App creation triggered successfully!${NC}"
    echo ""
    echo -e "${BLUE}📊 Monitor creation status:${NC}"
    echo "   https://github.com/$GITHUB_USER/$REPO_NAME/actions"
    echo ""
    echo -e "${BLUE}⏱️  Creation time: ~2-3 minutes${NC}"
    echo ""
    
    # Wait and check status
    sleep 3
    echo -e "${BLUE}🔍 Checking workflow status...${NC}"
    RUNS=$(gh_api "/repos/$GITHUB_USER/$REPO_NAME/actions/runs?per_page=1")
    RUN_URL=$(echo "$RUNS" | grep -o '"html_url":"[^"]*' | head -1 | cut -d'"' -f4)
    
    if [ -n "$RUN_URL" ]; then
        echo -e "${GREEN}✅ Workflow started: $RUN_URL${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}📋 Next steps after creation:${NC}"
    echo "   1. Wait for workflow to complete (~2-3 minutes)"
    echo "   2. Check the Actions tab for status"
    echo "   3. Review the created app structure"
    echo "   4. Add app-specific code and features"
    echo "   5. Build and test the app"
    
else
    echo -e "${RED}❌ Failed to trigger workflow${NC}"
    echo "HTTP Code: $HTTP_CODE"
    echo "Response: $RESPONSE"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ App creation process initiated!${NC}"

