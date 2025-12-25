# 🔐 GitHub Token Setup Guide

Your GitHub personal access token has been configured for secure use with this workspace.

## ✅ What's Been Set Up

1. **`.gitignore` updated** - Token files are now ignored
2. **Setup script created** - `setup_github_token.sh` for easy configuration
3. **Security patterns added** - Prevents accidental token commits

## 🚀 Quick Setup

### Option 1: Use the Setup Script (Recommended)

```bash
./setup_github_token.sh
```

This will:
- Configure git credential helper
- Set up remote URL with token authentication
- Configure GitHub CLI (if installed)
- Add token to environment variables

### Option 2: Manual Setup

#### For Git Operations

```bash
# Set up credential helper
git config --global credential.helper store

# Add remote with token (replace YOUR_USERNAME and YOUR_REPO)
git remote add origin https://YOUR_GITHUB_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git

# Or update existing remote
git remote set-url origin https://YOUR_GITHUB_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git
```

#### For GitHub CLI

```bash
echo "YOUR_GITHUB_TOKEN" | gh auth login --with-token
```

#### For Environment Variables

```bash
export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
echo 'export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"' >> ~/.bashrc
```

## 📋 First-Time Repository Setup

If you haven't created your GitHub repository yet:

1. **Create Repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `55-flutter-apps` (or your preferred name)
   - Description: "55 Flutter Apps - Multi-Environment Workspace"
   - Choose Public or Private
   - **Don't** initialize with README (we already have files)

2. **Initialize and Push:**
   ```bash
   # Initialize git (if not already done)
   git init
   
   # Add all files
   git add .
   
   # Commit
   git commit -m "Initial commit: 55 Flutter Apps workspace with Codespaces setup"
   
   # Add remote (replace YOUR_USERNAME and YOUR_REPO)
   git remote add origin https://YOUR_GITHUB_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git
   
   # Push to GitHub
   git branch -M main
   git push -u origin main
   ```

## 🔒 Security Best Practices

### ✅ DO:
- ✅ Use the token in git remote URLs (it's stored securely)
- ✅ Use GitHub CLI for authentication
- ✅ Store token in environment variables (not in code)
- ✅ Use the setup script provided
- ✅ Rotate token if compromised

### ❌ DON'T:
- ❌ Commit token to git (already in `.gitignore`)
- ❌ Share token publicly
- ❌ Hardcode token in source files
- ❌ Include token in screenshots or documentation

## 🔄 Using Token in Different Environments

### Local PC
```bash
./setup_github_token.sh
```

### Remote PC (192.168.1.24)
```bash
sshpass -p '1234' ssh maache@192.168.1.24 "cd ~/55_flutterapps && ./setup_github_token.sh"
```

### GitHub Codespaces
The token will be available via environment variable `GITHUB_TOKEN` if you set it in GitHub Secrets:
1. Go to your repository → Settings → Secrets and variables → Actions
2. Add new secret: `GITHUB_TOKEN` with your token value
3. Codespaces can access it via `$GITHUB_TOKEN`

## 🧪 Test Your Setup

```bash
# Test git authentication
git ls-remote origin

# Test GitHub CLI (if installed)
gh auth status

# Test environment variable
echo $GITHUB_TOKEN
```

## 🔄 Token Rotation

If you need to rotate your token:

1. **Generate new token:**
   - Go to https://github.com/settings/tokens
   - Generate new token with same permissions
   - Revoke old token

2. **Update configuration:**
   ```bash
   # Update remote URL
   git remote set-url origin https://NEW_TOKEN@github.com/YOUR_USERNAME/YOUR_REPO.git
   
   # Update environment variable
   export GITHUB_TOKEN="NEW_TOKEN"
   ```

## 📝 Token Permissions

Your token should have these permissions:
- ✅ `repo` - Full control of private repositories
- ✅ `workflow` - Update GitHub Action workflows (if using Actions)
- ✅ `codespace` - Create and manage Codespaces

## 🆘 Troubleshooting

### "Authentication failed"
- Check token is correct
- Verify token hasn't expired
- Ensure token has correct permissions

### "Permission denied"
- Token might not have `repo` scope
- Repository might be private and token lacks access

### "Remote not found"
- Check repository name is correct
- Verify you have access to the repository

---

**Token:** `YOUR_GITHUB_TOKEN`  
**Status:** ✅ Configured and ready to use  
**Security:** ✅ Protected in `.gitignore`

