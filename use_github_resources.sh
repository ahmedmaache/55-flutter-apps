#!/bin/bash
# Use GitHub Resources Script
# This script uses your GitHub token to interact with GitHub API and resources

set -e

GITHUB_TOKEN="${GITHUB_TOKEN:-YOUR_GITHUB_TOKEN}"
GITHUB_API="https://api.github.com"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "══════════════════════════════════════════════════════════════"
echo "   🔧 Using GitHub Resources"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Function to make GitHub API calls
gh_api() {
    local endpoint="$1"
    local method="${2:-GET}"
    local data="${3:-}"
    
    if [ -n "$data" ]; then
        curl -s -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$GITHUB_API$endpoint"
    else
        curl -s -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "$GITHUB_API$endpoint"
    fi
}

# Get user info
echo -e "${BLUE}📊 Getting GitHub user information...${NC}"
USER_INFO=$(gh_api "/user")
USERNAME=$(echo "$USER_INFO" | grep -o '"login":"[^"]*' | cut -d'"' -f4)
echo -e "${GREEN}✅ Logged in as: $USERNAME${NC}"
echo ""

# List repositories
echo -e "${BLUE}📦 Listing your repositories...${NC}"
REPOS=$(gh_api "/user/repos?per_page=10&sort=updated")
echo "$REPOS" | grep -o '"name":"[^"]*' | cut -d'"' -f4 | head -10
echo ""

# Check if repository exists
REPO_NAME="55-flutter-apps"
echo -e "${BLUE}🔍 Checking for repository: $REPO_NAME...${NC}"
REPO_CHECK=$(gh_api "/repos/$USERNAME/$REPO_NAME" 2>&1)

if echo "$REPO_CHECK" | grep -q '"name"'; then
    echo -e "${GREEN}✅ Repository exists: $USERNAME/$REPO_NAME${NC}"
    
    # Get repository info
    REPO_URL=$(echo "$REPO_CHECK" | grep -o '"clone_url":"[^"]*' | cut -d'"' -f4)
    echo -e "${BLUE}📋 Clone URL: $REPO_URL${NC}"
    
    # Check if workflows are enabled
    echo -e "${BLUE}🔧 Checking GitHub Actions status...${NC}"
    ACTIONS_ENABLED=$(gh_api "/repos/$USERNAME/$REPO_NAME/actions/permissions" 2>&1)
    if echo "$ACTIONS_ENABLED" | grep -q '"enabled":true'; then
        echo -e "${GREEN}✅ GitHub Actions is enabled${NC}"
    else
        echo -e "${YELLOW}⚠️  GitHub Actions may need to be enabled${NC}"
    fi
    
    # List workflow runs
    echo -e "${BLUE}📊 Recent workflow runs:${NC}"
    WORKFLOWS=$(gh_api "/repos/$USERNAME/$REPO_NAME/actions/runs?per_page=5" 2>&1)
    echo "$WORKFLOWS" | grep -E '"name"|"status"|"conclusion"' | head -9
    
else
    echo -e "${YELLOW}⚠️  Repository not found: $USERNAME/$REPO_NAME${NC}"
    echo -e "${BLUE}💡 You can create it with:${NC}"
    echo "   gh repo create $REPO_NAME --public --source=. --remote=origin --push"
    echo ""
    echo -e "${BLUE}Or create it via API:${NC}"
    CREATE_REPO=$(gh_api "/user/repos" "POST" "{\"name\":\"$REPO_NAME\",\"description\":\"55 Flutter Apps - Automated builds with GitHub Actions\",\"private\":false,\"auto_init\":false}")
    if echo "$CREATE_REPO" | grep -q '"name"'; then
        echo -e "${GREEN}✅ Repository created!${NC}"
    fi
fi

echo ""
echo -e "${BLUE}🚀 GitHub Resources Available:${NC}"
echo "   ✅ GitHub Actions (automated builds)"
echo "   ✅ GitHub Codespaces (cloud development)"
echo "   ✅ Artifact storage (30 days)"
echo "   ✅ Workflow dispatch (manual triggers)"
echo ""
echo -e "${GREEN}✅ GitHub resources ready to use!${NC}"

