# GitHub Codespaces Setup Guide

## 🚀 Quick Start

### 1. Initialize Git Repository (if not already done)

```bash
cd "/home/maache/55 flutterapps"
git init
git add .
git commit -m "Initial commit: 55 Flutter Apps workspace"
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (e.g., `55-flutter-apps`)
3. **Don't** initialize with README (we already have files)

### 3. Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/55-flutter-apps.git
git branch -M main
git push -u origin main
```

### 4. Open in Codespaces

1. Go to your repository on GitHub
2. Click the green "Code" button
3. Select "Codespaces" tab
4. Click "Create codespace on main"
5. Wait for setup (first time takes ~5-10 minutes)
   - The `.devcontainer` configuration will automatically:
     - Install Flutter SDK
     - Set up Python 3.11
     - Install Java 17 (for Android builds)
     - Configure VS Code with Flutter extensions
     - Run post-create setup scripts

## 📁 Workspace Structure in Codespaces

The workspace will be automatically set up with:
- ✅ Flutter SDK installed (via `.devcontainer` configuration)
- ✅ Python 3.11 for scripts
- ✅ Java 17 for Android builds
- ✅ VS Code extensions (Dart, Flutter, Python, GitLens)
- ✅ All your apps and store assets
- ✅ Pre-configured Flutter aliases (fdoctor, fbuild, frun, etc.)

## 🔧 Working in Codespaces

### Build AAB Files

#### Option 1: Using the Build Script (Recommended)

```bash
# Build a specific app
./build_in_codespaces.sh 01_giggle_game joke_generator

# Build all apps for a developer
./build_in_codespaces.sh 01_giggle_game
```

#### Option 2: Manual Build

```bash
cd 01_giggle_game/joke_generator
flutter clean
flutter pub get
flutter build appbundle --release
```

#### Option 3: Using GitHub Actions

1. Go to **Actions** tab in GitHub
2. Select **Build Flutter Apps** workflow
3. Click **Run workflow**
4. Select developer and app
5. Download artifacts when complete

See [GITHUB_ACTIONS_BUILD.md](./GITHUB_ACTIONS_BUILD.md) for detailed instructions.

### Run Scripts

```bash
python3 create_wordpress_posts.py
```

### Access Files

All files are in the workspace root, same structure as local/remote PC.

## 💾 Syncing Between Environments

### From Local to Codespaces
```bash
git add .
git commit -m "Update workspace"
git push
```
Then pull in Codespaces:
```bash
git pull
```

### From Codespaces to Local
```bash
# In Codespaces
git add .
git commit -m "Changes from Codespaces"
git push

# On local
git pull
```

### From Remote PC to Codespaces
```bash
# On remote PC
cd ~/55_flutterapps
git add .
git commit -m "Changes from remote PC"
git push

# In Codespaces
git pull
```

## 🎯 Multi-Environment Workflow

You now have **3 environments**:

1. **Local PC** - Original workspace (low storage)
2. **Remote PC** (192.168.1.24) - High storage, good for builds
3. **GitHub Codespaces** - Cloud-based, accessible anywhere

### Recommended Workflow

- **Development:** Use Codespaces or Remote PC
- **Building AAB files:** Use Remote PC (best performance)
- **Testing:** Use any environment
- **Version Control:** Push to GitHub, pull in any environment

## 📋 Codespaces Features

- **Free tier:** 60 hours/month, 2-core machine
- **Upgrade options:** 4-core, 8-core machines available
- **Storage:** 32GB default (can be increased)
- **Auto-save:** Changes saved automatically
- **Terminal:** Full Linux terminal access

## 🔐 GitHub Token Setup

To use your GitHub token in Codespaces, you have two options:

### Option 1: Using Codespaces Secrets (Recommended)

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Codespaces**
3. Click **New repository secret**
4. Name: `GITHUB_TOKEN`
5. Value: Your GitHub personal access token
6. Click **Add secret**

The token will be automatically available as an environment variable when you create a new Codespace.

### Option 2: Manual Setup in Codespaces

If you prefer to set it up manually after creating a Codespace:

```bash
# Run the setup script
./setup_codespaces_token.sh YOUR_TOKEN_HERE

# Or set it manually
export GITHUB_TOKEN="YOUR_TOKEN_HERE"
echo "export GITHUB_TOKEN=\"YOUR_TOKEN_HERE\"" >> ~/.bashrc
```

The token will be configured for:
- ✅ Git operations (push/pull)
- ✅ GitHub CLI (`gh` commands)
- ✅ Private repository access

## 🔐 Security Notes

- Store sensitive files (keystores, passwords) in GitHub Secrets
- Use `.gitignore` to exclude sensitive data
- Consider using GitHub Actions for automated builds
- **Never commit tokens to git** - they're already in `.gitignore`

## 📝 Next Steps

1. ✅ Create GitHub repository
2. ✅ Push workspace to GitHub (including `.devcontainer` folder)
3. ✅ Set up GitHub token (see "GitHub Token Setup" section above)
4. ✅ Open in Codespaces
5. ✅ Wait for automatic Flutter setup (post-create script runs automatically)
6. ✅ Verify Flutter installation: `flutter doctor`
7. ✅ Test building an app: `cd 01_giggle_game/joke_generator && flutter build appbundle --release`
8. ✅ Set up sync workflow

## 🔧 DevContainer Configuration

The `.devcontainer` folder contains:
- `devcontainer.json` - Main configuration with VS Code settings
- `post-create.sh` - Script that installs Flutter and dependencies
- `.bashrc` - Flutter aliases and PATH configuration

**Note:** The first time you create a Codespace, the post-create script will:
- Download and install Flutter SDK
- Run `flutter doctor` to check setup
- Install Android build tools
- Set up the development environment

This takes about 5-10 minutes on first run, but subsequent Codespace creations will be faster.

---

**Need Help?**
- GitHub Codespaces Docs: https://docs.github.com/en/codespaces
- Flutter Docs: https://docs.flutter.dev

