#!/bin/bash
# Build Flutter Apps in Codespaces
# This script uses Codespaces resources to build Flutter apps

set -e

WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
cd "$WORKSPACE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to build a single app
build_app() {
    local developer_dir="$1"
    local app_name="$2"
    local app_path="$WORKSPACE/$developer_dir/$app_name"
    
    if [ ! -d "$app_path" ]; then
        print_error "App directory not found: $app_path"
        return 1
    fi
    
    print_info "Building $app_name in $developer_dir..."
    cd "$app_path"
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build AAB
    print_info "Building AAB file..."
    if flutter build appbundle --release; then
        if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
            print_success "Build successful for $app_name"
            
            # Get file size
            local file_size=$(du -h "build/app/outputs/bundle/release/app-release.aab" | cut -f1)
            print_info "AAB file size: $file_size"
            
            # Copy to store_assets if directory exists
            local developer_name=$(basename "$developer_dir" | sed 's/_/ /g' | sed 's/\b\w/\u&/g')
            local store_path="$WORKSPACE/store_assets/$developer_name/$app_name"
            if [ -d "$WORKSPACE/store_assets" ]; then
                mkdir -p "$store_path"
                cp "build/app/outputs/bundle/release/app-release.aab" "$store_path/app-release.aab"
                print_success "AAB copied to store_assets"
            fi
            
            return 0
        else
            print_error "AAB file not found after build"
            return 1
        fi
    else
        print_error "Build failed for $app_name"
        return 1
    fi
}

# Function to build all apps for a developer
build_developer_apps() {
    local developer_dir="$1"
    local developer_path="$WORKSPACE/$developer_dir"
    
    if [ ! -d "$developer_path" ]; then
        print_error "Developer directory not found: $developer_path"
        return 1
    fi
    
    print_info "Building all apps for $developer_dir..."
    
    local apps_built=0
    local apps_failed=0
    
    # Find all Flutter apps in the developer directory
    for app_dir in "$developer_path"/*; do
        if [ -d "$app_dir" ] && [ -f "$app_dir/pubspec.yaml" ]; then
            local app_name=$(basename "$app_dir")
            if build_app "$developer_dir" "$app_name"; then
                apps_built=$((apps_built + 1))
            else
                apps_failed=$((apps_failed + 1))
            fi
            echo ""
        fi
    done
    
    print_info "Summary: $apps_built built, $apps_failed failed"
}

# Main script
echo "══════════════════════════════════════════════════════════════"
echo "   🚀 Flutter App Builder for Codespaces"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    print_info "Run: flutter doctor to check installation"
    exit 1
fi

# Check Flutter installation
print_info "Checking Flutter installation..."
flutter doctor

# Parse arguments
if [ $# -eq 0 ]; then
    print_info "Usage:"
    echo "  $0 <developer_dir> [app_name]"
    echo ""
    echo "Examples:"
    echo "  $0 01_giggle_game joke_generator    # Build specific app"
    echo "  $0 01_giggle_game                    # Build all apps for developer"
    echo ""
    echo "Available developers:"
    ls -d */ | grep -E "^[0-9]{2}_" | sed 's|/$||' | sed 's|^|  - |'
    exit 1
fi

DEVELOPER_DIR="$1"
APP_NAME="${2:-}"

if [ -z "$APP_NAME" ]; then
    # Build all apps for the developer
    build_developer_apps "$DEVELOPER_DIR"
else
    # Build specific app
    build_app "$DEVELOPER_DIR" "$APP_NAME"
fi

echo ""
print_success "Build process completed!"
echo ""

