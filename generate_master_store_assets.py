#!/usr/bin/env python3
import os
import sys
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import colorsys

# App configurations including BOTH New and Existing Apps (Total 55)
APP_CONFIGS = {
    "01_giggle_game": {
        "funny_sound_board": {"name": "Funny Sound Board", "emoji": "🔊", "base_color": "#FF6B35"},
        "joke_generator": {"name": "Joke Generator Pro", "emoji": "😂", "base_color": "#FF6B35"},
        "meme_maker": {"name": "Meme Maker Lite", "emoji": "🎨", "base_color": "#FF6B9D"},
        "emoji_story": {"name": "Emoji Story Creator", "emoji": "📖", "base_color": "#FFB347"},
        "laugh_tracker": {"name": "Laugh Tracker", "emoji": "😄", "base_color": "#FFD700"},
    },
    "02_playpal_creations": {
        "match_3": {"name": "Match 3 Classic", "emoji": "🧩", "base_color": "#4CAF50"},
        "playpal_connect": {"name": "PlayPal Connect", "emoji": "🎮", "base_color": "#4CAF50"},
        "party_games": {"name": "Party Games Hub", "emoji": "🎉", "base_color": "#9C27B0"},
        "duo_challenges": {"name": "Duo Challenges", "emoji": "👥", "base_color": "#2196F3"},
        "word_games": {"name": "Social Word Games", "emoji": "📝", "base_color": "#FF9800"},
    },
    "03_olaf": {
        "memory_cards": {"name": "Memory Cards", "emoji": "🃏", "base_color": "#3F51B5"},
        "brain_gym": {"name": "olaf Brain Gym", "emoji": "🧠", "base_color": "#3F51B5"},
        "focus_timer": {"name": "olaf Focus Timer", "emoji": "⏱️", "base_color": "#009688"},
        "meditation": {"name": "olaf Meditation", "emoji": "🧘", "base_color": "#795548"},
        "word_puzzles": {"name": "olaf Word Games", "emoji": "🧩", "base_color": "#607D8B"},
    },
    "04_good_kids": {
        "tic_tac_toe": {"name": "Tic Tac Toe", "emoji": "❌", "base_color": "#FFC107"},
        "abc_learning": {"name": "ABC Learning Fun", "emoji": "🔤", "base_color": "#FFC107"},
        "numbers_counting": {"name": "Numbers & Counting", "emoji": "🔢", "base_color": "#E91E63"},
        "kindness_quest": {"name": "Kindness Quest", "emoji": "❤️", "base_color": "#F44336"},
        "chore_champion": {"name": "Chore Champion", "emoji": "⭐", "base_color": "#FFEB3B"},
    },
    "05_apocalypse_never": {
        "merge_puzzle": {"name": "Merge Puzzle", "emoji": "🧬", "base_color": "#4CAF50"},
        "eco_warrior": {"name": "Eco Warrior Game", "emoji": "🌱", "base_color": "#4CAF50"},
        "survival_calc": {"name": "Survival Calculator", "emoji": "🛡️", "base_color": "#9E9E9E"},
        "carbon_tracker": {"name": "Carbon Tracker", "emoji": "🌍", "base_color": "#2196F3"},
        "resource_manager": {"name": "Resource Manager Sim", "emoji": "📦", "base_color": "#795548"},
    },
    "06_atomizer": {
        "reflex_tap": {"name": "Reflex Tap", "emoji": "👆", "base_color": "#FFC107"},
        "quick_notes": {"name": "Quick Notes", "emoji": "⚡", "base_color": "#FFC107"},
        "speed_reader": {"name": "Speed Reader Pro", "emoji": "📚", "base_color": "#3F51B5"},
        "flash_math": {"name": "Flash Math", "emoji": "🔢", "base_color": "#9C27B0"},
        "micro_habits": {"name": "Micro Habits", "emoji": "✅", "base_color": "#4CAF50"},
    },
    "07_okkyes": {
        "catch_fall": {"name": "Catch Fall", "emoji": "⬇️", "base_color": "#9C27B0"},
        "affirmations": {"name": "Daily Affirmations", "emoji": "✨", "base_color": "#9C27B0"},
        "mood_ok": {"name": "Mood OK", "emoji": "😊", "base_color": "#FFC107"},
        "gratitude_journal": {"name": "Gratitude Journal", "emoji": "🙏", "base_color": "#FF9800"},
        "goal_tracker": {"name": "Goal Tracker OK", "emoji": "🎯", "base_color": "#2196F3"},
    },
    "08_insightful_apps": {
        "runner_game": {"name": "Runner", "emoji": "🏃", "base_color": "#FFC107"},
        "insight_journal": {"name": "Insight Journal", "emoji": "💡", "base_color": "#FFC107"},
        "spending_insights": {"name": "Spending Insights", "emoji": "💰", "base_color": "#4CAF50"},
        "habit_insights": {"name": "Habit Insights", "emoji": "📊", "base_color": "#2196F3"},
        "reading_tracker": {"name": "Reading Tracker", "emoji": "📖", "base_color": "#9C27B0"},
    },
    "09_build_deploy_labs": {
        "stack_blocks": {"name": "Stack Blocks", "emoji": "🏢", "base_color": "#607D8B"},
        "devlog_app": {"name": "DevLog App", "emoji": "📝", "base_color": "#607D8B"},
        "json_formatter": {"name": "JSON Formatter", "emoji": "{}", "base_color": "#3F51B5"},
        "regex_playground": {"name": "Regex Playground", "emoji": "🔍", "base_color": "#009688"},
        "git_cheatsheet": {"name": "Git Cheatsheet", "emoji": "🔧", "base_color": "#9E9E9E"},
    },
    "10_micho": {
        "startup_quiz": {"name": "Startup Quiz", "emoji": "❓", "base_color": "#FF9800"},
        "startup_ideas": {"name": "Startup Ideas Generator", "emoji": "💡", "base_color": "#FF9800"},
        "pitch_deck": {"name": "Pitch Deck Helper", "emoji": "📊", "base_color": "#2196F3"},
        "founder_daily": {"name": "Founder Daily", "emoji": "📅", "base_color": "#9C27B0"},
        "startup_glossary": {"name": "Startup Glossary", "emoji": "📚", "base_color": "#3F51B5"},
    },
    "11_playtime_programmers": {
        "swipe_avoider": {"name": "Swipe Avoider", "emoji": "↔️", "base_color": "#FF5722"},
        "code_hero": {"name": "Code Hero Adventure", "emoji": "🦸", "base_color": "#FF5722"},
        "bug_squash": {"name": "Bug Squash", "emoji": "🐛", "base_color": "#4CAF50"},
        "loop_master": {"name": "Loop Master", "emoji": "🔄", "base_color": "#2196F3"},
        "variable_valley": {"name": "Variable Valley", "emoji": "📦", "base_color": "#9C27B0"},
    },
}

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def get_gradient_color(base_color, factor=0.8):
    rgb = hex_to_rgb(base_color)
    hls = colorsys.rgb_to_hls(rgb[0]/255, rgb[1]/255, rgb[2]/255)
    new_l = max(0, min(1, hls[1] * factor))
    new_rgb = colorsys.hls_to_rgb(hls[0], new_l, hls[2])
    return tuple(int(x * 255) for x in new_rgb)

