#pragma once
#include <vector>
#include <string>
#include <random>
#include <chrono>

// Random event lists
namespace RandomEvents {
    // Items the pet can bring
    const std::vector<std::string> items = {
        "a shiny coin", "a small toy mouse", "a colorful feather", "a rubber band",
        "a bottlecap", "a small piece of paper", "a mysterious key", "a button",
        "a paperclip", "a tiny plushie", "a lost sock", "a shiny rock",
        "a piece of string", "a candy wrapper", "a forgotten hair tie",
        "a puzzle piece", "a tiny figurine", "a leaf", "a flower petal",
        "a small ball", "a pencil stub", "a piece of yarn", "a sticker",
        "a forgotten sticky note", "a tiny book", "a small piece of cloth",
        "a bit of ribbon", "a plastic gem", "a bottle cork", "a small shell"
    };

    // Weird advice the pet can give
    const std::vector<std::string> advice = {
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
    };

    // Existential questions the pet can ask
    const std::vector<std::string> questions = {
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
    };

    // Random number generator
    static std::random_device rd;
    static std::mt19937 gen(rd());

    // Get a random element from a vector
    template <typename T>
    const T& getRandomElement(const std::vector<T>& vec) {
        std::uniform_int_distribution<> distrib(0, vec.size() - 1);
        return vec[distrib(gen)];
    }

    // Random event handler functions
    std::string handleItemEvent(const std::string& petName, const std::string& petType) {
        std::string item = getRandomElement(items);
        if (petType == "cat") {
            return "\n" + petName + " suddenly appears with " + item + " in their mouth and drops it at your feet.\n";
        } else { // dog
            return "\n" + petName + " excitedly brings you " + item + " and wags their tail, looking proud.\n";
        }
    }

    std::string handleAdviceEvent(const std::string& petName, const std::string& petType) {
        std::string adviceText = getRandomElement(advice);
        if (petType == "cat") {
            return "\n" + petName + " looks at you with knowing eyes and somehow communicates:\n\"" + adviceText + "\"\n";
        } else { // dog
            return "\n" + petName + " tilts their head thoughtfully and somehow you understand:\n\"" + adviceText + "\"\n";
        }
    }

    std::string handleQuestionEvent(const std::string& petName, const std::string& petType) {
        std::string question = getRandomElement(questions);
        if (petType == "cat") {
            return "\n" + petName + " stares intensely at you before asking:\n\"" + question + "\"\n";
        } else { // dog
            return "\n" + petName + " looks up at you with curious eyes and seems to ask:\n\"" + question + "\"\n";
        }
    }

    // Check if a random event should trigger
    std::tuple<std::string, std::chrono::system_clock::time_point*, std::chrono::system_clock::time_point*, std::chrono::system_clock::time_point*> 
    checkRandomEvents(
        const std::string& petName, const std::string& petType,
        std::chrono::system_clock::time_point* lastItemTime,
        std::chrono::system_clock::time_point* lastAdviceTime,
        std::chrono::system_clock::time_point* lastQuestionTime
    ) {
        auto currentTime = std::chrono::system_clock::now();
        std::string eventMessage;
        
        // Only check events with a small probability each minute
        std::uniform_real_distribution<> eventChance(0.0, 1.0);
        if (eventChance(gen) > EVENT_CHANCE_PER_MINUTE) {
            return {eventMessage, lastItemTime, lastAdviceTime, lastQuestionTime};
        }
        
        // Try to trigger an item event (max twice per day)
        if (!lastItemTime || std::chrono::duration<double>(currentTime - *lastItemTime).count() > 12 * 3600) { // 12 hours
            // Additional randomness - only 20% chance when eligible
            if (eventChance(gen) < 0.2) {
                eventMessage = handleItemEvent(petName, petType);
                if (!lastItemTime) {
                    lastItemTime = new std::chrono::system_clock::time_point(currentTime);
                } else {
                    *lastItemTime = currentTime;
                }
            }
        }
        // Try to trigger an advice event (max 4 per hour)
        else if (!lastAdviceTime || std::chrono::duration<double>(currentTime - *lastAdviceTime).count() > 15 * 60) { // 15 minutes
            // Additional randomness - only 15% chance when eligible
            if (eventChance(gen) < 0.15) {
                eventMessage = handleAdviceEvent(petName, petType);
                if (!lastAdviceTime) {
                    lastAdviceTime = new std::chrono::system_clock::time_point(currentTime);
                } else {
                    *lastAdviceTime = currentTime;
                }
            }
        }
        // Try to trigger a question event (max 4 per hour)
        else if (!lastQuestionTime || std::chrono::duration<double>(currentTime - *lastQuestionTime).count() > 15 * 60) { // 15 minutes
            // Additional randomness - only 15% chance when eligible
            if (eventChance(gen) < 0.15) {
                eventMessage = handleQuestionEvent(petName, petType);
                if (!lastQuestionTime) {
                    lastQuestionTime = new std::chrono::system_clock::time_point(currentTime);
                } else {
                    *lastQuestionTime = currentTime;
                }
            }
        }
        
        return {eventMessage, lastItemTime, lastAdviceTime, lastQuestionTime};
    }
}