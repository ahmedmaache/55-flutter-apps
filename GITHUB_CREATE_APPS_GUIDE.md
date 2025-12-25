# 🚀 Creating Flutter Apps Using GitHub Resources

Complete guide on how to use GitHub resources (Actions, Codespaces, API) to create new Flutter apps automatically.

---

## 📋 Overview

GitHub provides multiple resources to create Flutter apps:

1. **GitHub Actions** - Automated app creation workflows
2. **GitHub Codespaces** - Cloud-based development environment
3. **GitHub API** - Programmatic app creation
4. **GitHub CLI** - Command-line interface

---

## 🎯 Method 1: GitHub Actions Workflow (Recommended)

### How It Works

1. **Workflow File**: `.github/workflows/create-flutter-apps.yml`
   - Runs on `workflow_dispatch` (manual trigger)
   - Uses Flutter action to set up environment
   - Creates Flutter app with specified parameters
   - Commits and pushes changes automatically

2. **Resources Used**:
   - GitHub Actions minutes (free tier: 2,000/month)
   - Ubuntu runner (2-core, 7GB RAM)
   - Flutter SDK installation
   - Git operations

### Usage

#### Via GitHub UI

1. Go to your repository: https://github.com/ahmedmaache/55-flutter-apps
2. Click **Actions** tab
3. Select **Create Flutter Apps** workflow
4. Click **Run workflow**
5. Fill in:
   - **Developer**: Select developer account (e.g., `01_giggle_game`)
   - **App name**: Enter app name (e.g., `joke_generator`)
   - **Package org**: Enter package (e.g., `org.gloven.giggle`)
   - **Create all**: Leave unchecked for single app
6. Click **Run workflow**

#### Via Script

```bash
# Create a single app
./create_app_via_github.sh 01_giggle_game joke_generator

# Or run interactively
./create_app_via_github.sh
```

### What Gets Created

- ✅ Flutter app structure
- ✅ Android/iOS/Web support
- ✅ Common dependencies (shared_preferences, provider)
- ✅ Proper package organization
- ✅ Git commit with changes

---

## 💻 Method 2: GitHub Codespaces (Interactive)

### How It Works

1. **Codespaces Environment**:
   - Pre-configured with Flutter SDK
   - Full development environment
   - Terminal access
   - VS Code interface

2. **Resources Used**:
   - Codespaces hours (free tier: 60/month)
   - Cloud machine (2-core default)
   - Storage (32GB default)

### Usage

#### Step 1: Open Codespace

1. Go to repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for environment setup (~2-3 minutes)

#### Step 2: Create App in Codespace

```bash
# Navigate to developer directory
cd 01_giggle_game

# Create Flutter app
flutter create --org org.gloven.giggle --project-name joke_generator joke_generator

# Add dependencies
cd joke_generator
flutter pub add shared_preferences provider

# Commit changes
git add .
git commit -m "Create new app: joke_generator"
git push
```

#### Step 3: Use Build Script

```bash
# Use the existing create script
./create_all_apps.sh

# Or create manually
flutter create --org org.gloven.giggle my_new_app
```

---

## 🔧 Method 3: GitHub API (Programmatic)

### How It Works

1. **API Endpoints**:
   - Trigger workflows: `POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches`
   - Check status: `GET /repos/{owner}/{repo}/actions/runs`
   - Get artifacts: `GET /repos/{owner}/{repo}/actions/artifacts`

2. **Resources Used**:
   - GitHub API rate limits (5,000 requests/hour)
   - GitHub Actions minutes
   - Same as Method 1

### Usage

```bash
# Use the provided script
./create_app_via_github.sh 01_giggle_game joke_generator

# Or use curl directly
export GITHUB_TOKEN="your_token"
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/workflows/WORKFLOW_ID/dispatches \
  -d '{
    "ref": "main",
    "inputs": {
      "developer": "01_giggle_game",
      "app_name": "joke_generator",
      "package_org": "org.gloven.giggle"
    }
  }'
```

---

## 📊 Resource Usage Breakdown

### GitHub Actions

| Resource | Free Tier | Usage per App Creation |
|----------|-----------|------------------------|
| Minutes | 2,000/month | ~2-3 minutes |
| Concurrent jobs | 20 | 1 job |
| Storage | 500MB | ~50MB per app |

### GitHub Codespaces

| Resource | Free Tier | Usage per Session |
|----------|-----------|-------------------|
| Hours | 60/month | ~0.1 hour (6 min) |
| Machine | 2-core | 1 machine |
| Storage | 32GB | ~100MB per app |

### GitHub API

| Resource | Limit | Usage per Request |
|----------|-------|-------------------|
| Requests | 5,000/hour | 1 request |
| Rate limit | 5,000/hour | Minimal |

