#!/usr/bin/env python3
"""Test icon generation script locally"""

import sys
import os

# Add script directory to path
script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, script_dir)

try:
    from generate_app_icons import generate_icons_for_app, APP_ICONS, ICON_SIZES
    
    print("══════════════════════════════════════════════════════════════")
    print("   🧪 Testing Icon Generation")
    print("══════════════════════════════════════════════════════════════")
    print("")
    
    # Test with one app
    developer = "01_giggle_game"
    app_name = "joke_generator"
    
    if developer in APP_ICONS and app_name in APP_ICONS[developer]:
        config = APP_ICONS[developer][app_name]
        app_path = f"{developer}/{app_name}"
        
        if os.path.exists(app_path):
            print(f"Testing icon generation for: {developer}/{app_name}")
            print(f"Config: {config}")
            print("")
            
            try:
                generate_icons_for_app(developer, app_name, config)
                print("✅ Icon generation test successful!")
            except Exception as e:
                print(f"❌ Error: {e}")
                import traceback
                traceback.print_exc()
        else:
            print(f"❌ App path not found: {app_path}")
    else:
        print(f"❌ App not found in configuration")
        
except ImportError as e:
    print(f"❌ Import error: {e}")
    import traceback
    traceback.print_exc()
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()

