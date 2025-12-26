# 🤖 GitHub Copilot Prompt: Build All 55 Signed AABs

Copy and paste the following prompt into **GitHub Copilot Chat** (or use it with the `@workspace` command) to have Copilot generate or execute the master build process for all your apps.

---

### 📝 The Prompt

> I have a Flutter project workspace containing 55 applications organized across 11 developer-focused directories (`01_giggle_game` through `11_playtime_programmers`). Each app is a standard Flutter project.
>
> I need to build a **signed release AAB** (Android App Bundle) for every single application in this workspace. 
>
> **Requirements:**
> 1. **Iterate** through all developer directories (01_* to 11_*) and identify every sub-directory containing a `pubspec.yaml`.
> 2. **Signing Check**: If a master keystore doesn't exist in the root, help me generate a dummy one for testing or guide me to upload my own. 
> 3. **Sync Keys**: Before building each app, ensure `key.properties` and the `.jks` file are available in the app's `android/` folder.
> 4. **Build Execution**: For each app: `flutter clean` -> `flutter pub get` -> `flutter build appbundle --release`.
> 4. **Artifact Management**: 
>    - Create a central directory `FINAL_RELEASE_AABS`.
>    - After each success, move the AAB to this folder.
>    - Rename files to: `[DevName]_[AppName]_release.aab`.
> 5. **Logging**: Maintain a `build_status_report.md` with a checklist showing which of the 55 apps succeeded and which failed.
> 6. **Resource Safety**: Process apps sequentially to avoid CPU throttling in the Codespace environment.
>
> Please generate a robust bash script named `build_master_all.sh` that implements this entire workflow.

---

### 🚀 How to use this prompt

1. **Open GitHub Copilot Chat** in your editor or browser.
2. **Paste the prompt** above.
3. **Review the script** Copilot generates.
4. **Run the script**:
   ```bash
   chmod +x build_master_all.sh
   ./build_master_all.sh
   ```

### 💡 Why this prompt works:
- **Context Awareness**: It tells Copilot exactly where the apps are.
- **Signed Builds**: Explicitly mentions symlinking the keystore, which is the most common failure point.
- **Organization**: Focuses on the final output directory.
- **Resiliency**: Ensures one failure doesn't stop the whole 55-app process.
