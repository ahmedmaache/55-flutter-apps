# 📱 Publish Android Apps to Google Play Console - Complete Plan

## 🎯 Goal
Publish Android apps to Google Play Console (GPC) using GitHub resources for:
- ✅ Signed AAB files
- ✅ Store assets (icons, feature graphics, screenshots)
- ✅ App descriptions
- ✅ Automated publishing workflow

---

## 📋 Todo List

### Phase 1: Setup & Configuration

#### ✅ 1. GitHub Secrets Setup
- [ ] Set up Android signing secrets:
  - `KEYSTORE_PASSWORD` - Keystore password
  - `KEY_PASSWORD` - Key password
  - `KEY_ALIAS` - Key alias (usually "upload")
  - `KEYSTORE_BASE64` - Base64 encoded keystore file
- [ ] Set up Google Play Console API credentials:
  - `GPC_SERVICE_ACCOUNT_JSON` - Service account JSON (base64 encoded)
  - `GPC_PACKAGE_NAME` - App package name (per app)
  - `GPC_TRACK` - Release track (internal/alpha/beta/production)

**Location:** GitHub → Settings → Secrets and variables → Actions

---

### Phase 2: Build Signed AAB Files

#### ✅ 2. GitHub Actions Workflow for Signed AAB
- [ ] Create workflow: `.github/workflows/build-signed-aab.yml`
- [ ] Configure signing using GitHub Secrets
- [ ] Build release AAB files
- [ ] Upload AAB as artifact
- [ ] Support for multiple apps (matrix strategy)

**Status:** ✅ Already created (`build-flutter-apps.yml`)

---

### Phase 3: Generate Store Assets

#### ✅ 3. Icon Generation Workflow
- [ ] Create workflow: `.github/workflows/generate-icons.yml`
- [ ] Generate app icons (512x512px for Play Store)
- [ ] Generate adaptive icons (foreground + background)
- [ ] Use image generation API or templates
- [ ] Store icons in `store_assets/{developer}/{app}/icons/`

#### ✅ 4. Feature Graphic Generation
- [ ] Create script: `generate_feature_graphic.sh`
- [ ] Generate feature graphics (1024x500px or 1200x500px)
- [ ] Include app name and branding
- [ ] Store in `store_assets/{developer}/{app}/graphics/`

#### ✅ 5. Screenshot Generation
- [ ] Create workflow: `.github/workflows/generate-screenshots.yml`
- [ ] Generate phone screenshots (1080x1920px minimum)
  - Phone: 1080x1920px (portrait)
  - Phone: 1920x1080px (landscape)
- [ ] Generate tablet screenshots (optional)
  - Tablet: 1200x1920px (portrait)
  - Tablet: 1920x1200px (landscape)
- [ ] Create multiple screenshots (at least 2, max 8)
- [ ] Store in `store_assets/{developer}/{app}/screenshots/`

#### ✅ 6. App Description Templates
- [ ] Create template: `store_assets/templates/description_template.md`
- [ ] Generate short description (80 characters max)
- [ ] Generate full description (4000 characters max)
- [ ] Include keywords for ASO
- [ ] Store in `store_assets/{developer}/{app}/descriptions/`

---

### Phase 4: Asset Packaging

#### ✅ 7. Package Store Assets Workflow
- [ ] Create workflow: `.github/workflows/package-store-assets.yml`
- [ ] Combine AAB + icons + graphics + screenshots + descriptions
- [ ] Create ZIP package for each app
- [ ] Upload as GitHub Actions artifact
- [ ] Organize by developer and app

---

### Phase 5: Google Play Console Integration

#### ✅ 8. Google Play Console API Setup
- [ ] Create service account in Google Cloud Console
- [ ] Enable Google Play Android Developer API
- [ ] Download service account JSON
- [ ] Add to GitHub Secrets as `GPC_SERVICE_ACCOUNT_JSON`
- [ ] Link service account to Google Play Console

#### ✅ 9. Upload to GPC Workflow
- [ ] Create workflow: `.github/workflows/upload-to-gpc.yml`
- [ ] Use Google Play Console API
- [ ] Upload AAB file
- [ ] Upload store listing (description, graphics)
- [ ] Set release track (internal/alpha/beta/production)
- [ ] Handle version codes automatically

---

### Phase 6: Master Workflow

#### ✅ 10. Complete Publishing Workflow
- [ ] Create master workflow: `.github/workflows/publish-to-gpc.yml`
- [ ] Orchestrate all steps:
  1. Build signed AAB
  2. Generate store assets
  3. Package everything
  4. Upload to Google Play Console
- [ ] Support workflow dispatch with inputs:
  - Developer account
  - App name
  - Release track
  - Version code (auto-increment)

---

