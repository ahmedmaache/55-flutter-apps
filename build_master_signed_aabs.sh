#!/bin/bash
# 🚀 55 FLUTTER APPS - MASTER SIGNED AAB BUILDER
# This script builds all 55 apps sequentially for release.

set -e

# Configuration
WORKSPACE=$(pwd)
OUTPUT_DIR="$WORKSPACE/FINAL_RELEASE_AABS"
REPORT_FILE="$WORKSPACE/build_status_report.md"
MASTER_KEY_PROPERTIES="$WORKSPACE/android/key.properties"
MASTER_KEYSTORE="$WORKSPACE/android/app/upload-keystore.jks"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}   🏗️  MASTER BUILDER: 55 SIGNED FLUTTER AABS${NC}"
echo -e "${BLUE}======================================================${NC}"

# Initialize
mkdir -p "$OUTPUT_DIR"
echo "# 📊 Build Status Report - $(date)" > "$REPORT_FILE"
echo "| App Path | Status | AAB Size |" >> "$REPORT_FILE"
echo "|----------|--------|----------|" >> "$REPORT_FILE"

# Stats
SUCCESS_COUNT=0
FAIL_COUNT=0
TOTAL_APPS=0

# Find all apps
APPS=$(find . -name "pubspec.yaml" -path "*/[0-9]*_*/*" | sed 's|/pubspec.yaml||' | sort)
COUNT=$(echo "$APPS" | wc -l)

echo -e "${YELLOW}🔍 Found $COUNT Flutter applications to build.${NC}"
echo ""

for APP_PATH in $APPS; do
    TOTAL_APPS=$((TOTAL_APPS + 1))
    APP_NAME=$(basename "$APP_PATH")
    DEV_DIR=$(basename $(dirname "$APP_PATH"))
    AAB_DEST="$OUTPUT_DIR/${DEV_DIR}_${APP_NAME}_release.aab"
    if [ -f "$AAB_DEST" ]; then
        echo -e "${YELLOW}⏭️  Skipping: $DEV_DIR/$APP_NAME (Already built)${NC}"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        continue
    fi

    # Check disk space (require at least 500MB to start)
    FREE_SPACE=$(df -m / | tail -1 | awk '{print $4}')
    if [ "$FREE_SPACE" -lt 500 ]; then
        echo -e "${RED}⚠️  Low disk space ($FREE_SPACE MB). Running aggressive cleanup...${NC}"
        rm -rf ~/.cache/*
        # Find build folders in other apps and clean them
        find "$WORKSPACE" -name "build" -type d -prune -exec rm -rf {} + || true
    fi

    echo -e "${BLUE}[$TOTAL_APPS/$COUNT] Building: $DEV_DIR/$APP_NAME...${NC}"
    
    cd "$WORKSPACE/$APP_PATH"
    
    # 1. Ensure Signing Files
    mkdir -p android/app
    if [ -f "$MASTER_KEY_PROPERTIES" ]; then
        cp "$MASTER_KEY_PROPERTIES" "android/key.properties"
    fi
    if [ -f "$MASTER_KEYSTORE" ]; then
        cp "$MASTER_KEYSTORE" "android/app/upload-keystore.jks"
    fi
    
    # 2. Build
    # Run with limited memory if possible, but standard build for now
    if flutter clean > /dev/null && flutter pub get > /dev/null && flutter build appbundle --release; then
        AAB_SOURCE="build/app/outputs/bundle/release/app-release.aab"
        
        if [ -f "$AAB_SOURCE" ]; then
            SIZE=$(du -h "$AAB_SOURCE" | cut -f1)
            mv "$AAB_SOURCE" "$AAB_DEST"
            
            # Post-build cleanup to save space
            flutter clean > /dev/null
            
            echo -e "${GREEN}✅ Success: $SIZE${NC}"
            echo "| $DEV_DIR/$APP_NAME | ✅ Success | $SIZE |" >> "$REPORT_FILE"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            echo -e "${RED}❌ Error: AAB file not found after build!${NC}"
            echo "| $DEV_DIR/$APP_NAME | ❌ AAB Missing | - |" >> "$REPORT_FILE"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo -e "${RED}❌ Error: Build failed!${NC}"
        echo "| $DEV_DIR/$APP_NAME | ❌ Build Failed | - |" >> "$REPORT_FILE"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    
    cd "$WORKSPACE"
    echo "------------------------------------------------------"
done

# Final Summary
echo ""
echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}🎉 BUILD COMPLETE!${NC}"
echo -e "✅ Successful: $SUCCESS_COUNT"
echo -e "❌ Failed:     $FAIL_COUNT"
echo -e "📂 Artifacts:  $OUTPUT_DIR"
echo -e "📊 Report:     $REPORT_FILE"
echo -e "${BLUE}======================================================${NC}"
