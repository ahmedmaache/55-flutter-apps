#!/usr/bin/env python3
"""
Create WordPress posts for app privacy policies
WordPress REST API integration for gloven.org
"""

import requests
import base64
import json
import os
from pathlib import Path

# WordPress credentials
WORDPRESS_URL = "https://gloven.org"
WORDPRESS_USER = "admin"
WORDPRESS_APP_PASSWORD = "24oSl Vi5A Rio3 zJeT 7BGX LnIE"  # App password (spaces removed for API)

# API endpoint
API_URL = f"{WORDPRESS_URL}/wp-json/wp/v2/posts"

# Authentication - WordPress app passwords don't include spaces in API calls
credentials = f"{WORDPRESS_USER}:{WORDPRESS_APP_PASSWORD.replace(' ', '')}"
token = base64.b64encode(credentials.encode()).decode('utf-8')
headers = {
    'Authorization': f'Basic {token}',
    'Content-Type': 'application/json'
}

def create_privacy_policy_post(app_name, developer_name, privacy_policy_content, app_slug):
    """Create a WordPress post for app privacy policy"""
    
    # Create post title
    title = f"Privacy Policy - {app_name}"
    
    # Create post slug
    post_slug = f"privacy-{app_slug}"
    
    # Format content as HTML
    html_content = f"""
    <div class="privacy-policy">
        <h1>Privacy Policy for {app_name}</h1>
        <p><strong>Developer:</strong> {developer_name}</p>
        <p><strong>Last Updated:</strong> December 2024</p>
        <hr>
        {privacy_policy_content.replace(chr(10), '<br>')}
    </div>
    """
    
    # Post data
    post_data = {
        'title': title,
        'slug': post_slug,
        'status': 'publish',
        'content': html_content,
        'categories': [1],  # Default category (adjust if needed)
        # Tags need to be created first or use tag IDs - removing for now
    }
    
    try:
        response = requests.post(API_URL, headers=headers, json=post_data, timeout=30)
        
        if response.status_code == 201:
            post = response.json()
            post_url = post['link']
            print(f"  ✓ Created: {title}")
            print(f"    URL: {post_url}")
            return post_url
        else:
            print(f"  ✗ Failed: {title}")
            print(f"    Error: {response.status_code} - {response.text}")
            return None
    except Exception as e:
        print(f"  ✗ Error creating post for {app_name}: {str(e)}")
        return None

def main():
    workspace = Path("/home/maache/55 flutterapps")
    store_assets = workspace / "store_assets"
    
    # App configurations
    apps_config = [
        {
            "developer": "Giggle Game",
            "apps": [
                {"name": "Joke Generator Pro", "slug": "joke-generator", "folder": "joke_generator"},
                {"name": "Meme Maker Lite", "slug": "meme-maker", "folder": "meme_maker"},
                {"name": "Emoji Story Creator", "slug": "emoji-story", "folder": "emoji_story"},
                {"name": "Laugh Tracker", "slug": "laugh-tracker", "folder": "laugh_tracker"},
            ]
        }
    ]
    
    print("══════════════════════════════════════════════════════════════")
    print("   📝 Creating WordPress Privacy Policy Posts")
    print("══════════════════════════════════════════════════════════════")
    print("")
    
    for config in apps_config:
        developer = config["developer"]
        print(f"Developer: {developer}")
        print("")
        
        for app in config["apps"]:
            app_name = app["name"]
            app_slug = app["slug"]
            app_folder = app["folder"]
            
            privacy_file = store_assets / developer / app_folder / "privacy_policy.txt"
            
            if privacy_file.exists():
                with open(privacy_file, 'r', encoding='utf-8') as f:
                    privacy_content = f.read()
                
                post_url = create_privacy_policy_post(
                    app_name, 
                    developer, 
                    privacy_content, 
                    app_slug
                )
                
                # Save post URL
                if post_url:
                    url_file = store_assets / developer / app_folder / "privacy_policy_url.txt"
                    with open(url_file, 'w') as f:
                        f.write(post_url)
            else:
                print(f"  ⚠ Privacy policy file not found: {privacy_file}")
            print("")
    
    print("══════════════════════════════════════════════════════════════")
    print("   ✅ WordPress Posts Creation Complete!")
    print("══════════════════════════════════════════════════════════════")

if __name__ == "__main__":
    main()

