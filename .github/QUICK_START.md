# ⚡ Quick Start - GitHub Resources for GPC

## 🚀 One-Command Setup

```bash
# 1. Push workflows to GitHub
git add .github/
git commit -m "Add GitHub Actions workflows"
git push

# 2. Configure secrets (via GitHub UI)
# Repository → Settings → Secrets → Add:
#   - GPC_SERVICE_ACCOUNT_JSON
#   - GPC_PACKAGE_NAME
```

## 📋 Common Tasks

### Build All Apps
```bash
# Via GitHub UI:
# Actions → Build Flutter Apps → Run workflow
# Developer: all → Run
```

### Build Specific App
```bash
# Via GitHub UI:
# Actions → Build Flutter Apps → Run workflow
# Developer: 01_giggle_game
# App name: joke_generator
# Run
```

### Publish to GPC
```bash
# Via GitHub UI:
# Actions → Publish to Google Play Console → Run workflow
# Select app, track, release notes → Run
```

### Check Store Assets
```bash
# Via GitHub UI:
# Actions → Manage Store Assets → Run workflow
# Action: validate → Developer: all → Run
```

## 📊 Available Workflows

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| 🏗️ Build Flutter Apps | Build AAB files | Push/PR/Manual |
| 📱 Publish to GPC | Upload to Play Store | Manual |
| 📦 Manage Store Assets | Validate/Upload assets | Manual |
| 🧪 Test Flutter Apps | Run tests & analysis | Push/PR/Manual |
| 💾 Storage Optimization | Clean up storage | Weekly/Manual |
| 🤖 Automated GPC Management | GPC automation | Daily/Manual |
| ⚡ Compute Optimization | Optimize resources | Manual |

## 🎯 Resource Limits

- **Actions:** 2,000 min/month (free)
- **Codespaces:** 60 hours/month (free)
- **Artifacts:** 10GB each, 30-90 days
- **Storage:** 1GB repo (can extend)

## 📚 Full Guide

See [COMPUTE_STORAGE_GUIDE.md](./COMPUTE_STORAGE_GUIDE.md) for complete documentation.

