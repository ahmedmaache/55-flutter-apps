#!/usr/bin/env python3
"""
Simplified icon generation - creates colored square icons with text
Works reliably in GitHub Actions without emoji font dependencies
"""

import os
import sys

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("ERROR: PIL (Pillow) is not installed.")
    print("Install with: pip install Pillow")
    sys.exit(1)

# App icon configurations
APP_ICONS = {
    "01_giggle_game": {
        "joke_generator": {"emoji": "J", "color": (255, 107, 53), "name": "Joke"},
        "meme_maker": {"emoji": "M", "color": (255, 107, 157), "name": "Meme"},
        "emoji_story": {"emoji": "E", "color": (255, 179, 71), "name": "Story"},
        "laugh_tracker": {"emoji": "L", "color": (255, 215, 0), "name": "Laugh"},
    },
    "02_playpal_creations": {
        "playpal_connect": {"emoji": "P", "color": (76, 175, 80), "name": "PlayPal"},
        "party_games": {"emoji": "P", "color": (156, 39, 176), "name": "Party"},
        "duo_challenges": {"emoji": "D", "color": (33, 150, 243), "name": "Duo"},
        "word_games": {"emoji": "W", "color": (255, 152, 0), "name": "Words"},
    },
    "03_olaf": {
        "brain_gym": {"emoji": "B", "color": (63, 81, 181), "name": "Brain"},
        "focus_timer": {"emoji": "F", "color": (0, 150, 136), "name": "Focus"},
        "meditation": {"emoji": "M", "color": (121, 85, 72), "name": "Meditate"},
        "word_puzzles": {"emoji": "P", "color": (96, 125, 139), "name": "Puzzle"},
    },
    "04_good_kids": {
        "abc_learning": {"emoji": "ABC", "color": (255, 193, 7), "name": "ABC"},
        "numbers_counting": {"emoji": "123", "color": (233, 30, 99), "name": "Numbers"},
        "kindness_quest": {"emoji": "K", "color": (244, 67, 54), "name": "Kindness"},
        "chore_champion": {"emoji": "C", "color": (255, 235, 59), "name": "Chore"},
    },
    "05_apocalypse_never": {
        "eco_warrior": {"emoji": "E", "color": (76, 175, 80), "name": "Eco"},
        "survival_calc": {"emoji": "S", "color": (158, 158, 158), "name": "Survival"},
        "carbon_tracker": {"emoji": "C", "color": (33, 150, 243), "name": "Carbon"},
        "resource_manager": {"emoji": "R", "color": (121, 85, 72), "name": "Resource"},
    },
    "06_atomizer": {
        "quick_notes": {"emoji": "Q", "color": (255, 193, 7), "name": "Notes"},
        "speed_reader": {"emoji": "S", "color": (63, 81, 181), "name": "Reader"},
        "flash_math": {"emoji": "M", "color": (156, 39, 176), "name": "Math"},
        "micro_habits": {"emoji": "H", "color": (76, 175, 80), "name": "Habits"},
    },
    "07_okkyes": {
        "affirmations": {"emoji": "A", "color": (156, 39, 176), "name": "Affirm"},
        "mood_ok": {"emoji": "M", "color": (255, 193, 7), "name": "Mood"},
        "gratitude_journal": {"emoji": "G", "color": (255, 152, 0), "name": "Gratitude"},
        "goal_tracker": {"emoji": "G", "color": (33, 150, 243), "name": "Goals"},
    },
    "08_insightful_apps": {
        "insight_journal": {"emoji": "I", "color": (255, 193, 7), "name": "Insight"},
        "spending_insights": {"emoji": "$", "color": (76, 175, 80), "name": "Spending"},
        "habit_insights": {"emoji": "H", "color": (33, 150, 243), "name": "Habits"},
        "reading_tracker": {"emoji": "R", "color": (156, 39, 176), "name": "Reading"},
    },
    "09_build_deploy_labs": {
        "devlog_app": {"emoji": "D", "color": (96, 125, 139), "name": "DevLog"},
        "json_formatter": {"emoji": "{}", "color": (63, 81, 181), "name": "JSON"},
        "regex_playground": {"emoji": "R", "color": (0, 150, 136), "name": "Regex"},
        "git_cheatsheet": {"emoji": "G", "color": (158, 158, 158), "name": "Git"},
    },
    "10_micho": {
        "startup_ideas": {"emoji": "I", "color": (255, 152, 0), "name": "Ideas"},
        "pitch_deck": {"emoji": "P", "color": (33, 150, 243), "name": "Pitch"},
        "founder_daily": {"emoji": "F", "color": (156, 39, 176), "name": "Founder"},
        "startup_glossary": {"emoji": "G", "color": (63, 81, 181), "name": "Glossary"},
    },
    "11_playtime_programmers": {
        "code_hero": {"emoji": "C", "color": (255, 87, 34), "name": "Code"},
        "bug_squash": {"emoji": "B", "color": (76, 175, 80), "name": "Bug"},
        "loop_master": {"emoji": "L", "color": (33, 150, 243), "name": "Loop"},
        "variable_valley": {"emoji": "V", "color": (156, 39, 176), "name": "Variable"},
    },
}

