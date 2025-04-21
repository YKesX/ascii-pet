#!/usr/bin/env python3
import os
import time
import platform
import random
import datetime
import json
import threading
import sys
import select

# Try to import msvcrt for Windows systems
msvcrt_available = False
try:
    import msvcrt
    msvcrt_available = True
except ImportError:
    pass  # Not on Windows

# Random event lists
items_list = [
    "a shiny coin", "a small toy mouse", "a colorful feather", "a rubber band",
    "a bottlecap", "a small piece of paper", "a mysterious key", "a button",
    "a paperclip", "a tiny plushie", "a lost sock", "a shiny rock",
    "a piece of string", "a candy wrapper", "a forgotten hair tie",
    "a puzzle piece", "a tiny figurine", "a leaf", "a flower petal",
    "a small ball", "a pencil stub", "a piece of yarn", "a sticker",
    "a forgotten sticky note", "a tiny book", "a small piece of cloth",
    "a bit of ribbon", "a plastic gem", "a bottle cork", "a small shell"
]

advice_list = [
    "Never trust a cat who can speak French.",
    "The best way to fold a fitted sheet is to give up and make a ball.",
    "When in doubt, take a nap.",
    "If you can't decide what to eat, wait until you're really hungry. Then everything tastes good.",
    "Always keep an extra sock in your pocket for emergencies.",
    "The best time to do laundry is right before you run out of clean underwear.",
    "Never tell a squirrel your secrets. They gossip.",
    "Running late? Try walking faster instead.",
    "The solution to most tech problems is turning it off and on again.",
    "Eat dessert first. Life is uncertain.",
    "If you can't see the dust on your furniture, just take off your glasses.",
    "Anything is a toy if you use your imagination.",
    "The perfect nap length is however long until someone wakes you up.",
    "When someone says 'we need to talk', suggest a nap instead.",
    "If you're ever lost, just act like you know where you're going.",
    "Always pretend to understand art.",
    "If it's stupid but it works, it's not stupid.",
    "Dance like nobody is watching, because they're probably on their phones.",
    "When someone asks your opinion, give the opposite of what you actually think.",
    "The best time to make important decisions is 3AM."
]

existential_questions = [
    "Do you think fish know they're wet?",
    "If I sit on my own tail, whose fault is it really?",
    "Why do humans pay to park but pay to leave parks?",
    "If I catch a laser dot, what does it taste like?",
    "Is the refrigerator light really always on?",
    "Do dog toys look like dogs to dogs?",
    "What if the color I see as blue is what you see as red?",
    "Why do humans put bells on my collar but not on theirs?",
    "If I knock something off a table and no one sees it, did it really fall?",
    "Why do humans say 'you can't have your cake and eat it too'? What else would you do with cake?",
    "Do windows even exist or are they just clear walls?",
    "If I sleep 18 hours a day, do I experience more or less life than you?",
    "Am I a good pet, or are you a good human?",
    "Why do humans collect my fur with vacuums but put fur coats in closets?",
    "If I'm a pet, are you also a pet to someone else?",
    "Why do humans take pictures of food before eating, but not after?",
    "Do I chase my tail, or does my tail chase me?",
    "What if the red dot is actually controlling the human?",
    "Why do they call it a 'building' when it's already built?",
    "If a tree falls in the forest and lands on a squirrel, is it still my fault?"
]

# Random event constants
EVENT_CHANCE_PER_MINUTE = 0.1  # 10% chance per minute to trigger any event check
ITEM_EVENT_DAILY_LIMIT = 2     # Maximum of 2 item events per day
ADVICE_EVENT_HOURLY_LIMIT = 4  # Maximum of 4 advice events per hour
QUESTION_EVENT_HOURLY_LIMIT = 4  # Maximum of 4 question events per hour

# Cat ASCII art for different moods with animation variants
# Idle cat animations (blinking, shifting, normal)
cat_idle_art = [
    r"""
    /\_/\  
   ( o.o ) 
    > ^ <  
   Idle...
""",
    r"""
    /\_/\  
   ( -.- ) 
    > ^ <  
   Idle...
""",
    r"""
    /\_/\  
   ( o.o ) 
    > ~ <  
   Idle...
"""
]

# Happy cat animations
cat_happy_art = [
    r"""
    /\_/\  
   ( ^ᴗ^ ) 
    > ~ <  
   Happy!
""",
    r"""
    /\_/\  
   ( ^-^ ) 
    > ~ <  
   Happy!
""",
    r"""
    /\_/\  
   ( ^ᴗ^ ) 
    > ^-^ <  
   Happy!
"""
]

# Angry cat animations
cat_angry_art = [
    r"""
    /\_/\  
   ( ÒᴗÓ )
    > ! <  
   Angry!
""",
    r"""
    /\_/\  
   ( Ò-Ó )
    > ! <  
   Angry!
""",
    r"""
    /\_/\  
   ( ÒᴗÓ )
    > !!! <  
   Angry!
"""
]