def draw_gradient(draw, rect, color1, color2):
    for i in range(rect[1], rect[3]):
        ratio = (i - rect[1]) / (rect[3] - rect[1])
        color = tuple(int(color1[j] * (1 - ratio) + color2[j] * ratio) for j in range(3))
        draw.line([(rect[0], i), (rect[2], i)], fill=color)

def get_font(size):
    paths = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"
    ]
    for p in paths:
        if os.path.exists(p):
            try:
                return ImageFont.truetype(p, size)
            except: continue
    return ImageFont.load_default()

def create_store_assets(dev_dir, app_id, config):
    # Clean developer name for directory
    clean_dev = dev_dir.split('_', 1)[1] if '_' in dev_dir else dev_dir
    base_path = f"store_assets/{clean_dev}/{app_id}"
    os.makedirs(base_path, exist_ok=True)
    
    base_color = hex_to_rgb(config["base_color"])
    dark_color = get_gradient_color(config["base_color"], 0.7)
    light_color = get_gradient_color(config["base_color"], 1.3)
    
    # 1. ICON (512x512)
    icon = Image.new('RGB', (512, 512), base_color)
    draw = ImageDraw.Draw(icon)
    draw_gradient(draw, (0, 0, 512, 512), light_color, dark_color)
    
    # Draw Emoji
    font = get_font(256)
    draw.text((256, 256), config["emoji"], fill=(255, 255, 255), anchor="mm", font=font)
    icon.save(f"{base_path}/icon.png")
    
    # 2. FEATURE GRAPHIC (1024x500)
    feature = Image.new('RGB', (1024, 500), base_color)
    draw = ImageDraw.Draw(feature)
    draw_gradient(draw, (0, 0, 1024, 500), light_color, dark_color)
    
    # Abstract patterns
    for i in range(5):
        draw.ellipse([i*200, -100, i*200+400, 300], outline=light_color, width=2)
    
    draw.text((512, 200), config["emoji"], fill=(255, 255, 255, 180), anchor="mm", font=get_font(150))
    draw.text((512, 350), config["name"], fill=(255, 255, 255), anchor="mm", font=get_font(80))
    feature.save(f"{base_path}/feature.png")
    
    # 3. SCREENSHOTS (1080x1920)
    for i in range(1, 3):
        ss = Image.new('RGB', (1080, 1920), (245, 245, 245))
        draw = ImageDraw.Draw(ss)
        
        # Header area
        draw.rectangle([0, 0, 1080, 300], fill=base_color)
        draw.text((540, 150), config["name"], fill=(255, 255, 255), anchor="mm", font=get_font(70))
        
        # Phone mockup area
        draw.rounded_rectangle([100, 400, 980, 1800], radius=50, outline=(200, 200, 200), width=10)
        
        # Content mockup
        draw.text((540, 1100), config["emoji"], fill=base_color, anchor="mm", font=get_font(300))
        
        label = "Dashboard" if i == 1 else "Features"
        draw.text((540, 1500), label, fill=(100, 100, 100), anchor="mm", font=get_font(60))
        
        ss.save(f"{base_path}/screenshot_{i}.png")

def main():
    print("🚀 Starting Master Asset Generation for ALL 55 Apps (New + Existing)...")
    total = 0
    for dev_dir, apps in APP_CONFIGS.items():
        print(f"📦 Processing Developer: {dev_dir}")
        for app_id, config in apps.items():
            print(f"  🎨 Generating assets for: {app_id}")
            create_store_assets(dev_dir, app_id, config)
            total += 1
    print(f"✅ Success! Generated assets for {total} apps in 'store_assets' directory.")

if __name__ == "__main__":
    main()
