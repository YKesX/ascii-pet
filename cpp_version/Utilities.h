#pragma once
#include <string>
#include <iostream>
#include <chrono>
#include <thread>
#include <cmath>
#include <iomanip>
#include <sstream>
#include <random>

// Cross-platform utilities and helper functions
namespace Utilities {
    // Clear the console screen
    void clearScreen() {
    #ifdef _WIN32
        system("cls");
    #else
        system("clear");
    #endif
    }

    // Format hours as readable time
    std::string formatTime(double hours) {
        if (hours < 0.0) {
            return "Just now";
        }
        
        if (hours < 1.0/60.0) { // Less than a minute
            return "Just now";
        } else if (hours < 1.0) { // Less than an hour
            int minutes = static_cast<int>(hours * 60.0);
            return std::to_string(minutes) + " minute" + (minutes != 1 ? "s" : "");
        } else if (hours < 24.0) { // Less than a day
            int wholeHours = static_cast<int>(hours);
            int minutes = static_cast<int>((hours - wholeHours) * 60.0);
            std::string result = std::to_string(wholeHours) + " hour" + (wholeHours != 1 ? "s" : "");
            if (minutes > 0) {
                result += " " + std::to_string(minutes) + " minute" + (minutes != 1 ? "s" : "");
            }
            return result;
        } else { // Days or more
            int days = static_cast<int>(hours / 24.0);
            int wholeHours = static_cast<int>(hours) % 24;
            std::string result = std::to_string(days) + " day" + (days != 1 ? "s" : "");
            if (wholeHours > 0) {
                result += " " + std::to_string(wholeHours) + " hour" + (wholeHours != 1 ? "s" : "");
            }
            return result;
        }
    }

    // Get hours elapsed since given time point
    double getHoursElapsed(const std::chrono::system_clock::time_point& startTime) {
        auto now = std::chrono::system_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::seconds>(now - startTime);
        return static_cast<double>(duration.count()) / 3600.0; // Convert seconds to hours
    }

    // Convert a time_point to a string timestamp (for saving)
    std::string timePointToString(const std::chrono::system_clock::time_point& timePoint) {
        // Convert time_point to time_t
        std::time_t time = std::chrono::system_clock::to_time_t(timePoint);
        
        // Convert time_t to string
        std::stringstream ss;
        ss << std::put_time(std::localtime(&time), "%Y-%m-%d %H:%M:%S");
        
        // Get milliseconds
        auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
            timePoint.time_since_epoch() % std::chrono::seconds(1));
        
        // Add milliseconds to string
        ss << '.' << std::setfill('0') << std::setw(3) << ms.count();
        
        return ss.str();
    }

    // Convert a timestamp string back to a time_point
    std::chrono::system_clock::time_point stringToTimePoint(const std::string& timeStr) {
        std::tm tm = {};
        std::string dateTimeStr = timeStr.substr(0, timeStr.find('.'));
        std::istringstream ss(dateTimeStr);
        ss >> std::get_time(&tm, "%Y-%m-%d %H:%M:%S");
        
        auto timePoint = std::chrono::system_clock::from_time_t(std::mktime(&tm));
        
        // Extract milliseconds if available
        size_t msPos = timeStr.find('.');
        if (msPos != std::string::npos) {
            int ms = std::stoi(timeStr.substr(msPos + 1, 3));
            timePoint += std::chrono::milliseconds(ms);
        }
        
        return timePoint;
    }

    // Convert a time_point to a string representation
    std::string timePointToString(const std::chrono::system_clock::time_point& tp) {
        auto time = std::chrono::system_clock::to_time_t(tp);
        std::stringstream ss;
        ss << std::put_time(std::localtime(&time), "%Y-%m-%d %H:%M:%S");
        return ss.str();
    }

    // Convert a string representation back to a time_point
    std::chrono::system_clock::time_point stringToTimePoint(const std::string& str) {
        std::tm tm = {};
        std::stringstream ss(str);
        ss >> std::get_time(&tm, "%Y-%m-%d %H:%M:%S");
        auto time = std::mktime(&tm);
        return std::chrono::system_clock::from_time_t(time);
    }

    // Generate a random number between min and max (inclusive)
    int getRandomNumber(int min, int max) {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        std::uniform_int_distribution<> distrib(min, max);
        return distrib(gen);
    }

    // Check if an event should occur with the given probability
    bool shouldEventOccur(double probability) {
        static std::random_device rd;
        static std::mt19937 gen(rd());
        std::uniform_real_distribution<> distrib(0.0, 1.0);
        return distrib(gen) < probability;
    }

    // Get a random element from a vector
    template<typename T>
    const T& getRandomElement(const std::vector<T>& vec) {
        int index = getRandomNumber(0, static_cast<int>(vec.size()) - 1);
        return vec[index];
    }

    // Get a character input without waiting for Enter key
    char getCharInput() {
    #ifdef _WIN32
        return _getch();
    #else
        char ch;
        struct termios oldT, newT;
        tcgetattr(STDIN_FILENO, &oldT);
        newT = oldT;
        newT.c_lflag &= ~(ICANON | ECHO);
        tcsetattr(STDIN_FILENO, TCSANOW, &newT);
        ch = getchar();
        tcsetattr(STDIN_FILENO, TCSANOW, &oldT);
        return ch;
    #endif
    }

    // Check if keyboard input is available
    bool kbhit() {
    #ifdef _WIN32
        return _kbhit() != 0;
    #else
        struct termios oldt, newt;
        int ch;
        int oldf;
        
        tcgetattr(STDIN_FILENO, &oldt);
        newt = oldt;
        newt.c_lflag &= ~(ICANON | ECHO);
        tcsetattr(STDIN_FILENO, TCSANOW, &newt);
        oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
        fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
        
        ch = getchar();
        
        tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
        fcntl(STDIN_FILENO, F_SETFL, oldf);
        
        if(ch != EOF) {
            ungetc(ch, stdin);
            return true;
        }
        
        return false;
    #endif
    }

    // Get status info text
    std::string getStatusInfo(
        const std::string& petName, const std::string& mood,
        double hoursSinceFed, double hoursSinceAttention,
        double hoursSinceSleep, double hoursSpentSleeping = -1.0
    ) {
        std::string status = "Name: " + petName + " | Mood: " + mood +
            "\nLast Fed: " + formatTime(hoursSinceFed) + " ago" +
            "\nLast Attention: " + formatTime(hoursSinceAttention) + " ago" +
            "\nLast Sleep: " + formatTime(hoursSinceSleep) + " ago";
            
        if (mood == "sleeping" && hoursSpentSleeping >= 0) {
            status += "\nCurrently sleeping for: " + formatTime(hoursSpentSleeping);
        }
        
        return status;
    }
}
