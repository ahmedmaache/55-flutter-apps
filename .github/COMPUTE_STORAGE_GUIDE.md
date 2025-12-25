# 🚀 Using All GitHub Resources for GPC Management

This comprehensive guide shows you how to leverage **all GitHub resources** (compute, storage, and Actions) to manage your Google Play Console (GPC) apps.

## 📊 Available GitHub Resources

### ✅ GitHub Actions (Compute)
- **Free tier:** 2,000 minutes/month
- **Parallel builds:** Up to 20 concurrent jobs
- **Matrix strategy:** Build multiple apps simultaneously
- **Caching:** Speed up builds with dependency caching

### ✅ GitHub Storage
- **Artifacts:** 10GB per artifact, 30-90 days retention
- **Releases:** Unlimited storage for releases
- **Git LFS:** For large binary files
- **Repository storage:** 1GB free, can be extended

### ✅ GitHub Codespaces
- **Free tier:** 60 hours/month
- **Machine types:** 2-core, 4-core, 8-core, 16-core
- **Storage:** 32GB default (can be increased)
- **Auto-setup:** Via `.devcontainer`

---

## 🎯 Workflow Overview

### 1. 🏗️ Build Flutter Apps (`build-flutter-apps.yml`)

**Purpose:** Automatically build all Flutter apps using GitHub Actions compute resources.

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests
- Manual workflow dispatch

**Features:**
- ✅ Parallel builds using matrix strategy
- ✅ Automatic artifact upload
- ✅ Release creation with AAB files
- ✅ Store assets management

**Usage:**
```bash
# Via GitHub UI:
# Actions → Build Flutter Apps → Run workflow
# Select developer and app, then Run

# Via API:
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/YOUR_USERNAME/55-flutter-apps/actions/workflows/build-flutter-apps.yml/dispatches \
  -d '{"ref":"main","inputs":{"developer":"01_giggle_game","app_name":"joke_generator"}}'
```

### 2. 📱 Publish to GPC (`publish-to-gpc.yml`)

**Purpose:** Automatically publish AAB files to Google Play Console.

**Triggers:**
- Manual workflow dispatch only (for safety)

**Required Secrets:**
- `GPC_SERVICE_ACCOUNT_JSON` - Google Play service account JSON
- `GPC_PACKAGE_NAME` - Your app's package name

**Usage:**
```bash
# Via GitHub UI:
# Actions → Publish to Google Play Console → Run workflow
# Select developer, app, track, and release notes
```

### 3. 📦 Manage Store Assets (`manage-store-assets.yml`)

**Purpose:** Validate, generate, upload, and sync store assets.

**Actions:**
- `validate` - Check all required store assets
- `generate` - Generate missing assets
- `upload` - Upload to GitHub Releases
- `sync` - Sync assets to repository

**Usage:**
```bash
# Validate assets
# Actions → Manage Store Assets → Run workflow
# Select action: validate, developer: all
```

### 4. 🧪 Test Flutter Apps (`test-flutter-apps.yml`)

**Purpose:** Run automated tests and code analysis.

**Features:**
- Code analysis with `flutter analyze`
- Unit tests
- Test coverage reports

**Usage:**
```bash
# Automatic on push/PR
# Or manual: Actions → Test Flutter Apps → Run workflow
```

### 5. 💾 Storage Optimization (`storage-optimization.yml`)

**Purpose:** Optimize GitHub storage usage.

**Features:**
- Weekly cleanup of old artifacts
- Storage usage reports
- Git LFS optimization

**Schedule:** Runs weekly on Sundays at 2 AM UTC

### 6. 🤖 Automated GPC Management (`automated-gpc-management.yml`)

**Purpose:** Automate Google Play Console operations.

**Actions:**
- `check-updates` - Check for GPC updates
- `sync-listings` - Sync store listings
- `update-metadata` - Update app metadata
- `generate-reports` - Generate GPC reports

**Schedule:** Runs daily at 3 AM UTC

### 7. ⚡ Compute Optimization (`compute-optimization.yml`)

**Purpose:** Optimize GitHub Actions compute usage.

**Optimizations:**
- `cache` - Optimize caching strategies
- `parallel` - Optimize parallel builds
- `resources` - Resource usage analysis
- `all` - All optimizations

---

## 🔧 Setup Instructions

### Step 1: Configure GitHub Secrets

Go to your repository → Settings → Secrets and variables → Actions

Add these secrets:

1. **GPC_SERVICE_ACCOUNT_JSON**
   ```json
   {
     "type": "service_account",
     "project_id": "your-project",
     ...
   }
   ```