# Sleepy cat animations
cat_sleepy_art = [
    r"""
    /\_/\  
   ( -.- ) 
    > z <  
   Sleepy...
""",
    r"""
    /\_/\  
   ( -.o ) 
    > z <  
   Sleepy...
""",
    r"""
    /\_/\  
   ( -.- ) 
    > z.. <  
   Sleepy...
"""
]

# Sleeping cat animations
cat_sleeping_art = [
    r"""
    /\_/\  
   ( -.- ) zZzZ
    > z <  
   Sleeping...
""",
    r"""
    /\_/\  
   ( -.- ) zZ
    > z <  
   Sleeping...
""",
    r"""
    /\_/\  
   ( -.- ) zZzZz
    > z <  
   Sleeping...
"""
]

# Hungry cat animations
cat_hungry_art = [
    r"""
    /\_/\  
   ( o.o ) 
    > ◊ <  
   Hungry...
""",
    r"""
    /\_/\  
   ( o.o ) 
    > ◊◊ <  
   Hungry...
""",
    r"""
    /\_/\  
   ( o_o ) 
    > ◊ <  
   Hungry...
"""
]

# Wants attention cat animations
cat_wants_attention_art = [
    r"""
    /\_/\  
   ( o.o ) 
    > ? <  
   Needs attention!
""",
    r"""
    /\_/\  
   ( o_o ) 
    > ? <  
   Needs attention!
""",
    r"""
    /\_/\  
   ( o.o ) 
    > ?? <  
   Needs attention!
"""
]

# Dog ASCII art for different moods with animation variants
# Idle dog animations
dog_idle_art = [
    r"""
    /^ ^\
   / o o \
   V\ Y /V
    / - \
   /    |
  V__) ||
   Idle...
""",
    r"""
    /^ ^\
   / - - \
   V\ Y /V
    / - \
   /    |
  V__) ||
   Idle...
""",
    r"""
    /^ ^\
   / o o \
   V\ Y /V
    / ~ \
   /    |
  V__) ||
   Idle...
"""
]

# Happy dog animations
dog_happy_art = [
    r"""
    /^ ^\
   / ^v^ \
   V\ Y /V
    / ~ \
   /    |
  V__) || 
   Happy!
""",
    r"""
    /^ ^\
   / ^-^ \
   V\ Y /V
    / ~ \
   /    |
  V__) || 
   Happy!
""",
    r"""
    /^ ^\
   / ^v^ \
    V\ Y /V
    / ~~ \
   /    |
  V__) || 
   Happy!
"""
]

# Angry dog animations
dog_angry_art = [
    r"""
    /^ ^\
   / ÒvÓ \
   V\ Y /V
    / ! \
   /    |
  V__) || 
   Angry!
""",
    r"""
    /^ ^\
   / Ò-Ó \
   V\ Y /V
    / ! \
   /    |
  V__) || 
   Angry!
""",
    r"""
    /^ ^\
   / ÒvÓ \
   V\ Y /V
    / !!! \
   /    |
  V__) || 
   Angry!
"""
]

# Sleepy dog animations
dog_sleepy_art = [
    r"""
    /^ ^\
   / -.- \
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleepy...
""",
    r"""
    /^ ^\
   / -.o \
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleepy...
""",
    r"""
    /^ ^\
   / -.- \
   V\ Y /V
    / z.. \
   /    |
  V__) || 
   Sleepy...
"""
]

# Sleeping dog animations
dog_sleeping_art = [
    r"""
    /^ ^\
   / -.- \ zZzZ
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleeping...
""",
    r"""
    /^ ^\
   / -.- \ zZ
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleeping...
""",
    r"""
    /^ ^\
   / -.- \ zZzZz
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleeping...
"""
]

# Hungry dog animations
dog_hungry_art = [
    r"""
    /^ ^\
   / o o \
   V\ Y /V
    / ◊ \
   /    |
  V__) || 
   Hungry...
""",
    r"""
    /^ ^\
   / o_o \
   V\ Y /V
    / ◊ \
   /    |
  V__) || 
   Hungry...
""",
    r"""
    /^ ^\
   / o o \
   V\ Y /V
    / ◊◊ \
   /    |
  V__) || 
   Hungry...
"""
]

# Wants attention dog animations
dog_wants_attention_art = [
    r"""
    /^ ^\
   / o o \
   V\ Y /V
    / ? \
   /    |
  V__) || 
   Needs attention!
""",
    r"""
    /^ ^\
   / o_o \
   V\ Y /V
    / ? \
   /    |
  V__) || 
   Needs attention!
""",
    r"""
    /^ ^\
   / o o \
   V\ Y /V
    / ?? \
   /    |
  V__) || 
   Needs attention!
"""
]

