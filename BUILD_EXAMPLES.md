# 🎯 Build Examples - Codespaces

## Quick Examples

### Build a Single App

```bash
# Build joke_generator from Giggle Game
./build_in_codespaces.sh 01_giggle_game joke_generator

# Build meditation app from Olaf
./build_in_codespaces.sh 03_olaf meditation

# Build devlog_app from Build & Deploy Labs
./build_in_codespaces.sh 09_build_deploy_labs devlog_app
```

### Build All Apps for a Developer

```bash
# Build all Giggle Game apps
./build_in_codespaces.sh 01_giggle_game

# Build all Olaf apps
./build_in_codespaces.sh 03_olaf

# Build all Build & Deploy Labs apps
./build_in_codespaces.sh 09_build_deploy_labs
```

## Available Apps by Developer

### 01_giggle_game
- `joke_generator`
- `meme_maker`
- `emoji_story`
- `laugh_tracker`

### 02_playpal_creations
- `party_games`
- `story_builder`
- `creative_play`
- `fun_quiz`

### 03_olaf
- `meditation`
- `focus_timer`
- `brain_gym`
- `wellness_tracker`

### 04_good_kids
- `abc_learning`
- `number_fun`
- `color_match`
- `kid_safe`

### 05_apocalypse_never
- `eco_warrior`
- `carbon_tracker`
- `survival_calculator`
- `resource_manager`

### 06_atomizer
- `quick_notes`
- `speed_reader`
- `flash_math`
- `micro_habits`

### 07_okkyes
- `mood_ok`
- `gratitude_journal`
- `goal_tracker`
- `daily_affirmations`

### 08_insightful_apps
- `insight_journal`
- `spending_insights`
- `habit_insights`
- `reading_tracker`

### 09_build_deploy_labs
- `devlog_app`
- `json_formatter`
- `regex_playground`
- `git_cheatsheet`

### 10_micho
- `startup_ideas`
- `pitch_deck`
- `founder_daily`
- `startup_glossary`

### 11_playtime_programmers
- `code_hero`
- `bug_squash`
- `loop_master`
- `variable_valley`

## Build Output Location

Built AAB files are saved to:
```
store_assets/<Developer Name>/<App Name>/app-release.aab
```

Example:
```
store_assets/Giggle Game/joke_generator/app-release.aab
```

## Check Build Results

```bash
# List all built AAB files
find store_assets -name "*.aab" -exec ls -lh {} \;

# Check specific developer
ls -lh store_assets/Giggle\ Game/*/

# Get file sizes
du -sh store_assets/*/
```

## Build Time Estimates

- **Single app**: ~3-5 minutes
- **All apps for one developer**: ~15-20 minutes
- **All apps (all developers)**: Use GitHub Actions instead

## Tips

1. **Build one at a time** for testing
2. **Use GitHub Actions** for building all apps
3. **Check Flutter doctor** before building: `flutter doctor`
4. **Clean builds** if issues: `flutter clean` in app directory

## Troubleshooting

### Build Fails
```bash
cd <app_directory>
flutter clean
flutter pub get
flutter doctor
flutter build appbundle --release
```

### Out of Space
```bash
# Clean Flutter cache
flutter clean
flutter pub cache repair

# Remove old builds
find . -name "build" -type d -exec rm -rf {} + 2>/dev/null
```

### Dependencies Issue
```bash
cd <app_directory>
flutter pub get
flutter pub upgrade
```

