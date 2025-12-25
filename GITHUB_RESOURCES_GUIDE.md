# 🔧 Using GitHub Resources Guide

This guide shows you how to use your GitHub token and resources to build Flutter apps.

## 🎯 Available Scripts

### 1. `use_github_resources.sh`
Check your GitHub account and repository status.

```bash
./use_github_resources.sh
```

**What it does:**
- ✅ Verifies your GitHub token
- ✅ Lists your repositories
- ✅ Checks if repository exists
- ✅ Verifies GitHub Actions is enabled
- ✅ Shows recent workflow runs

### 2. `trigger_github_build.sh`
Trigger GitHub Actions builds via API.

```bash
# Build all apps for a developer
./trigger_github_build.sh 01_giggle_game

# Build specific app
./trigger_github_build.sh 01_giggle_game joke_generator

# Build all apps (all developers)
./trigger_github_build.sh all
```

**What it does:**
- ✅ Finds your workflow
- ✅ Triggers build via GitHub API
- ✅ Provides build status URL

### 3. `check_github_builds.sh`
Check the status of your GitHub Actions builds.

```bash
./check_github_builds.sh
```

**What it does:**
- ✅ Lists recent workflow runs
- ✅ Shows build status and conclusions
- ✅ Lists available artifacts
- ✅ Provides direct links to builds

---

## 🚀 Quick Start

### Step 1: Verify GitHub Connection

```bash
export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
./use_github_resources.sh
```

### Step 2: Push Your Code to GitHub

```bash
# Initialize git (if not done)
git init
git add .
git commit -m "Add Flutter apps and GitHub Actions workflows"

# Add remote (replace with your repo URL)
git remote add origin https://YOUR_GITHUB_TOKEN@github.com/ahmedmaache/55-flutter-apps.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 3: Trigger a Build

```bash
# Build all Giggle Game apps
./trigger_github_build.sh 01_giggle_game

# Or build specific app
./trigger_github_build.sh 01_giggle_game joke_generator
```

### Step 4: Check Build Status

```bash
./check_github_builds.sh
```

Or visit: https://github.com/ahmedmaache/55-flutter-apps/actions

---

## 📊 GitHub Resources Available

### ✅ GitHub Actions
- **Free tier**: 2,000 minutes/month
- **Parallel builds**: Yes (matrix strategy)
- **Artifact storage**: 30 days
- **Build logs**: Full logs available

### ✅ GitHub Codespaces
- **Free tier**: 60 hours/month
- **Machine types**: 2-core, 4-core, 8-core
- **Storage**: 32GB default
- **Auto-setup**: Via `.devcontainer`

### ✅ Artifacts
- **Retention**: 30 days
- **Download**: Via GitHub UI or API
- **Size limit**: 10GB per artifact

---

## 🔍 Monitoring Builds

### Via Scripts

```bash
# Check status
./check_github_builds.sh

# Trigger new build
./trigger_github_build.sh 01_giggle_game
```

### Via GitHub UI

1. Go to: https://github.com/ahmedmaache/55-flutter-apps/actions
2. Click on a workflow run
3. View logs and download artifacts

### Via API

```bash
# Get recent runs
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/runs

# Get artifacts
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/artifacts
```

---

## 🎯 Workflow Options

### Option 1: Automatic Builds
- Push code → Builds trigger automatically
- No manual intervention needed

### Option 2: Manual Trigger (GitHub UI)
1. Actions → Build Flutter Apps
2. Run workflow → Select options
3. Run

### Option 3: Manual Trigger (API/Script)
```bash
./trigger_github_build.sh 01_giggle_game joke_generator
```

### Option 4: Build in Codespaces
```bash
./build_in_codespaces.sh 01_giggle_game joke_generator
```

---

## 📦 Downloading Artifacts

### Via GitHub UI
1. Go to Actions → [Workflow run]
2. Scroll to Artifacts section
3. Click Download

### Via API
```bash
# List artifacts
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/artifacts

# Download artifact (requires artifact ID)
curl -L -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/artifacts/ARTIFACT_ID/zip \
     -o artifact.zip
```

---

## 🔐 Security

- ✅ Token stored in environment variable
- ✅ Token in `.gitignore` (won't be committed)
- ✅ Use GitHub Secrets for production
- ⚠️ Never commit tokens to git

---

## 💡 Tips

1. **Use GitHub Actions** for automated builds
2. **Use Codespaces** for development and testing
3. **Monitor usage** in GitHub Settings → Billing
4. **Download artifacts** within 30 days
5. **Use matrix builds** for parallel processing

---

## 📚 Related Documentation

- [GITHUB_ACTIONS_BUILD.md](./GITHUB_ACTIONS_BUILD.md) - Full GitHub Actions guide
- [CODESPACES_SETUP.md](./CODESPACES_SETUP.md) - Codespaces setup
- [QUICK_BUILD_GUIDE.md](./QUICK_BUILD_GUIDE.md) - Quick reference

---

**Your GitHub Account:** ahmedmaache  
**Repository:** 55-flutter-apps  
**Token:** Configured ✅