SAVE_FILE = "pet_save.json"
ANIMATION_INTERVAL = 2  # Seconds between animation frames

# Global variables for animation
animation_enabled = True
animation_frame = 0

# Function to clear the screen based on OS
def clear_screen():
    if platform.system() == "Windows":
        os.system('cls')
    else:
        os.system('clear')

# Art lookup cache to avoid repeated logic
def get_art_set(mood, pet_type):
    """Return the appropriate art set based on mood and pet type. Uses a dictionary for faster lookups."""
    art_sets = {
        "cat": {
            "idle": cat_idle_art,
            "happy": cat_happy_art,
            "angry": cat_angry_art,
            "sleepy": cat_sleepy_art,
            "sleeping": cat_sleeping_art,
            "hungry": cat_hungry_art,
            "wants_attention": cat_wants_attention_art
        },
        "dog": {
            "idle": dog_idle_art,
            "happy": dog_happy_art,
            "angry": dog_angry_art,
            "sleepy": dog_sleepy_art,
            "sleeping": dog_sleeping_art,
            "hungry": dog_hungry_art,
            "wants_attention": dog_wants_attention_art
        }
    }
    
    # Get the appropriate art set, defaulting to idle if mood not found
    return art_sets[pet_type].get(mood, art_sets[pet_type]["idle"])

# Function to display the pet based on mood and pet type with animations
def show_pet(mood, pet_type):
    global animation_frame
    
    # Get the appropriate animation set using the cached lookup
    art_set = get_art_set(mood, pet_type)
    
    # Only clear screen once before displaying to reduce flicker
    clear_screen()
    
    # Display the current animation frame from the selected art set
    current_art = art_set[animation_frame % len(art_set)]
    print(current_art)

# Animation timer function that runs in a separate thread
def animation_timer():
    global animation_frame, animation_enabled
    while animation_enabled:
        try:
            time.sleep(ANIMATION_INTERVAL)
            animation_frame += 1
        except:
            # Handle any exceptions in the animation thread
            pass

# Function to display menu with timeout for animation updates
def display_menu_with_animation(mood, pet_type, status_info):
    global animation_frame
    
    start_time = datetime.datetime.now()
    last_frame = animation_frame
    timeout = 0.1  # Small timeout for responsiveness
    
    while True:
        # Check if animation frame has changed
        if last_frame != animation_frame:
            # Redraw the pet and menu when the frame changes
            show_pet(mood, pet_type)
            print(status_info)
            print("\nWhat would you like to do with your pet?")
            print("1. Feed the pet")
            print("2. Pet the pet")
            print("3. Insult the pet")
            print("4. Let the pet rest")
            print("5. Check pet status")
            print("6. View dashboard")
            print("7. Exit")
            print("> ", end="", flush=True)  # Print prompt without newline
            last_frame = animation_frame
        
        # Check for input with timeout
        if platform.system() == 'Windows':
            if msvcrt_available:
                # Windows-specific input handling
                if msvcrt.kbhit():
                    choice = input().strip()
                    if choice == '':
                        # Handle empty input (just pressing Enter)
                        continue
                    return choice
        else:
            # Unix systems can use select for non-blocking input
            if select.select([sys.stdin], [], [], 0)[0]:
                choice = input().strip()
                if choice == '':
                    # Handle empty input (just pressing Enter)
                    continue
                return choice
        
        # Small sleep to prevent CPU hogging
        time.sleep(timeout)

# Function to display menu (fallback if animation doesn't work)
def display_menu():
    print("\nWhat would you like to do with your pet?")
    print("1. Feed the pet")
    print("2. Pet the pet")
    print("3. Insult the pet")
    print("4. Let the pet rest")
    print("5. Check pet status")
    print("6. View dashboard")
    print("7. Exit")
    return input("> ")

# Function to calculate happiness percentage
def calculate_happiness(total_feedings, total_pettings, total_sleep_sessions, total_insults):
    positive_interactions = total_feedings + total_pettings + total_sleep_sessions
    total_interactions = positive_interactions + total_insults
    
    if total_interactions == 0:
        return 50.0  # Default happiness if no interactions
    
    happiness = (positive_interactions / total_interactions) * 100
    return min(100.0, max(0.0, happiness))  # Ensure it's between 0 and 100

