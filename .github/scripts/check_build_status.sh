#!/bin/bash
# Check GitHub Actions build status

GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
REPO="ahmedmaache/55-flutter-apps-workspace"

echo "══════════════════════════════════════════════════════════════"
echo "   📊 GitHub Actions Build Status"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Get recent workflow runs
response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$REPO/actions/runs?per_page=10")

# Parse and display status
echo "$response" | python3 -c "
import sys, json
from datetime import datetime

try:
    data = json.load(sys.stdin)
    runs = data.get('workflow_runs', [])
    
    if not runs:
        print('No workflow runs found')
        sys.exit(0)
    
    print('Recent Builds:')
    print('')
    
    for i, run in enumerate(runs[:10], 1):
        name = run.get('display_title', run.get('name', 'Unknown'))
        status = run.get('status', 'unknown')
        conclusion = run.get('conclusion', 'N/A')
        created = run.get('created_at', '')
        url = run.get('html_url', '')
        
        # Format status
        status_icon = '🟢' if conclusion == 'success' else '🔴' if conclusion == 'failure' else '🟡'
        status_text = conclusion.upper() if conclusion != 'N/A' else status.upper()
        
        # Format time
        if created:
            try:
                dt = datetime.fromisoformat(created.replace('Z', '+00:00'))
                time_ago = datetime.now(dt.tzinfo) - dt
                if time_ago.seconds < 60:
                    time_str = f'{time_ago.seconds}s ago'
                elif time_ago.seconds < 3600:
                    time_str = f'{time_ago.seconds // 60}m ago'
                else:
                    time_str = f'{time_ago.seconds // 3600}h ago'
            except:
                time_str = created[:19]
        else:
            time_str = 'Unknown'
        
        print(f'{i}. {status_icon} {name}')
        print(f'   Status: {status_text} | {time_str}')
        print(f'   URL: {url}')
        print('')
    
    # Summary
    success = sum(1 for r in runs if r.get('conclusion') == 'success')
    failure = sum(1 for r in runs if r.get('conclusion') == 'failure')
    in_progress = sum(1 for r in runs if r.get('status') == 'in_progress')
    
    print('══════════════════════════════════════════════════════════════')
    print(f'Summary: ✅ {success} successful | ❌ {failure} failed | 🟡 {in_progress} in progress')
    print('══════════════════════════════════════════════════════════════')
    
except Exception as e:
    print(f'Error parsing response: {e}')
    print('Raw response:')
    print(sys.stdin.read())
" 2>/dev/null || echo "Error checking status. Visit: https://github.com/$REPO/actions"

echo ""
echo "📊 View all builds:"
echo "   https://github.com/$REPO/actions"
echo ""

