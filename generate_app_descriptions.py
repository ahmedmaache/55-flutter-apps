#!/usr/bin/env python3
import os

# App configurations with basic info from Master Plan
APP_CONFIGS = {
    "01_giggle_game": {
        "joke_generator": {
            "name": "Joke Generator Pro",
            "short": "AI-style random jokes for any occasion. Get your daily laugh!",
            "full": "Looking for a laugh? Joke Generator Pro brings you the best AI-powered jokes right to your fingertips. Whether you need a quick pun for a party or a long-form story for your friends, we've got you covered.\n\nFeatures:\n- Thousands of fresh jokes\n- Multiple categories: Puns, Dad Jokes, Tech Humor\n- Share directly to social media\n- Clean, minimalist interface\n\nDownload now and never run out of humor!"
        },
        "meme_maker": {
            "name": "Meme Maker Lite",
            "short": "Create and share simple memes instantly with our easy editor.",
            "full": "Unleash your creativity with Meme Maker Lite! The fastest way to turn your ideas into viral memes. No complex tools, just pick a template, add text, and you're ready to go.\n\nFeatures:\n- Hundreds of popular templates\n- Custom text styles and colors\n- High-resolution output\n- Works offline\n\nBecome a meme master today!"
        },
        "emoji_story": {
            "name": "Emoji Story Creator",
            "short": "Tell amazing visual stories using only emojis. Fun and creative!",
            "full": "Why use words when emojis can say it all? Emoji Story Creator lets you build unique narratives using the icons you love. Perfect for social media posts, creative writing prompts, or just having fun with friends.\n\nFeatures:\n- Full emoji library support\n- Story templates\n- Export as image or text\n- Weekly challenges\n\nStart your emoji journey now!"
        },
        "laugh_tracker": {
            "name": "Laugh Tracker",
            "short": "Gamify your daily laughter goals and improve your mood.",
            "full": "Did you know that laughing reduces stress? Laugh Tracker helps you gamify your wellness journey by tracking how much you laugh every day. Set goals, earn achievements, and feel better!\n\nFeatures:\n- Simple 'Tap to Laugh' tracking\n- Daily and weekly laughter stats\n- Wellness tips and quotes\n- Mood integration\n\nLaugh more, live better!"
        }
    },
    "02_playpal_creations": {
        "playpal_connect": {
            "name": "PlayPal Connect",
            "short": "Connect and play with friends in this collection of local multiplayer games.",
            "full": "The ultimate party app is here! PlayPal Connect features a hand-picked collection of local multiplayer games designed for groups of friends. No internet required, just bring your friends and start playing.\n\nFeatures:\n- Multiple game modes\n- Support for 2-4 players on one device\n- Fast-paced action and puzzles\n- Perfect for travel and parties\n\nConnect. Play. Win!"
        },
        "party_games": {
            "name": "Party Games Hub",
            "short": "A library of classic and modern games for any social gathering.",
            "full": "Turn any gathering into a blast with Party Games Hub! From word games to quick-reaction challenges, we have everything you need to keep the energy high.\n\nFeatures:\n- Digital versions of classic party games\n- Built-in timers and scoreboards\n- New games added regularly\n- No setup required\n\nYour party, our games!"
        },
        "duo_challenges": {
            "name": "Duo Challenges",
            "short": "Cooperative puzzles and challenges built for two players.",
            "full": "Two heads are better than one! Duo Challenges is a unique puzzle game where two players must work together on the same screen to solve increasingly difficult stages.\n\nFeatures:\n- 50+ cooperative levels\n- Unique 2-player mechanics\n- Test your communication skills\n- Beautiful minimalist graphics\n\nTeam up and solve them all!"
        },
        "word_games": {
            "name": "Social Word Games",
            "short": "Classic word games digitized for fun with friends and family.",
            "full": "Love word games? Social Word Games brings your favorite vocabulary challenges to your smartphone. Play against friends or challenge your own high scores in various modes.\n\nFeatures:\n- Word search, Scramble, and more\n- Multi-language support\n- Compete on global leaderboards\n- Offline play available\n\nMaster the words!"
        }
    },
    "03_olaf": {
        "brain_gym": {
            "name": "olaf Brain Gym",
            "short": "Daily cognitive exercises to keep your mind sharp and focused.",
            "full": "Train your brain like an athlete! olaf Brain Gym offers a scientifically-inspired suite of daily exercises designed to improve memory, focus, and mental agility.\n\nFeatures:\n- Personalized daily workouts\n- Tracking of mental progress\n- Focus-oriented games\n- Nordic minimalist design\n\nSharpen your mind today!"
        },
        "focus_timer": {
            "name": "olaf Focus Timer",
            "short": "Elegant Pomodoro timer with a clean Nordic aesthetic.",
            "full": "Master your productivity with olaf Focus Timer. Based on the proven Pomodoro technique, this app provides an elegant, distraction-free environment to get your work done.\n\nFeatures:\n- Customizable work and break intervals\n- Focus-enhancing ambient sounds\n- Productivity stats\n- Beautiful dark mode\n\nStay focused, achieve more."
        },
        "meditation": {
            "name": "olaf Meditation",
            "short": "Minimalist mindfulness app for a calmer, more balanced life.",
            "full": "Find your inner peace with olaf Meditation. In a world of noise, we provide a quiet space for your daily mindfulness practice. Simple, effective, and beautiful.\n\nFeatures:\n- Guided and unguided sessions\n- Pure ambient soundscapes\n- Daily reminders\n- Sleep integration\n\nBreathe in, stay calm."
        },
        "word_puzzles": {
            "name": "olaf Word Games",
            "short": "Build your vocabulary with minimal and deep word puzzles.",
            "full": "Experience the beauty of words with olaf Word Games. Deep, challenging, and aesthetically pleasing word puzzles that will test your vocabulary and relax your mind.\n\nFeatures:\n- Infinite puzzle modes\n- Calm, relaxing background music\n- Daily challenges\n- Vocabulary builder tool\n\nA Nordic approach to words."
        }
    },
    "04_good_kids": {
        "abc_learning": {
            "name": "ABC Learning Fun",
            "short": "Alphabet and phonics learning made fun for children.",
            "full": "Help your child take their first steps in reading! ABC Learning Fun combines bright colors, catchy sounds, and interactive play to teach the alphabet and basic phonics.\n\nFeatures:\n- Letter tracing and recognition\n- Fun sound effects for every letter\n- Child-safe interface\n- NO ads, NO tracking\n\nLearning is fun with Good Kids!"
        },
        "numbers_counting": {
            "name": "Numbers & Counting",
            "short": "Teach your toddler the basics of math through play.",
            "full": "1, 2, 3... go! Numbers & Counting is the perfect introduction to math for toddlers and preschoolers. Fun interactive games help children understand the concept of numbers.\n\nFeatures:\n- Counting games with cute characters\n- Basic addition and subtraction\n- Colorful animations\n- Progress tracking for parents\n\nBuilding math foundations early!"
        },
        "kindness_quest": {
            "name": "Kindness Quest",
            "short": "Interactive games that teach children about empathy and kindness.",
            "full": "Kindness is a superpower! Kindness Quest is a story-driven game where children make choices that help characters in need, learning the value of empathy and helpfulness.\n\nFeatures:\n- Engaging character stories\n- Choice-based gameplay\n- Positive reinforcement\n- Beautiful hand-drawn art\n\nGrow kind hearts!"
        },
        "chore_champion": {
            "name": "Chore Champion",
            "short": "Gamify daily tasks and chores to make responsibility fun for kids.",
            "full": "Turn chores into adventures! Chore Champion helps parents and kids work together on daily tasks. Earn experience points, level up, and become the master of the house.\n\nFeatures:\n- Customizable chore lists\n- Reward system and badges\n- Family sync\n- Fun RPG-style progression\n- Positive habits for life\n\nBe a Champion!"
        }
    },
    "05_apocalypse_never": {
        "eco_warrior": {
            "name": "Eco Warrior Game",
            "short": "Save the planet in this strategic environmental action game.",
            "full": "The earth is in trouble, and only an Eco Warrior can save it! Take control of a green hero and complete missions to clean up the ocean, plant forests, and fight pollution.\n\nFeatures:\n- Engaging strategy-action gameplay\n- Real-world environmental tips\n- Global leaderboards\n- Help unlock real-world donations\n\nPlay for the planet!"
        },
        "survival_calc": {
            "name": "Survival Calculator",
            "short": "Essential emergency preparedness tool for any situation.",
            "full": "Be ready for anything! Survival Calculator provides quick calculations for food storage, water needs, and emergency energy requirements based on your family size.\n\nFeatures:\n- Supply planning tools\n- First aid quick-guides\n- Offline access to survival data\n- Checklists for go-bags\n\nPreparation is the key to survival."
        },
        "carbon_tracker": {
            "name": "Carbon Tracker",
            "short": "Easily track and reduce your daily carbon footprint.",
            "full": "Understand your impact on the world. Carbon Tracker helps you log your daily activities—from transportation to diet—and shows you how to reduce your carbon footprint.\n\nFeatures:\n- Easy logging of daily habits\n- Impact visualizations\n- Personalized reduction tips\n- Community goals\n- Track your progress over time\n\nSmall steps for a big change."
        },
        "resource_manager": {
            "name": "Resource Manager Sim",
            "short": "Master strategic resource planning in this complex simulation.",
            "full": "Can you manage a community's resources under pressure? Resource Manager Sim is a deep strategy game where every choice affects the survival of your settlement.\n\nFeatures:\n- Complex resource loops\n- Dynamic events and disasters\n- Research and tech trees\n- Multiple endings\n\nA true test of management skills."
        }
    },
    "06_atomizer": {
        "quick_notes": {
            "name": "Quick Notes",
            "short": "Ultra-fast note-taking app for captured thoughts on the go.",
            "full": "Don't let a good idea get away! Quick Notes is designed for speed. Open the app, type your thought, and save it in a second. No bloat, just performance.\n\nFeatures:\n- Instant-open technology\n- Minimalist Markdown support\n- Simple categorization\n- iCloud/Google Drive sync\n\nFast notes for fast minds."
        },
        "speed_reader": {
            "name": "Speed Reader Pro",
            "short": "Train yourself to read faster and retain more information.",
            "full": "Read a book a day! Speed Reader Pro uses scientifically-backed methods like RSVP (Rapid Serial Visual Presentation) to increase your reading speed while maintaining comprehension.\n\nFeatures:\n- Adjustable WPM (Words Per Minute)\n- Comprehension tests\n- Eye-training exercises\n- Support for EPUB and TXT\n\nAccelerate your learning!"
        },
        "flash_math": {
            "name": "Flash Math",
            "short": "Build lightning-fast mental math skills through quick challenges.",
            "full": "Can you solve it in a flash? Flash Math presents rapid-fire math problems that will challenge even the sharpest minds. Perfect for students and professionals alike.\n\nFeatures:\n- Addition, Subtraction, Multi, Division\n- Increasing difficulty levels\n- Daily streaks and goals\n- Global competition mode\n\nMaster the numbers!"
        },
        "micro_habits": {
            "name": "Micro Habits",
            "short": "Build big results with 1-minute positive habit building.",
            "full": "Success is found in your daily routine. Micro Habits focuses on the power of small actions. Build 1-minute habits that lead to life-changing results.\n\nFeatures:\n- 1-minute habit suggestions\n- Streak tracking\n- Reminder system\n- Progress visualizations\n\nTiny habits, massive impact."
        }
    },
    "07_okkyes": {
        "affirmations": {
            "name": "Daily Affirmations",
            "short": "Positive morning messages to start your day with confidence.",
            "full": "Start every day on a high note! Daily Affirmations delivers curated positive messages designed to build your self-esteem and focus your energy on growth.\n\nFeatures:\n- Thousands of unique affirmations\n- Beautiful widget support\n- Calm background audio\n- Save your favorites\n\nSay YES to a better you."
        },
        "mood_ok": {
            "name": "Mood OK",
            "short": "Simple and effective daily mood logging and analytics.",
            "full": "How are you really feeling? Mood OK provides a simple way to log your emotions and identify patterns in your daily life. Better understanding leads to better living.\n\nFeatures:\n- One-tap mood logging\n- Pattern analysis and graphs\n- Private daily journaling\n- Data export for support\n\nUnderstand your journey."
        },
        "gratitude_journal": {
            "name": "Gratitude Journal",
            "short": "Simple gratitude tracking to improve your overall happiness.",
            "full": "Happiness starts with gratitude. Our Gratitude Journal makes it easy to record three things you're thankful for every day, helping you shift your focus to the positive.\n\nFeatures:\n- Guided gratitude prompts\n- Photo integration\n- Secure, private storage\n- Reminder notifications\n\nCount your blessings."
        },
        "goal_tracker": {
            "name": "Goal Tracker OK",
            "short": "Set and track simple goals for a more productive lifestyle.",
            "full": "What do you want to achieve today? Goal Tracker OK helps you break down your dreams into manageable, trackable goals. Stay organized and stay motivated.\n\nFeatures:\n- Goal categorization\n- Milestone tracking\n- Motivational quotes\n- Clean, easy-to-use UI\n\nNavigate to success."
        }
    },
    "08_insightful_apps": {
        "insight_journal": {
            "name": "Insight Journal",
            "short": "AI-style journaling that helps you find patterns in your thoughts.",
            "full": "Go deeper with your writing. Insight Journal uses advanced text analysis to help you identify themes and emotional trends in your daily journal entries.\n\nFeatures:\n- Sentiment analysis tools\n- Keyword and theme tracking\n- Password protection\n- Export to PDF/Markdown\n\nWrite your way to clarity."
        },
        "spending_insights": {
            "name": "Spending Insights",
            "short": "Clear and simple analyzer for your personal finances.",
            "full": "Take control of your money. Spending Insights provides a high-level view of where your money goes, helping you identify areas for saving without the complexity of traditional banking apps.\n\nFeatures:\n- Category-based logging\n- Monthly budget trackers\n- Spending visualizations\n- Privacy-first: no bank links\n\nMaster your budget."
        },
        "habit_insights": {
            "name": "Habit Insights",
            "short": "Behavioral tracking with deep insights into your lifestyle.",
            "full": "Track more than just streaks. Habit Insights analyzes the correlations between your habits and your mood/productivity to help you build the perfect routine.\n\nFeatures:\n- Multi-habit correlation engine\n- Flexible tracking options\n- Heatmap visualizations\n- Smart notifications\n\nBuild a better you."
        },
        "reading_tracker": {
            "name": "Reading Tracker",
            "short": "Keep track of your reading progress and book notes.",
            "full": "Your personal digital library assistant. Reading Tracker helps you log the books you've read, track your current progress, and save important quotes and notes.\n\nFeatures:\n- ISBN barcode scanner\n- Reading speed estimator\n- Yearly reading goals\n- Sync with fellow readers\n\nNever forget a great book."
        }
    },
    "09_build_deploy_labs": {
        "devlog_app": {
            "name": "DevLog App",
            "short": "The perfect companion for developers to log their project progress.",
            "full": "Ship better code with DevLog! Document your daily wins, bugs solved, and feature plans in a tool built specifically for developers.\n\nFeatures:\n- Project-based organization\n- Code snippet support\n- Push-to-GitHub integration\n- Developer-friendly UI\n\nLog. Build. Ship."
        },
        "json_formatter": {
            "name": "JSON Formatter",
            "short": "Clean and fast JSON formatting utility for your mobile device.",
            "full": "Developer utility on the go! JSON Formatter makes it easy to read, validate, and format complex JSON data right on your phone.\n\nFeatures:\n- Syntax highlighting\n- Error detection\n- One-tap copy/paste\n- Offline functionality\n\nJSON made readable."
        },
        "regex_playground": {
            "name": "Regex Playground",
            "short": "Practice and test Regular Expression patterns with ease.",
            "full": "Master the art of Regex! Our playground provides a real-time environment to test your patterns against sample text, with helpful explanations and cheat sheets.\n\nFeatures:\n- Real-time matching\n- Regex cheat sheet included\n- Library of common patterns\n- Support for multiple languages\n\nDon't fear the pattern."
        },
        "git_cheatsheet": {
            "name": "Git Cheatsheet",
            "short": "Quick reference for Git commands and best practices.",
            "full": "Your pocket guide to Version Control. Never forget a git command again. From basic commits to complex rebases, we have it all documented.\n\nFeatures:\n- Searchable command list\n- Workflow diagrams\n- Best practices guide\n- Works 100% offline\n\nGit it done!"
        }
    },
    "10_micho": {
        "startup_ideas": {
            "name": "Startup Ideas Generator",
            "short": "Generate and organize new business ideas for your next venture.",
            "full": "The bridge between inspiration and execution. Startup Ideas Generator helps you brainstorm new business models using proven frameworks and creative prompts.\n\nFeatures:\n- Idea generation engine\n- SWOT analysis builder\n- Market size calculators\n- Idea voting system\n\nStart your journey."
        },
        "pitch_deck": {
            "name": "Pitch Deck Helper",
            "short": "Expert templates and guides for your startup presentation.",
            "full": "Nail your next investor meeting! Pitch Deck Helper provides structured templates and advice for creating a world-class startup presentation.\n\nFeatures:\n- Slide-by-slide guidance\n- Examples from successful startups\n- Checklists for readiness\n- Export as PDF outline\n\nPitch like a pro."
        },
        "founder_daily": {
            "name": "Founder Daily",
            "short": "Optimized daily routines for successful entrepreneurs.",
            "full": "Live like a founder. Founder Daily provides structured routines used by successful CEOs to maintain focus, health, and productivity under pressure.\n\nFeatures:\n- Founder-specific task lists\n- Time-blocking assistant\n- Stress management tools\n- Community of entrepreneurs\n\nScale yourself."
        },
        "startup_glossary": {
            "name": "Startup Glossary",
            "short": "Master the world of business and startup terminology.",
            "full": "Speak the language of Silicon Valley. From 'Churn' to 'Unicorn', our glossary provides clear, concise definitions of every term you'll encounter in the startup world.\n\nFeatures:\n- 500+ business terms\n- Audio pronunciations\n- Contextual examples\n- Quiz mode to test knowledge\n\nKnowledge is equity."
        }
    },
    "11_playtime_programmers": {
        "code_hero": {
            "name": "Code Hero Adventure",
            "short": "Learn programming concepts through an epic RPG adventure.",
            "full": "The world of Code is in danger! Only a Code Hero can save it. In this RPG, you solve coding puzzles to cast spells, fight bugs, and level up your character.\n\nFeatures:\n- Logic-based puzzle battles\n- Educational coding storyline\n- Multiple 'paths' (languages)\n- Character customization\n\nSave the world, learn to code."
        },
        "bug_squash": {
            "name": "Bug Squash",
            "short": "Fun and fast-paced game where you find and fix code errors.",
            "full": "The server is crashing! Can you find the bugs in time? Bug Squash is a fast-paced reaction game where players must identify syntax errors and logical bugs in code blocks.\n\nFeatures:\n- Fast-paced arcade gameplay\n- Real code snippets (Dart, JS, Py)\n- Increasing difficulty levels\n- Leaderboards and achievements\n\nBecome a debugging master!"
        },
        "loop_master": {
            "name": "Loop Master",
            "short": "Learn the power of loops through engaging logic puzzles.",
            "full": "If you can master the loop, you can master the code. Loop Master is a dedicated puzzle game focused on the most important concept in programming.\n\nFeatures:\n- 100+ logical puzzles\n- Visual loop building\n- Optimization challenges\n- Brain-training mechanics\n\nDon't get stuck in a loop!"
        },
        "variable_valley": {
            "name": "Variable Valley",
            "short": "Explore the concept of variables in this beautiful logic game.",
            "full": "Enter the valley and learn to store, move, and transform data. Variable Valley is a stunning logic game that teaches the fundamental concept of data types and storage.\n\nFeatures:\n- Beautiful landscape-based puzzles\n- Interactive data flow mechanics\n- Relaxing soundtrack\n- educational progress tracking\n\nData is a journey."
        }
    }
}