ICON_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

def create_simple_icon(size, text, color):
    """Create a simple icon with text and colored background"""
    img = Image.new('RGB', (size, size), color)
    draw = ImageDraw.Draw(img)
    
    # Draw rounded rectangle
    corner_radius = size // 8
    draw.rounded_rectangle(
        [(0, 0), (size, size)],
        radius=corner_radius,
        fill=color
    )
    
    # Draw text
    try:
        # Try to use a system font
        font_size = int(size * 0.4)
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", font_size)
        except:
            try:
                font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
            except:
                font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()
    
    # Calculate text position
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    x = (size - text_width) // 2 - bbox[0]
    y = (size - text_height) // 2 - bbox[1]
    
    # Draw white text
    draw.text((x, y), text, font=font, fill=(255, 255, 255))
    
    return img

def generate_icons_for_app(developer, app_name, config):
    """Generate all icon sizes for an app"""
    text = config["emoji"]
    color = config["color"]
    
    app_path = f"{developer}/{app_name}/android/app/src/main/res"
    
    if not os.path.exists(f"{developer}/{app_name}"):
        raise FileNotFoundError(f"App directory not found: {developer}/{app_name}")
    
    os.makedirs(app_path, exist_ok=True)
    
    for mipmap_name, size in ICON_SIZES.items():
        mipmap_path = os.path.join(app_path, mipmap_name)
        os.makedirs(mipmap_path, exist_ok=True)
        
        icon = create_simple_icon(size, text, color)
        icon_path = os.path.join(mipmap_path, "ic_launcher.png")
        icon.save(icon_path, "PNG")
        print(f"✅ Created {icon_path} ({size}x{size})")
    
    # Create foreground (same as main icon for simplicity)
    for mipmap_name, size in ICON_SIZES.items():
        mipmap_path = os.path.join(app_path, mipmap_name)
        foreground = create_simple_icon(size, text, (255, 255, 255))  # White background
        foreground_path = os.path.join(mipmap_path, "ic_launcher_foreground.png")
        foreground.save(foreground_path, "PNG")
        print(f"✅ Created {foreground_path} ({size}x{size})")
    
    # Create colors.xml
    values_path = os.path.join(app_path, "../values")
    os.makedirs(values_path, exist_ok=True)
    colors_xml = f'''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#{color[0]:02x}{color[1]:02x}{color[2]:02x}</color>
</resources>'''
    with open(os.path.join(values_path, "colors.xml"), "w") as f:
        f.write(colors_xml)
    print(f"✅ Created {values_path}/colors.xml")

def main():
    developer_filter = sys.argv[1] if len(sys.argv) > 1 else "all"
    
    print("══════════════════════════════════════════════════════════════")
    print("   🎨 Generating Simple App Icons")
    print("══════════════════════════════════════════════════════════════")
    print("")
    
    total_icons = 0
    errors = []
    
    for developer, apps in APP_ICONS.items():
        if developer_filter != "all" and developer != developer_filter:
            continue
        
        print(f"Developer: {developer}")
        for app_name, config in apps.items():
            app_path = f"{developer}/{app_name}"
            if not os.path.exists(app_path):
                print(f"⚠️  Skipping {app_path} (not found)")
                continue
            
            try:
                print(f"  Generating icons for: {app_name}")
                generate_icons_for_app(developer, app_name, config)
                total_icons += len(ICON_SIZES) * 2
                print("")
            except Exception as e:
                error_msg = f"Error: {str(e)}"
                print(f"  ❌ {error_msg}")
                errors.append(f"{developer}/{app_name}: {error_msg}")
                import traceback
                traceback.print_exc()
                print("")
    
    print("══════════════════════════════════════════════════════════════")
    if errors:
        print(f"   ⚠️  Generated {total_icons} icons with {len(errors)} errors")
    else:
        print(f"   ✅ Generated {total_icons} icon files")
    print("══════════════════════════════════════════════════════════════")
    
    if errors:
        sys.exit(1)

if __name__ == "__main__":
    main()

