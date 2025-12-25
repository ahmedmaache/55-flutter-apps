# 🔐 Signed Release AAB Build Guide

Complete guide for building signed release AAB files using GitHub resources.

## 🎯 Overview

This guide shows you how to:
1. Set up Android signing keys
2. Configure GitHub Secrets
3. Build signed release AAB files using GitHub Actions
4. Download and use the built AAB files

---

## 📋 Step 1: Set Up Signing Keys

### Option A: Create New Keystore

```bash
# Run the setup script
./setup_signing.sh

# Or manually create keystore
keytool -genkey -v -keystore android/app/upload-keystore.jks \
    -alias upload -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass YOUR_STORE_PASSWORD \
    -keypass YOUR_KEY_PASSWORD \
    -dname "CN=Your Name, OU=Mobile, O=Your Org, L=City, ST=State, C=US"
```

### Option B: Use Existing Keystore

If you already have a keystore file:
1. Place it at: `android/app/upload-keystore.jks`
2. Note down:
   - Keystore password
   - Key alias
   - Key password

---

## 🔐 Step 2: Configure GitHub Secrets

Go to your GitHub repository:
1. **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these secrets:

### Required Secrets

| Secret Name | Description | Example |
|------------|-------------|---------|
| `KEYSTORE_PASSWORD` | Your keystore password | `MyStorePass123!` |
| `KEY_PASSWORD` | Your key password | `MyKeyPass123!` |
| `KEY_ALIAS` | Your key alias | `upload` |
| `KEYSTORE_BASE64` | Base64 encoded keystore | (see below) |

### Encode Keystore to Base64

```bash
# Encode your keystore file
base64 -i android/app/upload-keystore.jks | pbcopy  # macOS
base64 -w 0 android/app/upload-keystore.jks         # Linux
cat android/app/upload-keystore.jks | base64      # Alternative

# Copy the output and paste it as KEYSTORE_BASE64 secret
```

**⚠️ Security Note:** Never commit keystore files to git. They're already in `.gitignore`.

---

## 🔧 Step 3: Update Build Configuration

### Update build.gradle.kts Files

The workflow automatically handles signing if secrets are set. However, you can update individual apps:

```bash
# Update all build.gradle.kts files
./update_gradle_signing.sh

# Or manually update each app's android/app/build.gradle.kts
```

The updated file should include:
- Keystore properties loading
- Release signing configuration
- Fallback to debug signing if keystore not found

---

## 🚀 Step 4: Build Signed Release AAB Files

### Method 1: Using Script (Recommended)

```bash
# Build specific app
./build_signed_release.sh 01_giggle_game joke_generator

# Build all apps for a developer
./build_signed_release.sh 01_giggle_game

# Build all apps (all developers)
./build_signed_release.sh all
```

### Method 2: GitHub Actions UI

1. Go to **Actions** tab
2. Select **Build Flutter Apps**
3. Click **Run workflow**
4. Select developer and app
5. Click **Run workflow**

### Method 3: Push to Trigger

```bash
git add .
git commit -m "Update app code"
git push origin main
```

Builds will trigger automatically if secrets are configured.

---

## 📦 Step 5: Download AAB Files

### Via GitHub UI

1. Go to **Actions** → Latest workflow run
2. Scroll to **Artifacts** section
3. Click **Download** on the artifact
4. Extract the ZIP file
5. Find your AAB files in the extracted folder

### Via API

```bash
# List artifacts
curl -H "Authorization: token YOUR_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/artifacts

# Download artifact (replace ARTIFACT_ID)
curl -L -H "Authorization: token YOUR_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/artifacts/ARTIFACT_ID/zip \
     -o artifact.zip
```

---

## ✅ Verification

### Check AAB File

```bash
# Verify AAB is signed (after downloading)
jarsigner -verify -verbose -certs your-app.aab

# Or use bundletool
bundletool verify --bundle=your-app.aab
```

### Check Signing Info

```bash
# Extract signing info
unzip -l your-app.aab | grep META-INF

# Should show:
# META-INF/MANIFEST.MF
# META-INF/xxxxx.SF
# META-INF/xxxxx.RSA (or .DSA)
```

---

## 🔍 Troubleshooting

### Build Fails with "Keystore not found"

**Solution:**
1. Verify GitHub Secrets are set correctly
2. Check `KEYSTORE_BASE64` is properly encoded
3. Ensure workflow has access to secrets

### Build Uses Debug Signing

**Solution:**
1. Check if secrets are set in GitHub
2. Verify keystore file is properly base64 encoded
3. Check workflow logs for signing setup step

### "Signing config not found" Error

**Solution:**
1. Run `./update_gradle_signing.sh` to update build files
2. Verify `key.properties` structure
3. Check keystore path in key.properties

### Build Succeeds but AAB Not Signed

**Solution:**
1. Check workflow logs for signing step
2. Verify secrets are accessible
3. Check if keystore was decoded correctly

---

## 📊 Build Status

### Check Build Status

```bash
# Using script
./check_github_builds.sh

# Or via API
curl -H "Authorization: token YOUR_TOKEN" \
     https://api.github.com/repos/ahmedmaache/55-flutter-apps/actions/runs
```

### Monitor Builds

- **GitHub UI**: Actions → Latest run
- **Email**: GitHub sends notifications on completion
- **Script**: `./check_github_builds.sh`

---

## 🎯 Quick Reference

### Build Commands

```bash
# Build signed release
./build_signed_release.sh <developer> [app]

# Check status
./check_github_builds.sh

# Update signing config
./update_gradle_signing.sh
```

### GitHub Secrets Checklist

- [ ] `KEYSTORE_PASSWORD` set
- [ ] `KEY_PASSWORD` set
- [ ] `KEY_ALIAS` set (usually "upload")
- [ ] `KEYSTORE_BASE64` set (base64 encoded keystore)

### Build Output

- **Location**: GitHub Actions Artifacts
- **Retention**: 30 days
- **Format**: ZIP containing AAB files
- **Path**: `store_assets/<Developer>/<App>/app-release.aab`

---

## 📚 Related Documentation

- [GITHUB_ACTIONS_BUILD.md](./GITHUB_ACTIONS_BUILD.md) - GitHub Actions guide
- [GITHUB_RESOURCES_GUIDE.md](./GITHUB_RESOURCES_GUIDE.md) - GitHub resources guide
- [CODESPACES_SETUP.md](./CODESPACES_SETUP.md) - Codespaces setup

---

## 🔐 Security Best Practices

1. ✅ **Never commit keystore files** - Already in `.gitignore`
2. ✅ **Use GitHub Secrets** - Secure storage for credentials
3. ✅ **Rotate keys regularly** - Update keystore periodically
4. ✅ **Limit secret access** - Only necessary workflows
5. ✅ **Monitor builds** - Check for unauthorized access

---

## 💡 Tips

1. **Test with debug signing first** - Verify build works
2. **Keep keystore backup** - Store securely offline
3. **Use separate keystores** - One per developer account
4. **Document passwords** - Store in secure password manager
5. **Automate builds** - Use GitHub Actions for consistency

---

**Ready to build?** Run: `./build_signed_release.sh 01_giggle_game joke_generator`