---

## 🎯 Complete Workflow Example

### Scenario: Create 4 New Apps for Giggle Game

#### Option A: Using GitHub Actions (Automated)

```bash
# Create apps one by one
./create_app_via_github.sh 01_giggle_game joke_generator
./create_app_via_github.sh 01_giggle_game meme_maker
./create_app_via_github.sh 01_giggle_game emoji_story
./create_app_via_github.sh 01_giggle_game laugh_tracker
```

**Resources Used:**
- GitHub Actions: ~8-12 minutes
- API Requests: 4 requests
- Total time: ~10-15 minutes (parallel execution)

#### Option B: Using Codespaces (Interactive)

1. Open Codespace
2. Run:
```bash
cd 01_giggle_game
flutter create --org org.gloven.giggle joke_generator
flutter create --org org.gloven.giggle meme_maker
flutter create --org org.gloven.giggle emoji_story
flutter create --org org.gloven.giggle laugh_tracker
git add .
git commit -m "Create 4 new apps for Giggle Game"
git push
```

**Resources Used:**
- Codespaces: ~0.5 hour
- Manual time: ~10 minutes
- Total time: ~15-20 minutes

---

## 🔍 Monitoring App Creation

### Check Workflow Status

```bash
# Using script
./check_github_builds.sh

# Or via API
curl -H "Authorization: token $GITHUB_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/runs
```

### View in GitHub UI

1. Go to **Actions** tab
2. Click on **Create Flutter Apps** workflow
3. View logs and status
4. Check created files in commit

---

## 📋 Developer Account Mapping

| Developer | Directory | Package Org |
|-----------|-----------|-------------|
| Giggle Game | `01_giggle_game` | `org.gloven.giggle` |
| PlayPal Creations | `02_playpal_creations` | `org.gloven.playpal` |
| Olaf | `03_olaf` | `org.gloven.olaf` |
| Good Kids | `04_good_kids` | `org.gloven.goodkids` |
| Apocalypse Never | `05_apocalypse_never` | `org.gloven.apocalypse` |
| Atomizer | `06_atomizer` | `org.gloven.atomizer` |
| Okkyes | `07_okkyes` | `org.gloven.okkyes` |
| Insightful Apps | `08_insightful_apps` | `org.gloven.insight` |
| Build & Deploy Labs | `09_build_deploy_labs` | `org.gloven.devlabs` |
| MIcho | `10_micho` | `org.gloven.micho` |
| Playtime Programmers | `11_playtime_programmers` | `org.gloven.playcode` |

---

## 🛠️ Customization

### Add Custom Dependencies

After app creation, update the workflow or manually add:

```bash
cd <developer>/<app_name>
flutter pub add <package_name>
```

### Configure App Settings

Edit `pubspec.yaml`:
- App name
- Description
- Version
- Dependencies

### Update Build Configuration

Run signing setup:
```bash
./update_gradle_signing.sh
```

---

## ✅ Verification

### Check Created App

```bash
# List created apps
ls -la 01_giggle_game/

# Check app structure
cd 01_giggle_game/joke_generator
flutter doctor
flutter pub get
flutter analyze
```

### Verify in GitHub

1. Check repository structure
2. View commit history
3. Verify workflow run
4. Check created files

---

## 🚀 Quick Start

### Create One App

```bash
./create_app_via_github.sh 01_giggle_game joke_generator
```

### Create Multiple Apps

```bash
# Create all apps for a developer
for app in joke_generator meme_maker emoji_story laugh_tracker; do
    ./create_app_via_github.sh 01_giggle_game $app
done
```

### Create All Apps (All Developers)

Use the existing script:
```bash
./create_all_apps.sh
```

---

## 📚 Related Documentation

- [GITHUB_ACTIONS_BUILD.md](./GITHUB_ACTIONS_BUILD.md) - Building apps
- [CODESPACES_SETUP.md](./CODESPACES_SETUP.md) - Codespaces guide
- [GITHUB_RESOURCES_GUIDE.md](./GITHUB_RESOURCES_GUIDE.md) - GitHub resources

---

## 💡 Best Practices

1. **Use GitHub Actions** for automated creation
2. **Use Codespaces** for interactive development
3. **Batch operations** to save resources
4. **Monitor usage** in GitHub Settings → Billing
5. **Review created apps** before committing

---

## 🔐 Security

- ✅ Token stored securely (not in code)
- ✅ Workflows run in isolated environments
- ✅ No sensitive data in logs
- ✅ Git operations authenticated

---

**Ready to create apps?** Run: `./create_app_via_github.sh 01_giggle_game joke_generator`

