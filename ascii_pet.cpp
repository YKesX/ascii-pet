// ASCII Pet C++ Implementation
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <chrono>
#include <thread>
#include <random>
#include <fstream>
#include <ctime>
#include <algorithm>

#ifdef _WIN32
#include <windows.h>
#include <conio.h>
#else
#include <unistd.h>
#include <termios.h>
#include <sys/select.h>
#include <sys/ioctl.h>
#endif

// Forward declarations
void clearScreen();
void showPet(const std::string& mood, const std::string& petType, int animationFrame);
std::string getStatusInfo(const std::string& petName, const std::string& mood, 
                         double hoursSinceFed, double hoursSinceAttention, 
                         double hoursSinceSleep, double hoursSpentSleeping = -1.0);
std::string formatTime(double hours);
double getHoursElapsed(const std::chrono::system_clock::time_point& startTime);
bool saveGame(const std::string& petName, const std::string& petType,
             const std::chrono::system_clock::time_point& lastFedTime, 
             const std::chrono::system_clock::time_point& lastAttentionTime, 
             const std::chrono::system_clock::time_point& lastSleepTime,
             const std::chrono::system_clock::time_point& startTime,
             const std::chrono::system_clock::time_point* sleepStartTime,
             const std::chrono::system_clock::time_point* lastInsultedTime,
             int angryPetCounter, int totalFeedings, int totalPettings,
             int totalInsults, int totalSleepSessions,
             const std::chrono::system_clock::time_point* lastItemTime,
             const std::chrono::system_clock::time_point* lastAdviceTime,
             const std::chrono::system_clock::time_point* lastQuestionTime);

// Global constants
const std::string SAVE_FILE = "pet_save_cpp.json";
const double ANIMATION_INTERVAL = 2.0; // seconds between animation frames
const double HUNGER_THRESHOLD = 26.0;  // Gets hungry after 26 hours
const double ANGER_THRESHOLD = 3.0;    // Gets angry after 3 more hours without food
const double SLEEP_THRESHOLD = 1.0;    // Gets sleepy every hour
const double SLEEP_DURATION = 1.0;     // Pet sleeps for 1 hour before waking up
const double ATTENTION_THRESHOLD = 6.0;  // Wants attention every 6 hours
const double HAPPINESS_DURATION = 0.5;  // Happy for 30 minutes after interactions
const double ANGER_DURATION = 0.25;    // Stays angry for 15 minutes after being insulted
const int PETS_TO_CALM = 2;           // Number of pets needed to calm an angry pet

// Random event constants
const double EVENT_CHANCE_PER_MINUTE = 0.1;   // 10% chance per minute to trigger any event
const int ITEM_EVENT_DAILY_LIMIT = 2;         // Maximum of 2 item events per day
const int ADVICE_EVENT_HOURLY_LIMIT = 4;      // Maximum of 4 advice events per hour
const int QUESTION_EVENT_HOURLY_LIMIT = 4;    // Maximum of 4 question events per hour

// Global variables for animation
bool animationEnabled = true;
int animationFrame = 0;

// Include all the ASCII art, event lists, and utility functions
#include "AsciiArt.h"
#include "RandomEvents.h"
#include "Utilities.h"
#include "JSONHelpers.h"