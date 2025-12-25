#!/bin/bash
# Cleanup script to free disk space on local PC
# Removes build artifacts, caches, and temporary files

set -e

WORKSPACE="/home/maache/55 flutterapps"
cd "$WORKSPACE"

echo "══════════════════════════════════════════════════════════════"
echo "   🧹 Cleaning Local Workspace to Free Disk Space"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Show initial size
INITIAL_SIZE=$(du -sh . | cut -f1)
echo "Initial workspace size: $INITIAL_SIZE"
echo ""

# Delete build folders
echo "🗑️  Deleting build folders..."
find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
echo "✅ Build folders deleted"

# Delete .dart_tool folders
echo "🗑️  Deleting .dart_tool folders..."
find . -type d -name ".dart_tool" -exec rm -rf {} + 2>/dev/null || true
echo "✅ .dart_tool folders deleted"

# Delete .gradle cache
echo "🗑️  Deleting .gradle cache..."
find . -type d -name ".gradle" -exec rm -rf {} + 2>/dev/null || true
echo "✅ .gradle folders deleted"

# Delete iOS artifacts
echo "🗑️  Deleting iOS build artifacts..."
find . -type d -name "DerivedData" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name "Pods" -exec rm -rf {} + 2>/dev/null || true
find . -type d -name ".symlinks" -exec rm -rf {} + 2>/dev/null || true
echo "✅ iOS artifacts deleted"

# Delete pub cache
echo "🗑️  Deleting pub cache..."
find . -type d -name ".pub-cache" -exec rm -rf {} + 2>/dev/null || true
find . -name "pubspec.lock" -delete 2>/dev/null || true
echo "✅ Pub cache cleaned"

# Delete ephemeral files
echo "🗑️  Deleting ephemeral files..."
find . -type d -name "ephemeral" -exec rm -rf {} + 2>/dev/null || true
find . -name "Generated.xcconfig" -delete 2>/dev/null || true
find . -name "flutter_export_environment.sh" -delete 2>/dev/null || true
echo "✅ Ephemeral files deleted"

# Delete temporary files
echo "🗑️  Deleting temporary files..."
find . -name "*.swp" -delete 2>/dev/null || true
find . -name "*.swo" -delete 2>/dev/null || true
find . -name "*~" -delete 2>/dev/null || true
echo "✅ Temporary files deleted"

# Show final size
FINAL_SIZE=$(du -sh . | cut -f1)
echo ""
echo "══════════════════════════════════════════════════════════════"
echo "   ✅ Cleanup Complete!"
echo "══════════════════════════════════════════════════════════════"
echo "Initial size: $INITIAL_SIZE"
echo "Final size:   $FINAL_SIZE"
echo ""
df -h / | tail -1
echo ""
echo "💡 Note: Build artifacts can be regenerated with 'flutter build'"
echo "💡 All AAB files are safely stored on remote PC: maache@192.168.1.24"