# Function to display the dashboard
def display_dashboard(pet_name, pet_type, mood, total_feedings, total_pettings, total_insults, 
                     total_sleep_sessions, hours_since_fed, hours_since_attention, 
                     hours_since_sleep, total_hours_alive):
    clear_screen()
    happiness = calculate_happiness(total_feedings, total_pettings, total_sleep_sessions, total_insults)
    
    print(f"┌{'─' * 50}┐")
    print(f"│{'PET DASHBOARD':^50}│")
    print(f"├{'─' * 50}┤")
    print(f"│ Pet Name: {pet_name:<40}│")
    print(f"│ Pet Type: {pet_type.capitalize():<40}│")
    print(f"│ Current Mood: {mood.capitalize():<36}│")
    print(f"│ Time Alive: {format_time(total_hours_alive):<36}│")
    print(f"├{'─' * 50}┤")
    print(f"│{'INTERACTION STATISTICS':^50}│")
    print(f"├{'─' * 50}┤")
    print(f"│ Total Feedings: {total_feedings:<35}│")
    print(f"│ Total Pettings: {total_pettings:<35}│")
    print(f"│ Total Insults: {total_insults:<36}│")
    print(f"│ Total Sleep Sessions: {total_sleep_sessions:<30}│")
    print(f"├{'─' * 50}┤")
    print(f"│{'HAPPINESS METER':^50}│")
    print(f"├{'─' * 50}┤")
    
    # Create happiness bar
    bar_length = 40
    filled_length = int(bar_length * happiness / 100)
    bar = '█' * filled_length + '░' * (bar_length - filled_length)
    
    print(f"│ {bar} {happiness:.1f}% │")
    print(f"├{'─' * 50}┤")
    print(f"│{'NEEDS STATUS':^50}│")
    print(f"├{'─' * 50}┤")
    print(f"│ Last Fed: {format_time(hours_since_fed):<37}│")
    print(f"│ Last Petted: {format_time(hours_since_attention):<34}│")
    print(f"│ Last Sleep: {format_time(hours_since_sleep):<35}│")
    print(f"└{'─' * 50}┘")
    
    input("\nPress Enter to continue...")

# Function to get real time elapsed in hours
def get_hours_elapsed(start_time):
    seconds_elapsed = (datetime.datetime.now() - start_time).total_seconds()
    hours_elapsed = seconds_elapsed / 3600  # Convert seconds to hours
    return hours_elapsed

# Function to format time for display
def format_time(hours):
    full_hours = int(hours)
    minutes = int((hours - full_hours) * 60)
    return f"{full_hours}h {minutes}m"

# Function to save game state
def save_game(pet_name, pet_type, last_fed_time, last_attention_time, last_sleep_time, 
             start_time, sleep_start_time, last_insulted_time, angry_pet_counter, 
             total_feedings, total_pettings, total_insults, total_sleep_sessions,
             last_item_time=None, last_advice_time=None, last_question_time=None):
    save_data = {
        "pet_name": pet_name,
        "pet_type": pet_type,
        "last_fed_time": last_fed_time.isoformat(),
        "last_attention_time": last_attention_time.isoformat(),
        "last_sleep_time": last_sleep_time.isoformat(),
        "start_time": start_time.isoformat(),
        "sleep_start_time": sleep_start_time.isoformat() if sleep_start_time else None,
        "last_insulted_time": last_insulted_time.isoformat() if last_insulted_time else None,
        "angry_pet_counter": angry_pet_counter,
        "total_feedings": total_feedings,
        "total_pettings": total_pettings,
        "total_insults": total_insults,
        "total_sleep_sessions": total_sleep_sessions,
        # Random event timestamps
        "last_item_time": last_item_time.isoformat() if last_item_time else None,
        "last_advice_time": last_advice_time.isoformat() if last_advice_time else None,
        "last_question_time": last_question_time.isoformat() if last_question_time else None
    }
    try:
        with open(SAVE_FILE, 'w') as f:
            json.dump(save_data, f, indent=4)
        print("Game state saved.")
    except Exception as e:
        print(f"Error saving game: {e}")

# Function to load game state
def load_game():
    if os.path.exists(SAVE_FILE):
        try:
            with open(SAVE_FILE, 'r') as f:
                save_data = json.load(f)
            # Convert timestamp strings back to datetime objects
            save_data["last_fed_time"] = datetime.datetime.fromisoformat(save_data["last_fed_time"])
            save_data["last_attention_time"] = datetime.datetime.fromisoformat(save_data["last_attention_time"])
            save_data["last_sleep_time"] = datetime.datetime.fromisoformat(save_data["last_sleep_time"])
            save_data["start_time"] = datetime.datetime.fromisoformat(save_data["start_time"])
            
            if save_data["sleep_start_time"]:
                save_data["sleep_start_time"] = datetime.datetime.fromisoformat(save_data["sleep_start_time"])
            else:
                save_data["sleep_start_time"] = None
                
            # Handle last_insulted_time (might not exist in older save files)
            if "last_insulted_time" in save_data and save_data["last_insulted_time"]:
                save_data["last_insulted_time"] = datetime.datetime.fromisoformat(save_data["last_insulted_time"])
            else:
                save_data["last_insulted_time"] = None
                
            # Handle angry_pet_counter (might not exist in older save files)
            if "angry_pet_counter" not in save_data:
                save_data["angry_pet_counter"] = 0
                
            # Handle interaction counters (might not exist in older save files)
            if "total_feedings" not in save_data:
                save_data["total_feedings"] = 0
            if "total_pettings" not in save_data:
                save_data["total_pettings"] = 0
            if "total_insults" not in save_data:
                save_data["total_insults"] = 0
            if "total_sleep_sessions" not in save_data:
                save_data["total_sleep_sessions"] = 0
                
            print("Previous game state loaded.")
            return save_data
        except Exception as e:
            print(f"Error loading game: {e}. Starting a new game.")
            return None
    else:
        print("No save file found. Starting a new game.")
        return None