# Add existing apps (11 total)
EXISTING_APPS = {
    "01_giggle_game": "funny_sound_board",
    "02_playpal_creations": "match_3",
    "03_olaf": "memory_cards",
    "04_good_kids": "tic_tac_toe",
    "05_apocalypse_never": "merge_puzzle",
    "06_atomizer": "reflex_tap",
    "07_okkyes": "catch_fall",
    "08_insightful_apps": "runner_game",
    "09_build_deploy_labs": "stack_blocks",
    "10_micho": "startup_quiz",
    "11_playtime_programmers": "swipe_avoider"
}

# Generic content for existing apps if not defined
for dev, app_id in EXISTING_APPS.items():
    if app_id not in APP_CONFIGS.get(dev, {}):
        APP_CONFIGS.setdefault(dev, {})[app_id] = {
            "name": app_id.replace("_", " ").title(),
            "short": f"The classic {app_id.replace('_', ' ')} app by Gloven.",
            "full": f"Experience the classic {app_id.replace('_', ' ')} like never before. Part of the Gloven Startup Portfolio, this app is designed for speed, simplicity, and fun.\n\nFeatures:\n- High quality performance\n- Regular updates\n- User-friendly design\n- Part of the Gloven ecosystem\n\nDownload today!"
        }

def main():
    print("📝 Generating Store Descriptions for all 55 Apps...")
    total = 0
    for dev_dir, apps in APP_CONFIGS.items():
        clean_dev = dev_dir.split('_', 1)[1] if '_' in dev_dir else dev_dir
        for app_id, config in apps.items():
            base_path = f"store_assets/{clean_dev}/{app_id}"
            os.makedirs(base_path, exist_ok=True)
            
            # Write Short Description
            with open(f"{base_path}/short_description.txt", "w") as f:
                f.write(config["short"])
            
            # Write Full Description
            with open(f"{base_path}/full_description.txt", "w") as f:
                f.write(config["full"])
                
            total += 1
            
    print(f"✅ Success! Generated descriptions for {total} apps.")

if __name__ == "__main__":
    main()
