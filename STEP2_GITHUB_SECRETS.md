# 🔐 Step 2: Set Up GitHub Secrets

## Overview

GitHub Secrets are required for:
- ✅ Signing Android AAB files
- ✅ Uploading to Google Play Console (optional)

---

## 🚀 Quick Setup

### Go to Secrets Page

**Direct Link:**
https://github.com/ahmedmaache/55-flutter-apps/settings/secrets/actions

**Or navigate:**
1. Go to: https://github.com/ahmedmaache/55-flutter-apps
2. Click **Settings**
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**

---

## 📋 Required Secrets

### 1. KEYSTORE_PASSWORD

**Name:** `KEYSTORE_PASSWORD`  
**Value:** Your keystore password

**Example:**
```
MySecurePassword123!
```

---

### 2. KEY_PASSWORD

**Name:** `KEY_PASSWORD`  
**Value:** Your key password (may be same as keystore password)

**Example:**
```
MySecurePassword123!
```

---

### 3. KEY_ALIAS

**Name:** `KEY_ALIAS`  
**Value:** Your key alias (usually "upload")

**Example:**
```
upload
```

---

### 4. KEYSTORE_BASE64

**Name:** `KEYSTORE_BASE64`  
**Value:** Base64 encoded keystore file

**How to encode:**

**Linux:**
```bash
base64 -w 0 upload-keystore.jks | pbcopy
# Or
base64 -w 0 upload-keystore.jks > keystore_base64.txt
```

**macOS:**
```bash
base64 -i upload-keystore.jks | pbcopy
```

**Windows (PowerShell):**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Set-Clipboard
```

**Then:**
1. Copy the base64 string
2. Paste as the secret value
3. Click **Add secret**

---

## 🔧 Optional: Google Play Console API

### 5. GPC_SERVICE_ACCOUNT_JSON

**Name:** `GPC_SERVICE_ACCOUNT_JSON`  
**Value:** Base64 encoded service account JSON

**Setup:**
1. Follow `GPC_API_SETUP.md` to create service account
2. Download JSON file
3. Encode to base64:
   ```bash
   base64 -w 0 service-account.json
   ```
4. Paste as secret value

---

## ✅ Verification

After adding secrets:

1. Go back to Secrets page
2. Verify all 4 required secrets are listed:
   - ✅ KEYSTORE_PASSWORD
   - ✅ KEY_PASSWORD
   - ✅ KEY_ALIAS
   - ✅ KEYSTORE_BASE64

---

## 🎯 Quick Checklist

- [ ] KEYSTORE_PASSWORD added
- [ ] KEY_PASSWORD added
- [ ] KEY_ALIAS added
- [ ] KEYSTORE_BASE64 added (base64 encoded)
- [ ] GPC_SERVICE_ACCOUNT_JSON added (optional)

---

## 🚀 Next Step

Once secrets are set up:

**Step 3:** Publish your first app
```bash
./publish_to_gpc.sh 01_giggle_game joke_generator internal
```

---

## 💡 Tips

- ✅ Secrets are encrypted and secure
- ✅ Only workflows can access secrets
- ✅ Secrets are not visible in logs
- ✅ Update secrets anytime in Settings

---

## 🔍 Troubleshooting

### Secret Not Working?
- Check secret name matches exactly (case-sensitive)
- Verify base64 encoding is correct
- Check workflow uses `${{ secrets.SECRET_NAME }}`

### Keystore Issues?
- Verify keystore file is valid
- Check passwords are correct
- Ensure keystore is not corrupted

---

**Step 2 Status:** ⏳ Set up secrets, then proceed to Step 3

**Next:** Step 3 - Publish first app