# Function to create a status info string for display
def get_status_info(pet_name, mood, hours_since_fed, hours_since_attention, hours_since_sleep, hours_spent_sleeping=None):
    info = f"{pet_name}'s mood: {mood.capitalize()}\n"
    info += f"Time since last fed: {format_time(hours_since_fed)}\n"
    info += f"Time since last attention: {format_time(hours_since_attention)}\n"
    info += f"Time since last sleep: {format_time(hours_since_sleep)}\n"
    
    # Show sleep progress if sleeping
    if mood == "sleeping" and hours_spent_sleeping is not None:
        sleep_progress = min(int((hours_spent_sleeping / 1.0) * 10), 10)  # Assuming SLEEP_DURATION=1
        info += f"Sleep progress: [{'#' * sleep_progress}{' ' * (10-sleep_progress)}] {int(hours_spent_sleeping * 60)}min/60min\n"
    
    return info

# Function to determine pet's mood based on needs
def determine_mood(hours_since_fed, hours_since_attention, hours_since_sleep, 
                  hours_since_mood_change, hours_since_insulted, angry_pet_counter,
                  old_mood, hours_spent_sleeping, HUNGER_THRESHOLD, ANGER_THRESHOLD, 
                  ATTENTION_THRESHOLD, SLEEP_THRESHOLD, HAPPINESS_DURATION, 
                  ANGER_DURATION, PETS_TO_CALM, SLEEP_DURATION):
    """
    Calculate the pet's mood based on all its needs.
    Returns the new mood.
    """
    # Priority order: Angry (from insult or hunger) > Hungry > Wants Attention > Sleepy > Happy > Idle
    if hours_since_insulted < ANGER_DURATION and angry_pet_counter < PETS_TO_CALM:
        mood = "angry"  # Recently insulted and not yet calmed by petting
    elif hours_since_fed > (HUNGER_THRESHOLD + ANGER_THRESHOLD):
        mood = "angry"  # Hungry for too long becomes angry
    elif hours_since_fed > HUNGER_THRESHOLD:
        mood = "hungry"
    elif hours_since_attention > ATTENTION_THRESHOLD:
        mood = "wants_attention"
    elif hours_since_sleep > SLEEP_THRESHOLD:
        mood = "sleepy"
    elif hours_since_mood_change < HAPPINESS_DURATION:
        mood = "happy"  # Happy for 30 minutes after interactions
    else:
        mood = "idle"
    
    # If sleeping, stay asleep until one hour has passed or there's an emergency (angry)
    if old_mood == "sleeping" and mood != "angry":
        if hours_spent_sleeping < SLEEP_DURATION:
            mood = "sleeping"
            
    return mood

# Random event functions
def handle_item_event(pet_name, pet_type):
    """Pet brings you a random item."""
    item = random.choice(items_list)
    if pet_type == "cat":
        return f"\n{pet_name} suddenly appears with {item} in their mouth and drops it at your feet.\n"
    else:  # dog
        return f"\n{pet_name} excitedly brings you {item} and wags their tail, looking proud.\n"

def handle_advice_event(pet_name, pet_type):
    """Pet gives weird advice."""
    advice = random.choice(advice_list)
    if pet_type == "cat":
        return f"\n{pet_name} looks at you with knowing eyes and somehow communicates:\n\"{advice}\"\n"
    else:  # dog
        return f"\n{pet_name} tilts their head thoughtfully and somehow you understand:\n\"{advice}\"\n"

def handle_question_event(pet_name, pet_type):
    """Pet asks an existential question."""
    question = random.choice(existential_questions)
    if pet_type == "cat":
        return f"\n{pet_name} stares intensely at you before asking:\n\"{question}\"\n"
    else:  # dog
        return f"\n{pet_name} looks up at you with curious eyes and seems to ask:\n\"{question}\"\n"