### Phase 7: Documentation & Scripts

#### ✅ 11. Publishing Scripts
- [ ] Create: `publish_to_gpc.sh` - Main publishing script
- [ ] Create: `generate_store_assets.sh` - Asset generation
- [ ] Create: `setup_gpc_api.sh` - GPC API setup helper

#### ✅ 12. Documentation
- [ ] Create: `GPC_PUBLISHING_GUIDE.md` - Complete guide
- [ ] Create: `STORE_ASSETS_GUIDE.md` - Asset requirements
- [ ] Create: `GPC_API_SETUP.md` - API setup instructions

---

## 🚀 Quick Start Commands

### Build Signed AAB
```bash
./build_signed_release.sh 01_giggle_game joke_generator
```

### Generate Store Assets
```bash
./generate_store_assets.sh 01_giggle_game joke_generator
```

### Publish to GPC
```bash
./publish_to_gpc.sh 01_giggle_game joke_generator production
```

---

## 📊 Workflow Overview

```
┌─────────────────────────────────────────────────────────┐
│ 1. Build Signed AAB (GitHub Actions)                  │
│    ├─ Sign with keystore (from Secrets)                │
│    └─ Upload as artifact                               │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│ 2. Generate Store Assets (GitHub Actions)              │
│    ├─ Icon (512x512px)                                  │
│    ├─ Feature Graphic (1200x500px)                     │
│    ├─ Screenshots (1080x1920px)                        │
│    └─ Descriptions (short + full)                      │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│ 3. Package Everything (GitHub Actions)                 │
│    ├─ AAB file                                          │
│    ├─ Store assets                                      │
│    └─ Upload as artifact                               │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│ 4. Upload to Google Play Console (GitHub Actions)      │
│    ├─ Upload AAB                                        │
│    ├─ Update store listing                              │
│    └─ Release to track                                  │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 File Structure

```
store_assets/
├── {developer}/
│   ├── {app}/
│   │   ├── app-release.aab              # Signed AAB
│   │   ├── icons/
│   │   │   ├── icon-512.png             # Play Store icon
│   │   │   ├── adaptive-icon-foreground.png
│   │   │   └── adaptive-icon-background.png
│   │   ├── graphics/
│   │   │   └── feature-graphic.png      # 1200x500px
│   │   ├── screenshots/
│   │   │   ├── phone-portrait-1.png    # 1080x1920px
│   │   │   ├── phone-portrait-2.png
│   │   │   └── phone-landscape-1.png   # 1920x1080px
│   │   └── descriptions/
│   │       ├── short.txt                # 80 chars max
│   │       └── full.txt                 # 4000 chars max
│   └── ...
└── templates/
    ├── description_template.md
    ├── icon_template.svg
    └── feature_graphic_template.svg
```

---

## 🔐 Required GitHub Secrets

### Android Signing
- `KEYSTORE_PASSWORD`
- `KEY_PASSWORD`
- `KEY_ALIAS`
- `KEYSTORE_BASE64`

### Google Play Console
- `GPC_SERVICE_ACCOUNT_JSON` (base64 encoded)
- `GPC_PACKAGE_NAME_{APP}` (per app, optional)
- `GPC_DEFAULT_TRACK` (internal/alpha/beta/production)

---

## 📋 Store Asset Requirements

### Icon
- **Size:** 512x512px
- **Format:** PNG
- **Requirements:** No transparency, square

### Feature Graphic
- **Size:** 1024x500px or 1200x500px
- **Format:** PNG or JPG
- **Requirements:** No text overlay (Google adds app name)

### Screenshots
- **Phone Portrait:** 1080x1920px minimum
- **Phone Landscape:** 1920x1080px minimum
- **Tablet (optional):** 1200x1920px (portrait), 1920x1200px (landscape)
- **Quantity:** 2-8 screenshots
- **Format:** PNG or JPG

### Descriptions
- **Short:** 80 characters max
- **Full:** 4000 characters max
- **Language:** English (add more later)

---

## 🎯 Implementation Priority

1. **High Priority:**
   - ✅ Build signed AAB (already done)
   - ⏳ Generate store assets
   - ⏳ Package assets with AAB

2. **Medium Priority:**
   - ⏳ Google Play Console API setup
   - ⏳ Upload to GPC workflow

3. **Low Priority:**
   - ⏳ Automated version management
   - ⏳ Multi-language support
   - ⏳ A/B testing setup

---

## ✅ Success Criteria

- [ ] Signed AAB files built automatically
- [ ] Store assets generated automatically
- [ ] One-command publishing to GPC
- [ ] All using GitHub resources (no local storage)
- [ ] Documentation complete
- [ ] At least one app published successfully

---

**Next Step:** Start implementing Phase 1 - GitHub Secrets Setup