2. **GPC_PACKAGE_NAME**
   ```
   org.gloven.giggle.joke_generator
   ```

3. **GITHUB_TOKEN** (automatically available)

### Step 2: Enable GitHub Actions

1. Go to repository Settings
2. Click Actions → General
3. Enable "Allow all actions and reusable workflows"

### Step 3: Push Workflows

```bash
git add .github/workflows/
git commit -m "Add GitHub Actions workflows for GPC management"
git push
```

---

## 📈 Resource Usage Optimization

### Compute Optimization

1. **Use Matrix Strategy**
   - Builds multiple apps in parallel
   - Reduces total build time
   - Maximizes GitHub Actions minutes

2. **Enable Caching**
   - Flutter dependencies cached
   - Gradle cache enabled
   - Pub cache enabled
   - Reduces build time by 50-70%

3. **Parallel Jobs**
   - Use `max-parallel` in matrix strategy
   - Build up to 20 apps simultaneously
   - Free tier: 20 concurrent jobs

### Storage Optimization

1. **Artifact Retention**
   - Set retention to 30-90 days
   - Download important artifacts
   - Use GitHub Releases for long-term storage

2. **Git LFS for Large Files**
   ```bash
   git lfs track "*.aab"
   git lfs track "store_assets/**/*.aab"
   ```

3. **Release Storage**
   - Upload AAB files to Releases
   - Unlimited storage for releases
   - Better organization

4. **Cleanup Strategy**
   - Weekly cleanup of old artifacts
   - Archive old releases
   - Monitor storage usage

---

## 🎯 Complete Workflow Example

### Building and Publishing an App

1. **Develop in Codespaces**
   ```bash
   # Open Codespace
   # Make changes
   git add .
   git commit -m "Update app"
   git push
   ```

2. **Automatic Build**
   - GitHub Actions automatically builds on push
   - AAB file uploaded as artifact
   - Release created with AAB

3. **Publish to GPC**
   ```bash
   # Via GitHub UI:
   # Actions → Publish to Google Play Console
   # Select app, track, and release notes
   ```

4. **Monitor**
   - Check Actions tab for build status
   - Download artifacts if needed
   - View GPC reports

---

## 📊 Monitoring Resources

### GitHub Actions Usage

1. Go to repository Settings → Actions → Usage
2. View:
   - Minutes used this month
   - Storage used
   - Artifact storage

### Codespaces Usage

1. Go to GitHub Settings → Codespaces
2. View:
   - Hours used this month
   - Storage used
   - Active codespaces

### Storage Usage

1. Go to repository Settings → General
2. View repository size
3. Check large files with:
   ```bash
   find . -type f -size +10M -not -path "./.git/*"
   ```

---

## 🔐 Security Best Practices

1. **Never commit secrets**
   - Use GitHub Secrets for all sensitive data
   - Store service account JSON in Secrets
   - Use environment variables in workflows

2. **Protect main branch**
   - Require PR reviews
   - Require status checks
   - Prevent force pushes

3. **Limit workflow permissions**
   - Use least privilege principle
   - Review workflow permissions
   - Audit workflow access

---

## 💡 Tips and Tricks

1. **Build Only Changed Apps**
   - Use path filters in workflows
   - Only build apps with changes
   - Save compute minutes

2. **Use Conditional Builds**
   - Skip builds for documentation changes
   - Build only on specific branches
   - Use workflow conditions

3. **Optimize Build Times**
   - Enable all caches
   - Use incremental builds
   - Parallelize where possible

4. **Storage Management**
   - Use Releases for important builds
   - Clean up old artifacts regularly
   - Use Git LFS for large binaries

---

## 📚 Related Documentation

- [GITHUB_ACTIONS_BUILD.md](./GITHUB_ACTIONS_BUILD.md) - Detailed build guide
- [GITHUB_RESOURCES_GUIDE.md](./GITHUB_RESOURCES_GUIDE.md) - Resource usage guide
- [CODESPACES_SETUP.md](./CODESPACES_SETUP.md) - Codespaces setup
- [GPC_API_SETUP.md](./GPC_API_SETUP.md) - Google Play Console API setup

---

## 🆘 Troubleshooting

### Build Failures

1. Check workflow logs
2. Verify Flutter version
3. Check dependencies
4. Review error messages

### Storage Issues

1. Clean up old artifacts
2. Use Git LFS for large files
3. Archive to Releases
4. Monitor storage usage

### Compute Limits

1. Optimize parallel builds
2. Use caching effectively
3. Build only changed apps
4. Consider upgrading plan

---

**Last Updated:** December 2024  
**Maintained by:** Maache Ahmed, Startup Coach at Global Ventures