def check_random_events(pet_name, pet_type, last_item_time, last_advice_time, last_question_time):
    """Check if a random event should trigger and handle it."""
    current_time = datetime.datetime.now()
    minutes_since_last_check = 0
    event_message = None
    
    # Only check events with a small probability each minute
    if random.random() > EVENT_CHANCE_PER_MINUTE:
        return None, last_item_time, last_advice_time, last_question_time
    
    # Try to trigger an item event (max twice per day)
    if last_item_time is None or (current_time - last_item_time).total_seconds() > 12 * 3600:  # 12 hours
        # Additional randomness - only 20% chance when eligible
        if random.random() < 0.2:
            event_message = handle_item_event(pet_name, pet_type)
            last_item_time = current_time
    
    # Try to trigger an advice event (max 4 per hour)
    elif last_advice_time is None or (current_time - last_advice_time).total_seconds() > 15 * 60:  # 15 minutes
        # Additional randomness - only 15% chance when eligible
        if random.random() < 0.15:
            event_message = handle_advice_event(pet_name, pet_type)
            last_advice_time = current_time
    
    # Try to trigger a question event (max 4 per hour)
    elif last_question_time is None or (current_time - last_question_time).total_seconds() > 15 * 60:  # 15 minutes
        # Additional randomness - only 15% chance when eligible
        if random.random() < 0.15:
            event_message = handle_question_event(pet_name, pet_type)
            last_question_time = current_time
            
    return event_message, last_item_time, last_advice_time, last_question_time

