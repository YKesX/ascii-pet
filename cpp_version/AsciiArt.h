#pragma once
#include <vector>
#include <string>
#include <map>

// Cat ASCII art for different moods with animation variants
namespace CatArt {
    // Idle cat animations (blinking, shifting, normal)
    const std::vector<std::string> idle = {
        R"(
    /\_/\  
   ( o.o ) 
    > ^ <  
   Idle...
)",
        R"(
    /\_/\  
   ( -.- ) 
    > ^ <  
   Idle...
)",
        R"(
    /\_/\  
   ( o.o ) 
    > ~ <  
   Idle...
)"
    };

    // Happy cat animations
    const std::vector<std::string> happy = {
        R"(
    /\_/\  
   ( ^ᴗ^ ) 
    > ~ <  
   Happy!
)",
        R"(
    /\_/\  
   ( ^-^ ) 
    > ~ <  
   Happy!
)",
        R"(
    /\_/\  
   ( ^ᴗ^ ) 
    > ^-^ <  
   Happy!
)"
    };

    // Angry cat animations
    const std::vector<std::string> angry = {
        R"(
    /\_/\  
   ( ÒᴗÓ )
    > ! <  
   Angry!
)",
        R"(
    /\_/\  
   ( Ò-Ó )
    > ! <  
   Angry!
)",
        R"(
    /\_/\  
   ( ÒᴗÓ )
    > !!! <  
   Angry!
)"
    };

    // Sleepy cat animations
    const std::vector<std::string> sleepy = {
        R"(
    /\_/\  
   ( -.- ) 
    > z <  
   Sleepy...
)",
        R"(
    /\_/\  
   ( -.o ) 
    > z <  
   Sleepy...
)",
        R"(
    /\_/\  
   ( -.- ) 
    > z.. <  
   Sleepy...
)"
    };

    // Sleeping cat animations
    const std::vector<std::string> sleeping = {
        R"(
    /\_/\  
   ( -.- ) zZzZ
    > z <  
   Sleeping...
)",
        R"(
    /\_/\  
   ( -.- ) zZ
    > z <  
   Sleeping...
)",
        R"(
    /\_/\  
   ( -.- ) zZzZz
    > z <  
   Sleeping...
)"
    };

    // Hungry cat animations
    const std::vector<std::string> hungry = {
        R"(
    /\_/\  
   ( o.o ) 
    > ◊ <  
   Hungry...
)",
        R"(
    /\_/\  
   ( o.o ) 
    > ◊◊ <  
   Hungry...
)",
        R"(
    /\_/\  
   ( o_o ) 
    > ◊ <  
   Hungry...
)"
    };

    // Wants attention cat animations
    const std::vector<std::string> wants_attention = {
        R"(
    /\_/\  
   ( o.o ) 
    > ? <  
   Needs attention!
)",
        R"(
    /\_/\  
   ( o_o ) 
    > ? <  
   Needs attention!
)",
        R"(
    /\_/\  
   ( o.o ) 
    > ?? <  
   Needs attention!
)"
    };
}

// Dog ASCII art for different moods with animation variants
namespace DogArt {
    // Idle dog animations
    const std::vector<std::string> idle = {
        R"(
    /^ ^\
   / o o \
   V\ Y /V
    / - \
   /    |
  V__) ||
   Idle...
)",
        R"(
    /^ ^\
   / - - \
   V\ Y /V
    / - \
   /    |
  V__) ||
   Idle...
)",
        R"(
    /^ ^\
   / o o \
   V\ Y /V
    / ~ \
   /    |
  V__) ||
   Idle...
)"
    };

    // Happy dog animations
    const std::vector<std::string> happy = {
        R"(
    /^ ^\
   / ^v^ \
   V\ Y /V
    / ~ \
   /    |
  V__) || 
   Happy!
)",
        R"(
    /^ ^\
   / ^-^ \
   V\ Y /V
    / ~ \
   /    |
  V__) || 
   Happy!
)",
        R"(
    /^ ^\
   / ^v^ \
    V\ Y /V
    / ~~ \
   /    |
  V__) || 
   Happy!
)"
    };

    // Angry dog animations
    const std::vector<std::string> angry = {
        R"(
    /^ ^\
   / ÒvÓ \
   V\ Y /V
    / ! \
   /    |
  V__) || 
   Angry!
)",
        R"(
    /^ ^\
   / Ò-Ó \
   V\ Y /V
    / ! \
   /    |
  V__) || 
   Angry!
)",
        R"(
    /^ ^\
   / ÒvÓ \
   V\ Y /V
    / !!! \
   /    |
  V__) || 
   Angry!
)"
    };

    // Sleepy dog animations
    const std::vector<std::string> sleepy = {
        R"(
    /^ ^\
   / -.- \
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleepy...
)",
        R"(
    /^ ^\
   / -.o \
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleepy...
)",
        R"(
    /^ ^\
   / -.- \
   V\ Y /V
    / z.. \
   /    |
  V__) || 
   Sleepy...
)"
    };

    // Sleeping dog animations
    const std::vector<std::string> sleeping = {
        R"(
    /^ ^\
   / -.- \ zZzZ
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleeping...
)",
        R"(
    /^ ^\
   / -.- \ zZ
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleeping...
)",
        R"(
    /^ ^\
   / -.- \ zZzZz
   V\ Y /V
    / z \
   /    |
  V__) || 
   Sleeping...
)"
    };

    // Hungry dog animations
    const std::vector<std::string> hungry = {
        R"(
    /^ ^\
   / o o \
   V\ Y /V
    / ◊ \
   /    |
  V__) || 
   Hungry...
)",
        R"(
    /^ ^\
   / o_o \
   V\ Y /V
    / ◊ \
   /    |
  V__) || 
   Hungry...
)",
        R"(
    /^ ^\
   / o o \
   V\ Y /V
    / ◊◊ \
   /    |
  V__) || 
   Hungry...
)"
    };

    // Wants attention dog animations
    const std::vector<std::string> wants_attention = {
        R"(
    /^ ^\
   / o o \
   V\ Y /V
    / ? \
   /    |
  V__) || 
   Needs attention!
)",
        R"(
    /^ ^\
   / o_o \
   V\ Y /V
    / ? \
   /    |
  V__) || 
   Needs attention!
)",
        R"(
    /^ ^\
   / o o \
   V\ Y /V
    / ?? \
   /    |
  V__) || 
   Needs attention!
)"
    };
}

// Art lookup helper function
const std::vector<std::string>& getArtSet(const std::string& mood, const std::string& petType) {
    static std::map<std::string, std::map<std::string, const std::vector<std::string>&>> artSets = {
        {"cat", {
            {"idle", CatArt::idle},
            {"happy", CatArt::happy},
            {"angry", CatArt::angry},
            {"sleepy", CatArt::sleepy},
            {"sleeping", CatArt::sleeping},
            {"hungry", CatArt::hungry},
            {"wants_attention", CatArt::wants_attention}
        }},
        {"dog", {
            {"idle", DogArt::idle},
            {"happy", DogArt::happy},
            {"angry", DogArt::angry},
            {"sleepy", DogArt::sleepy},
            {"sleeping", DogArt::sleeping},
            {"hungry", DogArt::hungry},
            {"wants_attention", DogArt::wants_attention}
        }}
    };

    // Return the appropriate art set or default to idle if mood not found
    try {
        return artSets.at(petType).at(mood);
    } catch (const std::out_of_range&) {
        return petType == "cat" ? CatArt::idle : DogArt::idle;
    }
}
