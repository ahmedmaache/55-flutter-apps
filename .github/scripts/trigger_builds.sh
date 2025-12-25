#!/bin/bash
# Trigger GitHub Actions builds for all apps

GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
REPO="ahmedmaache/55-flutter-apps-workspace"
WORKFLOW="build-with-icons.yml"

# App configurations
declare -A APPS=(
    ["01_giggle_game"]="joke_generator meme_maker emoji_story laugh_tracker"
    ["02_playpal_creations"]="playpal_connect party_games duo_challenges word_games"
    ["03_olaf"]="brain_gym focus_timer meditation word_puzzles"
    ["04_good_kids"]="abc_learning numbers_counting kindness_quest chore_champion"
    ["05_apocalypse_never"]="eco_warrior survival_calc carbon_tracker resource_manager"
    ["06_atomizer"]="quick_notes speed_reader flash_math micro_habits"
    ["07_okkyes"]="affirmations mood_ok gratitude_journal goal_tracker"
    ["08_insightful_apps"]="insight_journal spending_insights habit_insights reading_tracker"
    ["09_build_deploy_labs"]="devlog_app json_formatter regex_playground git_cheatsheet"
    ["10_micho"]="startup_ideas pitch_deck founder_daily startup_glossary"
    ["11_playtime_programmers"]="code_hero bug_squash loop_master variable_valley"
)

trigger_build() {
    local developer=$1
    local app=$2
    local build_type=${3:-both}
    
    echo "🚀 Triggering build for: $developer/$app ($build_type)"
    
    response=$(curl -s -w "\n%{http_code}" -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/$REPO/actions/workflows/$WORKFLOW/dispatches" \
        -d "{\"ref\":\"main\",\"inputs\":{\"developer\":\"$developer\",\"app\":\"$app\",\"build_type\":\"$build_type\"}}")
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "204" ]; then
        echo "  ✅ Build triggered successfully"
        return 0
    else
        echo "  ❌ Failed (HTTP $http_code): $body"
        return 1
    fi
}

# Main execution
if [ "$1" = "all" ]; then
    echo "══════════════════════════════════════════════════════════════"
    echo "   🚀 Triggering Builds for ALL Apps"
    echo "══════════════════════════════════════════════════════════════"
    echo ""
    
    total=0
    success=0
    
    for developer in "${!APPS[@]}"; do
        echo "Developer: $developer"
        for app in ${APPS[$developer]}; do
            if trigger_build "$developer" "$app" "both"; then
                ((success++))
            fi
            ((total++))
            sleep 2  # Rate limit protection
        done
        echo ""
    done
    
    echo "══════════════════════════════════════════════════════════════"
    echo "   ✅ Triggered $success/$total builds"
    echo "══════════════════════════════════════════════════════════════"
    echo ""
    echo "📊 Check progress at:"
    echo "   https://github.com/$REPO/actions"
    
elif [ -n "$1" ] && [ -n "$2" ]; then
    # Build specific app
    trigger_build "$1" "$2" "${3:-both}"
else
    echo "Usage: $0 [developer] [app] [build_type]"
    echo "   or: $0 all"
    echo ""
    echo "Examples:"
    echo "  $0 01_giggle_game joke_generator both"
    echo "  $0 01_giggle_game joke_generator aab"
    echo "  $0 all"
fi

