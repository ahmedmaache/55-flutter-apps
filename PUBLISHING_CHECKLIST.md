# ✅ Publishing Checklist

Complete checklist for publishing Android apps to Google Play Console.

---

## 🔐 Phase 1: GitHub Secrets Setup

### Android Signing Secrets
- [ ] `KEYSTORE_PASSWORD` - Keystore password
- [ ] `KEY_PASSWORD` - Key password
- [ ] `KEY_ALIAS` - Key alias (usually "upload")
- [ ] `KEYSTORE_BASE64` - Base64 encoded keystore file

**How to set:**
1. Go to: https://github.com/ahmedmaache/55-flutter-apps/settings/secrets/actions
2. Click "New repository secret"
3. Add each secret

**How to encode keystore:**
```bash
base64 -w 0 upload-keystore.jks | pbcopy  # Linux
base64 -i upload-keystore.jks | pbcopy    # macOS
```

### Google Play Console API (Optional)
- [ ] `GPC_SERVICE_ACCOUNT_JSON` - Service account JSON (base64 encoded)
- [ ] `GPC_PACKAGE_NAME_{APP}` - Package name per app (optional)

**Setup guide:** See `GPC_API_SETUP.md`

---

## 📱 Phase 2: App Preparation

### For Each App:
- [ ] App code complete
- [ ] `pubspec.yaml` configured
- [ ] Package name matches GPC account
- [ ] Version code set
- [ ] App tested locally

---

## 🚀 Phase 3: Publishing

### Step 1: Build Signed AAB
```bash
./build_signed_release.sh <developer> <app_name>
```

**Example:**
```bash
./build_signed_release.sh 01_giggle_game joke_generator
```

**Check:**
- [ ] Workflow triggered
- [ ] AAB built successfully
- [ ] Artifact available

### Step 2: Generate Store Assets
```bash
./generate_store_assets.sh <developer> <app_name>
```

**Check:**
- [ ] Icon generated (512x512px)
- [ ] Feature graphic generated (1200x500px)
- [ ] Screenshots generated (1080x1920px)
- [ ] Descriptions created

### Step 3: Publish to GPC
```bash
./publish_to_gpc.sh <developer> <app_name> <track>
```

**Tracks:**
- `internal` - Internal testing
- `alpha` - Alpha testing
- `beta` - Beta testing
- `production` - Production release

**Example:**
```bash
./publish_to_gpc.sh 01_giggle_game joke_generator internal
```

**Check:**
- [ ] Workflow completed
- [ ] AAB uploaded to GPC
- [ ] Store listing updated
- [ ] App visible in GPC

---

## 📋 Phase 4: Verification

### In Google Play Console:
- [ ] App appears in dashboard
- [ ] AAB uploaded successfully
- [ ] Store listing complete
- [ ] Screenshots uploaded
- [ ] Description added
- [ ] App ready for review

### In GitHub Actions:
- [ ] Workflow completed successfully
- [ ] Artifacts available
- [ ] No errors in logs

---

## 🎯 Quick Publishing Commands

### Publish One App
```bash
./publish_to_gpc.sh 01_giggle_game joke_generator production
```

### Publish All Apps for Developer
```bash
for app in joke_generator meme_maker emoji_story laugh_tracker; do
    ./publish_to_gpc.sh 01_giggle_game $app internal
    sleep 10  # Wait between requests
done
```

### Build Only (No Publish)
```bash
./build_signed_release.sh 01_giggle_game joke_generator
```

### Generate Assets Only
```bash
./generate_store_assets.sh 01_giggle_game joke_generator
```

---

## 📊 Progress Tracking

### Apps Published Status

#### Giggle Game (createsuccess2026@gmail.com)
- [ ] joke_generator
- [ ] meme_maker
- [ ] emoji_story
- [ ] laugh_tracker

#### PlayPal Creations (freew2027@gmail.com)
- [ ] party_games
- [ ] story_builder
- [ ] creative_play
- [ ] fun_quiz

#### olaf (nooridzaaa@gmail.com)
- [ ] meditation
- [ ] focus_timer
- [ ] brain_gym
- [ ] wellness_tracker

#### Good kids (boulanouarmaache@gmail.com)
- [ ] abc_learning
- [ ] number_fun
- [ ] color_match
- [ ] kid_safe

#### ApocalypseNever (z19690976@gmail.com)
- [ ] eco_warrior
- [ ] carbon_tracker
- [ ] survival_calculator
- [ ] resource_manager

#### Atomizer (maache814@gmail.com)
- [ ] quick_notes
- [ ] speed_reader
- [ ] flash_math
- [ ] micro_habits

#### Okkyes (maache463@gmail.com)
- [ ] mood_ok
- [ ] gratitude_journal
- [ ] goal_tracker
- [ ] daily_affirmations

#### Insightful Apps (creatinglove2026@gmail.com)
- [ ] insight_journal
- [ ] spending_insights
- [ ] habit_insights
- [ ] reading_tracker

#### Build & Deploy Labs (createsuccess2027@gmail.com)
- [ ] devlog_app
- [ ] json_formatter
- [ ] regex_playground
- [ ] git_cheatsheet

#### MIcho (m41258970@gmail.com)
- [ ] startup_ideas
- [ ] pitch_deck
- [ ] founder_daily
- [ ] startup_glossary

#### Playtime Programmers (glovenstudent@gmail.com)
- [ ] code_hero
- [ ] bug_squash
- [ ] loop_master
- [ ] variable_valley

**Total: 44 apps to publish**

---

## 🔍 Troubleshooting

### Build Fails
- Check GitHub Secrets are set
- Verify keystore is correctly encoded
- Check workflow logs for errors

### Assets Not Generated
- Verify Python dependencies in workflow
- Check image generation logs
- Ensure app name is valid

### GPC Upload Fails
- Verify GPC API credentials
- Check service account permissions
- Ensure package name matches GPC

### Workflow Not Found
- Push workflows to GitHub first
- Verify workflow file exists
- Check workflow name matches

---

## ✅ Success Criteria

- [ ] At least 1 app published successfully
- [ ] All workflows working
- [ ] GitHub Secrets configured
- [ ] GPC API working (if enabled)
- [ ] Documentation complete

---

**Start publishing:** `./publish_to_gpc.sh 01_giggle_game joke_generator internal`

