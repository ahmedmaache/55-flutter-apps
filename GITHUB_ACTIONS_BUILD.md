# 🚀 Building Flutter Apps with GitHub Actions & Codespaces

This guide explains how to use GitHub Actions and Codespaces resources to build your Flutter apps automatically.

## 📋 Overview

You have **three ways** to build Flutter apps using GitHub resources:

1. **GitHub Actions Workflows** - Automated builds on push/PR or manual triggers
2. **Codespaces Terminal** - Build directly in Codespaces using scripts
3. **Manual Workflow Dispatch** - Trigger builds from GitHub UI

---

## 🔧 Method 1: GitHub Actions (Automated)

### Automatic Builds

The workflow `build-flutter-apps.yml` automatically builds apps when:
- You push code to `main` or `develop` branches
- You create a pull request
- You manually trigger it from the Actions tab

### Manual Trigger

1. Go to your repository on GitHub
2. Click **Actions** tab
3. Select **Build Flutter Apps** workflow
4. Click **Run workflow**
5. Choose:
   - **Developer**: Select a developer account or "all"
   - **App name**: Leave empty to build all apps, or specify one app
6. Click **Run workflow**

### Build Matrix

The workflow builds all apps in parallel using a build matrix:
- Each developer account is built in parallel
- All apps for each developer are built sequentially
- Failed builds don't stop other builds

### Artifacts

Built AAB files are uploaded as artifacts:
- Available for 30 days
- Downloadable from the Actions run page
- Organized by developer account

---

## 💻 Method 2: Build in Codespaces (Direct)

### Using the Build Script

When you're in a Codespace, you can build apps directly:

```bash
# Build a specific app
./build_in_codespaces.sh 01_giggle_game joke_generator

# Build all apps for a developer
./build_in_codespaces.sh 01_giggle_game
```

### Manual Build Steps

```bash
# Navigate to app directory
cd 01_giggle_game/joke_generator

# Clean and get dependencies
flutter clean
flutter pub get

# Build AAB
flutter build appbundle --release

# Check output
ls -lh build/app/outputs/bundle/release/app-release.aab
```

### Using GitHub Token

If you need to push built files or access private repos:

```bash
# Set up token (if not already done)
export GITHUB_TOKEN="your_token_here"

# Or use the setup script
./setup_codespaces_token.sh
```

---

## 🎯 Method 3: Workflow Dispatch (Single App)

For building a single app quickly:

1. Go to **Actions** → **Build in Codespaces**
2. Click **Run workflow**
3. Enter:
   - **Developer**: e.g., `01_giggle_game`
   - **App name**: e.g., `joke_generator`
4. Click **Run workflow**

---

## 📊 Build Resources

### GitHub Actions Runners

- **OS**: Ubuntu Latest
- **Java**: 17 (Microsoft distribution)
- **Flutter**: 3.24.0 (stable)
- **Caching**: Enabled for faster builds
- **Parallel builds**: Yes (matrix strategy)

### Codespaces Resources

- **Free tier**: 60 hours/month, 2-core machine
- **Upgrade options**: 4-core, 8-core available
- **Storage**: 32GB default
- **Build time**: ~5-10 minutes per app

---

## 🔍 Monitoring Builds

### View Build Status

1. Go to **Actions** tab
2. Click on a workflow run
3. View logs for each job
4. Download artifacts when complete

### Build Summary

Each build includes:
- ✅ Success/failure status
- 📦 AAB file artifacts
- 📊 Build summary with file sizes
- ⚠️ Warnings and errors

---

## 🛠️ Troubleshooting

### Build Failures

**Common issues:**

1. **Missing dependencies**
   ```bash
   flutter pub get
   flutter doctor
   ```

2. **Android licenses not accepted**
   ```bash
   yes | flutter doctor --android-licenses
   ```

3. **Java version mismatch**
   - Ensure Java 17 is installed
   - Check `java -version`

4. **Out of memory**
   - Use larger Codespaces machine
   - Build apps one at a time

### Debugging

```bash
# Check Flutter installation
flutter doctor -v

# Check app dependencies
cd <app_directory>
flutter pub get
flutter analyze

# Test build locally first
flutter build appbundle --debug
```

---

## 📝 Best Practices

1. **Test locally first** - Build in Codespaces before pushing
2. **Use caching** - GitHub Actions caches Flutter dependencies
3. **Build incrementally** - Build one developer at a time for large batches
4. **Monitor resources** - Check Codespaces usage in settings
5. **Clean builds** - Use `flutter clean` before important builds

---

## 🎯 Quick Reference

### Build All Apps for a Developer
```bash
./build_in_codespaces.sh 01_giggle_game
```

### Build Specific App
```bash
./build_in_codespaces.sh 01_giggle_game joke_generator
```

### Trigger GitHub Actions Build
1. Actions → Build Flutter Apps → Run workflow
2. Select developer → Run

### Download Built AAB
1. Actions → [Workflow run] → Artifacts
2. Download the AAB file

---

## 📚 Related Documentation

- [CODESPACES_SETUP.md](./CODESPACES_SETUP.md) - Codespaces setup guide
- [README.md](./README.md) - Project overview
- [55_FLUTTER_APPS_MASTER_PLAN.md](./55_FLUTTER_APPS_MASTER_PLAN.md) - App list

---

## 🔐 Security Notes

- ✅ GitHub token stored in Secrets (not in code)
- ✅ AAB files uploaded as artifacts (secure)
- ✅ Build logs are private to repository
- ⚠️ Never commit signing keys or secrets

---

**Need Help?**
- GitHub Actions Docs: https://docs.github.com/en/actions
- Flutter Build Docs: https://docs.flutter.dev/deployment/android