# Main function
def main():
    global animation_enabled
    
    # Try to load game state
    loaded_data = load_game()
    time.sleep(1) # Pause to show load message

    if loaded_data:
        pet_name = loaded_data["pet_name"]
        pet_type = loaded_data["pet_type"]
        last_fed_time = loaded_data["last_fed_time"]
        last_attention_time = loaded_data["last_attention_time"]
        last_sleep_time = loaded_data["last_sleep_time"]
        start_time = loaded_data["start_time"]
        sleep_start_time = loaded_data["sleep_start_time"]
        # Handle last_insulted_time (might not exist in older save files)
        last_insulted_time = loaded_data.get("last_insulted_time", None)
        # Handle angry_pet_counter (might not exist in older save files)
        angry_pet_counter = loaded_data.get("angry_pet_counter", 0)
        # Handle interaction counters (might not exist in older save files)
        total_feedings = loaded_data.get("total_feedings", 0)
        total_pettings = loaded_data.get("total_pettings", 0)
        total_insults = loaded_data.get("total_insults", 0)
        total_sleep_sessions = loaded_data.get("total_sleep_sessions", 0)
        # Load random event timestamps (convert from string to datetime if they exist)
        if "last_item_time" in loaded_data and loaded_data["last_item_time"]:
            last_item_time = datetime.datetime.fromisoformat(loaded_data["last_item_time"])
        else:
            last_item_time = None
        if "last_advice_time" in loaded_data and loaded_data["last_advice_time"]:
            last_advice_time = datetime.datetime.fromisoformat(loaded_data["last_advice_time"])
        else:
            last_advice_time = None
        if "last_question_time" in loaded_data and loaded_data["last_question_time"]:
            last_question_time = datetime.datetime.fromisoformat(loaded_data["last_question_time"])
        else:
            last_question_time = None
        print(f"Welcome back to {pet_name}!")
        time.sleep(1)
    else:
        # Clear screen and show welcome message for new game
        clear_screen()
        print("Welcome to ASCII Pet!")
        print("====================\n")
        
        # Pet selection
        while True:
            print("What kind of pet would you like?")
            print("1. Cat")
            print("2. Dog")
            choice = input("> ")
            if choice == "1":
                pet_type = "cat"
                print("\nYou've chosen a cat!")
                break
            elif choice == "2":
                pet_type = "dog"
                print("\nYou've chosen a dog!")
                break
            else:
                print("Invalid choice. Please select 1 for Cat or 2 for Dog.")
        
        pet_name = input("\nGive your ASCII pet a name: ")
        # Initialize timers for new game
        last_fed_time = datetime.datetime.now()
        last_attention_time = datetime.datetime.now()
        last_sleep_time = datetime.datetime.now()
        start_time = datetime.datetime.now()
        sleep_start_time = None
        last_insulted_time = None
        angry_pet_counter = 0
        last_item_time = None
        last_advice_time = None
        last_question_time = None
        print(f"\nYour new pet {pet_name} is here!")
        time.sleep(1)

    mood = "idle" # Mood is determined dynamically each loop
    running = True
    last_mood_change_time = datetime.datetime.now() # Reset mood change timer on load/start
    
    # Constants for time thresholds (in real hours)
    HUNGER_THRESHOLD = 26  # Gets hungry after 26 hours
    ANGER_THRESHOLD = 3    # Gets angry after 3 more hours without food
    SLEEP_THRESHOLD = 1    # Gets sleepy every hour
    SLEEP_DURATION = 1     # Pet sleeps for 1 hour before waking up
    ATTENTION_THRESHOLD = 6  # Wants attention every 6 hours
    HAPPINESS_DURATION = 0.5  # Happy for 30 minutes after interactions
    ANGER_DURATION = 0.25  # Stays angry for 15 minutes after being insulted
    PETS_TO_CALM = 2       # Number of pets needed to calm an angry pet
    
    # Initialize interaction counters
    total_feedings = 0
    total_pettings = 0
    total_insults = 0
    total_sleep_sessions = 0
    
    # Initialize animation system
    animation_thread = threading.Thread(target=animation_timer)
    animation_thread.daemon = True  # Thread will close when main program exits

    # Try-finally block to ensure animation thread is properly handled
    try:
        # Start animation thread
        animation_enabled = True
        animation_thread.start()
        
        while running:
            # Calculate elapsed times
            hours_since_fed = get_hours_elapsed(last_fed_time)
            hours_since_attention = get_hours_elapsed(last_attention_time)
            hours_since_sleep = get_hours_elapsed(last_sleep_time)
            hours_since_mood_change = get_hours_elapsed(last_mood_change_time)
            total_hours_alive = get_hours_elapsed(start_time)
            
            # Calculate time spent sleeping if currently sleeping
            hours_spent_sleeping = 0
            if sleep_start_time is not None:
                hours_spent_sleeping = get_hours_elapsed(sleep_start_time)
                
            # Calculate time since last insult
            hours_since_insulted = float('inf')  # Initialize with infinity
            if last_insulted_time is not None:
                hours_since_insulted = get_hours_elapsed(last_insulted_time)
    
            # Determine mood based on needs
            old_mood = mood
            
            mood = determine_mood(hours_since_fed, hours_since_attention, hours_since_sleep, 
                                  hours_since_mood_change, hours_since_insulted, angry_pet_counter,
                                  old_mood, hours_spent_sleeping, HUNGER_THRESHOLD, ANGER_THRESHOLD, 
                                  ATTENTION_THRESHOLD, SLEEP_THRESHOLD, HAPPINESS_DURATION, 
                                  ANGER_DURATION, PETS_TO_CALM, SLEEP_DURATION)
            
            # If sleeping, stay asleep until one hour has passed or there's an emergency (angry)
            if old_mood == "sleeping" and mood != "angry":
                if hours_spent_sleeping < SLEEP_DURATION:
                    mood = "sleeping"
                else:
                    # Pet wakes up after sleeping for one hour
                    show_pet(mood, pet_type)  # Show pet before message
                    print(f"{pet_name} has woken up after a good nap!")
                    sleep_start_time = None
                    time.sleep(1)
                
            # Update mood change time if mood changed
            if old_mood != mood:
                last_mood_change_time = datetime.datetime.now()
                # Reset the angry pet counter if the pet is no longer angry
                if old_mood == "angry" and mood != "angry":
                    angry_pet_counter = 0
            
            # Create status information
            status_info = get_status_info(
                pet_name, mood, hours_since_fed, hours_since_attention, 
                hours_since_sleep, hours_spent_sleeping if mood == "sleeping" else None
            )
            
            # Check for random events
            event_message, last_item_time, last_advice_time, last_question_time = check_random_events(
                pet_name, pet_type, last_item_time, last_advice_time, last_question_time
            )
            
            # Display pet with animation and get user choice
            choice = display_menu_with_animation(mood, pet_type, status_info)
            
            # Show random event after displaying the pet but before processing input
            if event_message:
                clear_screen()
                show_pet(mood, pet_type)
                print(status_info)
                print(event_message)
                input("\nPress Enter to continue...")
            
            if choice == '1':  # Feed
                if mood == "hungry" or mood == "angry":
                    print(f"You feed {pet_name} a tasty treat! They're no longer hungry.")
                    last_fed_time = datetime.datetime.now()
                    last_mood_change_time = datetime.datetime.now()
                    # Only clear anger if it was from hunger, not from insult
                    if hours_since_insulted > ANGER_DURATION or angry_pet_counter >= PETS_TO_CALM:
                        mood = "happy"
                else:
                    print(f"{pet_name} isn't hungry right now, but eats a little anyway.")
                    # Still reset the feed timer since we fed them
                    last_fed_time = datetime.datetime.now()
                if mood == "sleeping":
                    print(f"{pet_name} wakes up to eat!")
                    sleep_start_time = None  # Pet is no longer sleeping
                total_feedings += 1
                time.sleep(1)
                
            elif choice == '2':  # Pet
                if mood == "sleeping":
                    print(f"You gently pet {pet_name} while they sleep. They stir a little but continue sleeping.")
                elif mood == "wants_attention":
                    print(f"You pet {pet_name} and they're very grateful!")
                    last_attention_time = datetime.datetime.now()
                    last_mood_change_time = datetime.datetime.now()
                    mood = "happy"
                elif mood == "angry" and hours_since_insulted < ANGER_DURATION:
                    angry_pet_counter += 1
                    if angry_pet_counter >= PETS_TO_CALM:
                        print(f"You pet {pet_name} gently. They seem to be calming down...")
                        print(f"Your persistence paid off! {pet_name} is no longer angry.")
                        last_attention_time = datetime.datetime.now()
                        last_mood_change_time = datetime.datetime.now()
                        mood = "happy"
                        last_insulted_time = None  # Clear the insult timer
                    else:
                        print(f"You try to pet {pet_name}. They're still upset, but seem to be softening a little.")
                        last_attention_time = datetime.datetime.now()
                else:
                    print(f"You pet {pet_name} gently.")
                    last_attention_time = datetime.datetime.now()
                total_pettings += 1
                time.sleep(1)
                
            elif choice == '3':  # Insult
                print(f"You said something mean to {pet_name}!")
                if mood == "sleeping":
                    print(f"{pet_name} wakes up, startled!")
                    sleep_start_time = None  # Pet is no longer sleeping
                mood = "angry"
                last_mood_change_time = datetime.datetime.now()
                last_insulted_time = datetime.datetime.now()  # Set the insult timer
                angry_pet_counter = 0  # Reset the pet counter when newly insulted
                total_insults += 1
                time.sleep(1)
                
            elif choice == '4':  # Rest
                if mood == "sleepy":
                    print(f"{pet_name} was tired and is now sleeping soundly.")
                    print(f"They will sleep for {SLEEP_DURATION} hour(s) before waking up.")
                    mood = "sleeping"
                    sleep_start_time = datetime.datetime.now()  # Start tracking sleep time
                    last_sleep_time = datetime.datetime.now()
                    total_sleep_sessions += 1
                elif mood == "sleeping":
                    print(f"{pet_name} continues to sleep peacefully.")
                    print(f"Sleep time remaining: {format_time(max(0, SLEEP_DURATION - hours_spent_sleeping))}")
                else:
                    print(f"{pet_name} isn't tired, but rests a little anyway.")
                    last_sleep_time = datetime.datetime.now()
                time.sleep(1)
                
            elif choice == '5':  # Check status
                animation_enabled = False  # Pause animations during status display
                print(f"\n{pet_name}'s Status:")
                print(f"Mood: {mood.capitalize()}")
                print(f"Hunger: {'Hungry!' if hours_since_fed > HUNGER_THRESHOLD else 'OK'}")
                print(f"Attention: {'Needs attention!' if hours_since_attention > ATTENTION_THRESHOLD else 'OK'}")
                print(f"Energy: {'Tired!' if hours_since_sleep > SLEEP_THRESHOLD and mood != 'sleeping' else 'OK'}")
                
                if mood == "angry" and hours_since_insulted < ANGER_DURATION:
                    minutes_left = int((ANGER_DURATION - hours_since_insulted) * 60)
                    print(f"Angry: {pet_name} is upset from being insulted.")
                    if angry_pet_counter > 0:
                        print(f"You've petted them {angry_pet_counter}/{PETS_TO_CALM} times. Keep trying to calm them down!")
                    else:
                        print(f"Try petting them {PETS_TO_CALM} times to calm them down, or wait about {minutes_left} minutes.")
                    
                if mood == "sleeping":
                    print(f"Sleeping: {int(hours_spent_sleeping * 60)}/{int(SLEEP_DURATION * 60)} minutes")
                    
                if hours_since_fed > HUNGER_THRESHOLD:
                    if hours_since_fed > (HUNGER_THRESHOLD + ANGER_THRESHOLD):
                        print(f"{pet_name} is VERY hungry and becoming upset!")
                    else:
                        print(f"{pet_name} is hungry and should be fed soon.")
                        
                input("\nPress Enter to continue...")
                animation_enabled = True  # Resume animations
                
            elif choice == '6':  # View dashboard
                animation_enabled = False  # Pause animations during dashboard view
                display_dashboard(pet_name, pet_type, mood, total_feedings, total_pettings, total_insults, 
                                  total_sleep_sessions, hours_since_fed, hours_since_attention, 
                                  hours_since_sleep, total_hours_alive)
                animation_enabled = True  # Resume animations
                
            elif choice == '7':  # Exit
                animation_enabled = False  # Stop animations before exiting
                clear_screen()
                # Save game state before exiting
                save_game(pet_name, pet_type, last_fed_time, last_attention_time, last_sleep_time, 
                         start_time, sleep_start_time, last_insulted_time, angry_pet_counter,
                         total_feedings, total_pettings, total_insults, total_sleep_sessions,
                         last_item_time, last_advice_time, last_question_time)
                print(f"Goodbye! {pet_name} will miss you!")
                total_hours_alive = get_hours_elapsed(start_time)
                print(f"You've taken care of {pet_name} for {format_time(total_hours_alive)}.")
                running = False
                
            else:
                print("Invalid choice. Try again.")
                time.sleep(1)
                
    finally:
        # Ensure animation is turned off when exiting
        animation_enabled = False

if __name__ == "__main__":
    main()
