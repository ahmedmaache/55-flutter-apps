#!/bin/bash
set -e

echo "🚀 Setting up Flutter development environment..."

# Install Flutter
FLUTTER_VERSION="3.24.0"
FLUTTER_INSTALL_DIR="/usr/local/flutter"

if [ ! -d "$FLUTTER_INSTALL_DIR" ]; then
    echo "📦 Installing Flutter SDK ${FLUTTER_VERSION}..."
    
    # Download Flutter
    cd /tmp
    wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -O flutter.tar.xz || \
    wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.0-stable.tar.xz" -O flutter.tar.xz
    
    if [ -f flutter.tar.xz ]; then
        sudo mkdir -p "$FLUTTER_INSTALL_DIR"
        sudo tar -xf flutter.tar.xz -C /usr/local/
        sudo chown -R vscode:vscode "$FLUTTER_INSTALL_DIR"
        rm flutter.tar.xz
    else
        echo "⚠️  Could not download Flutter, trying git clone..."
        sudo git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_INSTALL_DIR"
        sudo chown -R vscode:vscode "$FLUTTER_INSTALL_DIR"
    fi
else
    echo "✅ Flutter already installed at $FLUTTER_INSTALL_DIR"
fi

# Install Android Command-line Tools
ANDROID_SDK_ROOT="/usr/local/lib/android/sdk"
if [ ! -d "$ANDROID_SDK_ROOT" ]; then
    echo "🤖 Installing Android Command-line Tools..."
    sudo mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
    cd /tmp
    wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -O cmdline-tools.zip
    sudo unzip -q cmdline-tools.zip -d "$ANDROID_SDK_ROOT/cmdline-tools"
    sudo mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"
    sudo chown -R vscode:vscode "$ANDROID_SDK_ROOT"
    rm cmdline-tools.zip
fi

# Add Flutter and Android to PATH
export PATH="$FLUTTER_INSTALL_DIR/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export CHROME_EXECUTABLE="/usr/bin/google-chrome"

echo 'export ANDROID_HOME="/usr/local/lib/android/sdk"' >> ~/.bashrc
echo 'export PATH="/usr/local/flutter/bin:/usr/local/lib/android/sdk/cmdline-tools/latest/bin:/usr/local/lib/android/sdk/platform-tools:$PATH"' >> ~/.bashrc
echo 'export CHROME_EXECUTABLE="/usr/bin/google-chrome"' >> ~/.bashrc

# Add Flutter aliases
cat >> ~/.bashrc << 'EOF'

# Flutter aliases
alias fdoctor='flutter doctor'
alias fbuild='flutter build appbundle --release'
alias frun='flutter run'
alias fclean='flutter clean'
alias fget='flutter pub get'
EOF

# Install Flutter dependencies
echo "📚 Installing Flutter dependencies..."
flutter --version
flutter doctor

# Install Android SDK components
echo "🤖 Installing Android SDK platforms and build-tools..."
sdkmanager --sdk_root="$ANDROID_SDK_ROOT" "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Accept Android licenses (for Android builds)
echo "📝 Setting up Android licenses..."
yes | sdkmanager --sdk_root="$ANDROID_SDK_ROOT" --licenses || echo "⚠️  Licenses already accepted"
yes | flutter doctor --android-licenses || echo "⚠️  Android licenses setup skipped (may need manual setup)"

# Precache Flutter
echo "💾 Precaching Flutter artifacts..."
flutter precache --android

# Install additional tools
echo "🔧 Installing additional tools..."
sudo apt-get update
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    xz-utils \
    zip \
    libglu1-mesa \
    build-essential \
    default-jdk \
    android-tools-adb

# Setup pub cache
echo "📦 Setting up pub cache..."
flutter pub cache repair || true

# Setup GitHub authentication (if token is available)
if [ -n "$GITHUB_TOKEN" ]; then
    echo "🔐 Configuring GitHub authentication..."
    
    # Configure git credential helper
    git config --global credential.helper store
    
    # Store token in git credentials
    echo "https://${GITHUB_TOKEN}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    
    # Configure GitHub CLI if available
    if command -v gh &> /dev/null; then
        echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null || echo "⚠️  GitHub CLI authentication skipped"
    fi
    
    echo "✅ GitHub authentication configured"
elif [ -f ~/.github_token ]; then
    echo "🔐 Configuring GitHub authentication from file..."
    GITHUB_TOKEN=$(cat ~/.github_token)
    git config --global credential.helper store
    echo "https://${GITHUB_TOKEN}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    echo "✅ GitHub authentication configured from file"
else
    echo "ℹ️  GITHUB_TOKEN not set. To configure:"
    echo "   - Set GITHUB_TOKEN environment variable in Codespaces secrets"
    echo "   - Or run: echo 'YOUR_TOKEN' > ~/.github_token"
fi

# Verify installation
echo ""
echo "✅ Flutter setup complete!"
echo ""
echo "📊 Flutter Doctor Status:"
flutter doctor -v

echo ""
echo "🎉 Your Flutter development environment is ready!"
echo "   You can now:"
echo "   - Run 'flutter create <app_name>' to create new apps"
echo "   - Run 'flutter build appbundle --release' to build AAB files"
echo "   - Run 'flutter run' to test apps"
echo ""

