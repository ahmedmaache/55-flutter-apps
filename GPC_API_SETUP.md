# 🔐 Google Play Console API Setup Guide

## Overview

To automatically upload apps to Google Play Console, you need to set up the Google Play Console API.

---

## 📋 Step-by-Step Setup

### Step 1: Create Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select existing)
3. Enable **Google Play Android Developer API**:
   - Go to **APIs & Services** → **Library**
   - Search for "Google Play Android Developer API"
   - Click **Enable**

### Step 2: Create Service Account

1. Go to **IAM & Admin** → **Service Accounts**
2. Click **Create Service Account**
3. Fill in:
   - **Name:** `github-actions-gpc`
   - **Description:** `Service account for GitHub Actions to upload to GPC`
4. Click **Create and Continue**
5. Skip role assignment (not needed)
6. Click **Done**

### Step 3: Create JSON Key

1. Click on the created service account
2. Go to **Keys** tab
3. Click **Add Key** → **Create new key**
4. Select **JSON**
5. Download the JSON file
6. **Keep this file secure!**

### Step 4: Link to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console/)
2. Select your app
3. Go to **Setup** → **API access**
4. Find your service account (email format: `github-actions-gpc@PROJECT-ID.iam.gserviceaccount.com`)
5. Click **Grant access**
6. Select permissions:
   - ✅ **View app information**
   - ✅ **Manage production releases**
   - ✅ **Manage testing track releases**
7. Click **Invite user**

### Step 5: Add to GitHub Secrets

1. Go to your GitHub repository
2. **Settings** → **Secrets and variables** → **Actions**
3. Add new secret:
   - **Name:** `GPC_SERVICE_ACCOUNT_JSON`
   - **Value:** Base64 encode the JSON file:
     ```bash
     base64 -i service-account.json | pbcopy  # macOS
     base64 -w 0 service-account.json         # Linux
     ```
   - Paste the base64 string as the value

4. Add package name secret (optional, per app):
   - **Name:** `GPC_PACKAGE_NAME`
   - **Value:** Your app's package name (e.g., `org.gloven.giggle.joke_generator`)

---

## ✅ Verification

### Test API Access

```bash
# Decode and test the service account
echo "$GPC_SERVICE_ACCOUNT_JSON" | base64 -d > service-account.json

# Test with gcloud (if installed)
gcloud auth activate-service-account --key-file=service-account.json
```

---

## 🔧 Using in Workflows

The workflow automatically uses these secrets:

```yaml
env:
  GPC_SERVICE_ACCOUNT_JSON: ${{ secrets.GPC_SERVICE_ACCOUNT_JSON }}
  GPC_PACKAGE_NAME: ${{ secrets.GPC_PACKAGE_NAME }}
```

---

## 📚 Additional Resources

- [Google Play Console API Docs](https://developers.google.com/android-publisher)
- [Service Account Setup](https://developers.google.com/android-publisher/getting_started)
- [fastlane](https://docs.fastlane.tools/) - Alternative tool for GPC uploads

---

## ⚠️ Security Notes

- ✅ Never commit service account JSON to git
- ✅ Store in GitHub Secrets only
- ✅ Use base64 encoding for storage
- ✅ Rotate keys periodically
- ✅ Limit service account permissions

---

**Once set up, the publish workflow will automatically upload to Google Play Console!** 🚀

