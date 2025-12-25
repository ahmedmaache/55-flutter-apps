#!/bin/bash
# Setup Android Signing for Release Builds
# This script helps set up signing configuration for all apps

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
echo "   🔐 Android Release Signing Setup"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check if keystore exists
KEYSTORE_PATH="$WORKSPACE/android/app/upload-keystore.jks"
KEY_PROPERTIES_PATH="$WORKSPACE/android/key.properties"

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo -e "${YELLOW}⚠️  Keystore not found. Creating new keystore...${NC}"
    echo ""
    echo -e "${BLUE}📝 You'll need to provide:${NC}"
    echo "   - Keystore password"
    echo "   - Key alias"
    echo "   - Key password"
    echo ""
    
    read -sp "Enter keystore password: " KEYSTORE_PASSWORD
    echo ""
    read -p "Enter key alias (default: upload): " KEY_ALIAS
    KEY_ALIAS=${KEY_ALIAS:-upload}
    read -sp "Enter key password: " KEY_PASSWORD
    echo ""
    read -p "Enter your name/org (for certificate): " CERT_NAME
    CERT_NAME=${CERT_NAME:-"Gloven Incubator"}
    
    # Create keystore
    keytool -genkey -v -keystore "$KEYSTORE_PATH" \
        -alias "$KEY_ALIAS" \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -storepass "$KEYSTORE_PASSWORD" \
        -keypass "$KEY_PASSWORD" \
        -dname "CN=$CERT_NAME, OU=Mobile, O=Gloven, L=City, ST=State, C=US"
    
    echo -e "${GREEN}✅ Keystore created at $KEYSTORE_PATH${NC}"
else
    echo -e "${GREEN}✅ Keystore found at $KEYSTORE_PATH${NC}"
    read -sp "Enter keystore password: " KEYSTORE_PASSWORD
    echo ""
    read -p "Enter key alias (default: upload): " KEY_ALIAS
    KEY_ALIAS=${KEY_ALIAS:-upload}
    read -sp "Enter key password: " KEY_PASSWORD
    echo ""
fi

# Create key.properties file
mkdir -p "$(dirname "$KEY_PROPERTIES_PATH")"
cat > "$KEY_PROPERTIES_PATH" << EOF
storePassword=$KEYSTORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=../upload-keystore.jks
EOF

echo -e "${GREEN}✅ Key properties file created${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "   1. Store these values in GitHub Secrets:"
echo "      - KEYSTORE_PASSWORD: $KEYSTORE_PASSWORD"
echo "      - KEY_PASSWORD: $KEY_PASSWORD"
echo "      - KEY_ALIAS: $KEY_ALIAS"
echo "   2. Upload keystore to GitHub Secrets (base64 encoded)"
echo "   3. Update build.gradle.kts files (this script can do it)"
echo ""

read -p "Update all build.gradle.kts files now? (y/n): " UPDATE_GRADLE
if [ "$UPDATE_GRADLE" = "y" ]; then
    echo -e "${BLUE}🔄 Updating build.gradle.kts files...${NC}"
    # This will be done by another script
    echo -e "${GREEN}✅ Run update_gradle_signing.sh to update all files${NC}"
fi

echo ""
echo -e "${GREEN}✅ Signing setup complete!${NC}"

