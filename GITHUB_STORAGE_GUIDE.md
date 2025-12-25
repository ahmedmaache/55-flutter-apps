# 💾 Using GitHub Storage Resources - Complete Guide

Your local disk is full (99% used). This guide shows how to use GitHub's storage resources instead.

---

## 🎯 Overview

GitHub provides multiple storage options:

1. **GitHub Repository** - Unlimited for public repos, 1GB for private
2. **GitHub Actions Artifacts** - 10GB per artifact, 30-90 day retention
3. **Git LFS** - 1GB free, for large files
4. **GitHub Releases** - Unlimited for releases

---

## 🧹 Step 1: Clean Up Local Storage

### Run Cleanup Script

```bash
./cleanup_local_storage.sh
```

**What it does:**
- ✅ Removes Flutter build directories (`build/`)
- ✅ Cleans Flutter cache (`.dart_tool/`)
- ✅ Removes pub cache (`.pub-cache/`)
- ✅ Cleans Android/iOS build artifacts
- ✅ Removes temporary files

**Expected space freed:** ~5-10GB (depending on number of apps)

### Manual Cleanup

```bash
# Remove all build directories
find . -type d -name "build" -not -path "*/.git/*" -exec rm -rf {} +

# Clean Flutter cache
rm -rf .dart_tool .flutter-plugins* .pub-cache

# Remove Android builds
find . -type d -path "*/android/app/build" -exec rm -rf {} +

# Remove iOS builds
find . -type d -path "*/ios/build" -exec rm -rf {} +
```

---

## 📦 Step 2: Use GitHub Actions Artifacts

### Automatic Upload

When you build apps using GitHub Actions, AAB files are **automatically uploaded** as artifacts:

```bash
# Build via GitHub Actions
./build_signed_release.sh 01_giggle_game joke_generator
```

**What happens:**
1. App builds in GitHub Actions
2. AAB file created
3. Automatically uploaded as artifact
4. Available for 30-90 days
5. Download from Actions → Artifacts

### Download Artifacts

1. Go to: https://github.com/ahmedmaache/55-flutter-apps/actions
2. Click on a workflow run
3. Scroll to **Artifacts** section
4. Click **Download** on the artifact
5. Extract ZIP file

### Benefits

- ✅ **No local storage** - Files stored on GitHub
- ✅ **10GB per artifact** - Plenty of space
- ✅ **30-90 day retention** - Extended storage
- ✅ **Easy download** - When you need files

---

## 🔧 Step 3: Setup Git LFS for Large Files

### Install Git LFS

```bash
# Linux
sudo apt-get install git-lfs

# macOS
brew install git-lfs
```

### Setup Git LFS

```bash
./setup_git_lfs.sh
```

**What it does:**
- ✅ Initializes Git LFS
- ✅ Tracks `*.aab` files
- ✅ Configures `.gitattributes`
- ✅ Files stored on GitHub (not local)

### Push AAB Files to Git LFS

```bash
# Add AAB files
git add store_assets/**/*.aab
git add .gitattributes

# Commit
git commit -m "Add AAB files via Git LFS"

# Push
git push origin main
```

**Benefits:**
- ✅ 1GB free Git LFS storage
- ✅ Files on GitHub, not local disk
- ✅ Download only when needed
- ✅ Saves local space

---

## 🚀 Step 4: Build in Cloud (No Local Storage)

### Use GitHub Actions for All Builds

Instead of building locally, use GitHub Actions:

```bash
# Build signed release AAB
./build_signed_release.sh 01_giggle_game joke_generator

# Build all apps
./build_signed_release.sh all
```

**Resources:**
- ✅ Builds in cloud (no local storage)
- ✅ AAB files stored as artifacts
- ✅ No local disk usage
- ✅ Free tier: 2,000 minutes/month

### Use Codespaces for Development

```bash
# Open Codespace (cloud environment)
# All files stored on GitHub, not local
```

**Benefits:**
- ✅ 32GB cloud storage
- ✅ No local disk usage
- ✅ Access from anywhere
- ✅ Free tier: 60 hours/month

---

## 📊 Storage Comparison

### Before (Local Storage)

| Item | Size | Location |
|------|------|----------|
| Build directories | ~5GB | Local disk |
| Flutter cache | ~2GB | Local disk |
| AAB files | ~500MB | Local disk |
| **Total** | **~7.5GB** | **Local (99% full)** |

### After (GitHub Storage)

| Item | Size | Location |
|------|------|----------|
| Build directories | 0GB | Not stored (build in cloud) |
| Flutter cache | 0GB | Not stored (build in cloud) |
| AAB files | ~500MB | GitHub Actions Artifacts |
| **Total** | **~0GB local** | **GitHub (unlimited)** |

**Space freed:** ~7.5GB on local disk

---

## 🎯 Complete Workflow

### Daily Workflow

1. **Develop in Codespaces** (cloud storage)
   ```bash
   # Open Codespace
   # Edit code
   # Commit changes
   ```

2. **Build via GitHub Actions** (no local storage)
   ```bash
   ./build_signed_release.sh 01_giggle_game joke_generator
   ```

3. **Download AAB when needed** (from artifacts)
   ```bash
   # Go to Actions → Artifacts → Download
   ```

### Cleanup Workflow

1. **Weekly cleanup** (automatic via workflow)
   ```bash
   # Runs every Sunday via schedule
   # Organizes and uploads files
   ```

2. **Manual cleanup** (when needed)
   ```bash
   ./cleanup_local_storage.sh
   ```

---

## 📋 Quick Reference

### Free Up Space Now

```bash
# Run cleanup
./cleanup_local_storage.sh

# Check disk usage
df -h .
```

### Build Without Local Storage

```bash
# Build via GitHub Actions
./build_signed_release.sh 01_giggle_game joke_generator
```

### Store Large Files

```bash
# Setup Git LFS
./setup_git_lfs.sh

# Add and push AAB files
git add store_assets/**/*.aab
git commit -m "Add AAB files"
git push
```

### Download Files When Needed

1. Go to Actions → Artifacts
2. Download ZIP
3. Extract files
4. Use as needed

---

## ✅ Benefits Summary

### Local Storage (Before)
- ❌ 99% full (169G/182G)
- ❌ Can't build new apps
- ❌ Slow performance
- ❌ Limited space

### GitHub Storage (After)
- ✅ 0GB local usage (for builds)
- ✅ Unlimited cloud storage
- ✅ Fast builds in cloud
- ✅ Access from anywhere

---

## 🚀 Next Steps

1. **Run cleanup:**
   ```bash
   ./cleanup_local_storage.sh
   ```

2. **Push code to GitHub:**
   ```bash
   git add .
   git commit -m "Cleanup local storage, use GitHub storage"
   git push
   ```

3. **Build via GitHub Actions:**
   ```bash
   ./build_signed_release.sh 01_giggle_game joke_generator
   ```

4. **Download when needed:**
   - Go to Actions → Artifacts
   - Download AAB files

---

**Your local disk is now free! All builds and storage happen on GitHub.** 🎉

