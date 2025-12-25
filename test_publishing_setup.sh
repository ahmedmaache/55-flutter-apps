#!/bin/bash
# Test Publishing Setup
# Verifies all components are ready for publishing

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
echo "   🧪 Testing Publishing Setup"
echo "══════════════════════════════════════════════════════════════"
echo ""

ERRORS=0
WARNINGS=0

# Test 1: Check workflows
echo -e "${BLUE}📋 Test 1: Checking workflows...${NC}"
if [ -d ".github/workflows" ]; then
    WORKFLOW_COUNT=$(ls -1 .github/workflows/*.yml 2>/dev/null | wc -l)
    if [ "$WORKFLOW_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✅ Found $WORKFLOW_COUNT workflows${NC}"
        
        # Check for key workflows
        KEY_WORKFLOWS=("publish-to-gpc.yml" "build-flutter-apps.yml" "generate-store-assets.yml")
        for workflow in "${KEY_WORKFLOWS[@]}"; do
            if [ -f ".github/workflows/$workflow" ]; then
                echo -e "${GREEN}  ✅ $workflow${NC}"
            else
                echo -e "${YELLOW}  ⚠️  $workflow not found${NC}"
                WARNINGS=$((WARNINGS + 1))
            fi
        done
    else
        echo -e "${RED}❌ No workflows found${NC}"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}❌ .github/workflows directory not found${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Test 2: Check scripts
echo -e "${BLUE}🔧 Test 2: Checking scripts...${NC}"
KEY_SCRIPTS=("publish_to_gpc.sh" "build_signed_release.sh" "generate_store_assets.sh")
for script in "${KEY_SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo -e "${GREEN}✅ $script (executable)${NC}"
    elif [ -f "$script" ]; then
        echo -e "${YELLOW}⚠️  $script (not executable)${NC}"
        chmod +x "$script"
        echo -e "${GREEN}  ✅ Made executable${NC}"
    else
        echo -e "${RED}❌ $script not found${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done
echo ""

# Test 3: Check apps
echo -e "${BLUE}📱 Test 3: Checking apps...${NC}"
if [ -d "01_giggle_game/joke_generator" ]; then
    echo -e "${GREEN}✅ Test app found: 01_giggle_game/joke_generator${NC}"
    
    # Check if it's a Flutter app
    if [ -f "01_giggle_game/joke_generator/pubspec.yaml" ]; then
        echo -e "${GREEN}  ✅ Valid Flutter app${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Missing pubspec.yaml${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${YELLOW}⚠️  Test app not found (will be created when needed)${NC}"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Test 4: Check documentation
echo -e "${BLUE}📚 Test 4: Checking documentation...${NC}"
KEY_DOCS=("PUBLISH_TO_GPC_PLAN.md" "APPS_TO_GPC_MAPPING.md" "GPC_API_SETUP.md" "READY_TO_PUBLISH.md")
for doc in "${KEY_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo -e "${GREEN}✅ $doc${NC}"
    else
        echo -e "${YELLOW}⚠️  $doc not found${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done
echo ""

# Test 5: Check GitHub token
echo -e "${BLUE}🔐 Test 5: Checking GitHub token...${NC}"
if [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${GREEN}✅ GITHUB_TOKEN environment variable set${NC}"
    
    # Test API access
    RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user 2>&1)
    if echo "$RESPONSE" | grep -q '"login"'; then
        USERNAME=$(echo "$RESPONSE" | grep -o '"login":"[^"]*' | cut -d'"' -f4)
        echo -e "${GREEN}  ✅ API access working (user: $USERNAME)${NC}"
    else
        echo -e "${YELLOW}  ⚠️  API access test failed${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${YELLOW}⚠️  GITHUB_TOKEN not set (will use default)${NC}"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Test 6: Check Flutter
echo -e "${BLUE}🦋 Test 6: Checking Flutter...${NC}"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -1)
    echo -e "${GREEN}✅ Flutter installed: $FLUTTER_VERSION${NC}"
else
    echo -e "${YELLOW}⚠️  Flutter not in PATH (will be installed in GitHub Actions)${NC}"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Summary
echo "══════════════════════════════════════════════════════════════"
echo "   📊 Test Summary"
echo "══════════════════════════════════════════════════════════════"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed! Ready to publish.${NC}"
    echo ""
    echo -e "${BLUE}🚀 Next steps:${NC}"
    echo "  1. Set up GitHub Secrets (see READY_TO_PUBLISH.md)"
    echo "  2. Run: ./publish_to_gpc.sh 01_giggle_game joke_generator internal"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Tests passed with $WARNINGS warning(s)${NC}"
    echo -e "${GREEN}✅ Setup is functional, but some optimizations recommended${NC}"
    echo ""
    echo -e "${BLUE}🚀 You can proceed with publishing${NC}"
    exit 0
else
    echo -e "${RED}❌ Tests failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo -e "${YELLOW}⚠️  Please fix errors before publishing${NC}"
    exit 1
fi

