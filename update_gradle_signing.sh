#!/bin/bash
# Update all build.gradle.kts files to use release signing
# This script updates all Android build files to support release signing

set -e

WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
cd "$WORKSPACE"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "══════════════════════════════════════════════════════════════"
echo "   🔧 Updating Android Build Files for Release Signing"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Find all build.gradle.kts files
GRADLE_FILES=$(find . -path "*/android/app/build.gradle.kts" -type f)

TOTAL=0
UPDATED=0

for gradle_file in $GRADLE_FILES; do
    TOTAL=$((TOTAL + 1))
    
    # Check if already has signing config (commented out to allow forced update)
    # if grep -q "signingConfigs" "$gradle_file"; then
    #     echo -e "${YELLOW}⏭️  Skipping $gradle_file (already configured)${NC}"
    #     continue
    # fi
    
    # Read the file
    CONTENT=$(cat "$gradle_file")
    
    # Updated check: always update build.gradle.kts files
    if true; then
        # Create backup
        cp "$gradle_file" "$gradle_file.bak"
        
        # Create new content with signing config
        NEW_CONTENT=$(cat << 'EOF'
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "REPLACE_NAMESPACE"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "REPLACE_APPLICATION_ID"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
EOF
)
        
        # Extract namespace and applicationId from original file
        NAMESPACE=$(grep -o 'namespace = "[^"]*' "$gradle_file" | cut -d'"' -f2)
        APPLICATION_ID=$(grep -o 'applicationId = "[^"]*' "$gradle_file" | cut -d'"' -f2)
        
        # Replace placeholders
        NEW_CONTENT=$(echo "$NEW_CONTENT" | sed "s/REPLACE_NAMESPACE/$NAMESPACE/g")
        NEW_CONTENT=$(echo "$NEW_CONTENT" | sed "s/REPLACE_APPLICATION_ID/$APPLICATION_ID/g")
        
        # Write new content
        echo "$NEW_CONTENT" > "$gradle_file"
        
        UPDATED=$((UPDATED + 1))
        echo -e "${GREEN}✅ Updated $gradle_file${NC}"
    else
        echo -e "${YELLOW}⏭️  Skipping $gradle_file (no debug signing found)${NC}"
    fi
done

echo ""
echo -e "${GREEN}✅ Updated $UPDATED out of $TOTAL build.gradle.kts files${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "   1. Create key.properties file in each app's android/ directory"
echo "   2. Or use GitHub Secrets for CI/CD builds"
echo "   3. Build signed AAB files using GitHub Actions"

