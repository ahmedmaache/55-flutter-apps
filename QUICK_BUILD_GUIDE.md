# ⚡ Quick Build Guide

## 🚀 Build Flutter Apps Using GitHub Resources

### Method 1: GitHub Actions (Recommended for Automation)

**Automatic Builds:**
- Push code → Builds automatically trigger
- Go to **Actions** tab to see builds

**Manual Build:**
1. GitHub → **Actions** → **Build Flutter Apps**
2. Click **Run workflow**
3. Select developer (or "all")
4. Enter app name (or leave empty for all)
5. Click **Run workflow**

**Download AAB:**
- Actions → [Workflow run] → **Artifacts** → Download

---

### Method 2: Codespaces Terminal (Direct Build)

```bash
# Build one app
./build_in_codespaces.sh 01_giggle_game joke_generator

# Build all apps for developer
./build_in_codespaces.sh 01_giggle_game
```

---

### Method 3: Manual Build in Codespaces

```bash
cd 01_giggle_game/joke_generator
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## 📋 Developer Accounts

- `01_giggle_game` - Giggle Game
- `02_playpal_creations` - PlayPal Creations
- `03_olaf` - Olaf
- `04_good_kids` - Good Kids
- `05_apocalypse_never` - Apocalypse Never
- `06_atomizer` - Atomizer
- `07_okkyes` - Okkyes
- `08_insightful_apps` - Insightful Apps
- `09_build_deploy_labs` - Build & Deploy Labs
- `10_micho` - MIcho
- `11_playtime_programmers` - Playtime Programmers

---

## 🔍 Check Build Status

```bash
# In Codespaces
flutter doctor -v

# Check built files
ls -lh store_assets/*/*/*.aab
```

---

## 📚 Full Documentation

- [GITHUB_ACTIONS_BUILD.md](./GITHUB_ACTIONS_BUILD.md) - Complete guide
- [CODESPACES_SETUP.md](./CODESPACES_SETUP.md) - Codespaces setup

---

**💡 Tip:** Use GitHub Actions for automated builds, Codespaces for testing and development.

