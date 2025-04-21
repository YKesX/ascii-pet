#pragma once
#include <string>
#include <fstream>
#include <sstream>
#include <chrono>
#include <map>
#include "Utilities.h"

// Simple JSON helper class without external dependencies
class SimpleJSON {
private:
    std::map<std::string, std::string> values;

public:
    // Set a value in the JSON object
    void set(const std::string& key, const std::string& value) {
        values[key] = value;
    }

    // Set an integer value
    void set(const std::string& key, int value) {
        values[key] = std::to_string(value);
    }

    // Get a string value (with default)
    std::string getString(const std::string& key, const std::string& defaultValue = "") const {
        auto it = values.find(key);
        if (it != values.end()) {
            return it->second;
        }
        return defaultValue;
    }

    // Get an integer value (with default)
    int getInt(const std::string& key, int defaultValue = 0) const {
        auto it = values.find(key);
        if (it != values.end()) {
            try {
                return std::stoi(it->second);
            } catch (...) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    // Serialize to a string
    std::string dump() const {
        std::stringstream ss;
        ss << "{\n";
        
        bool first = true;
        for (const auto& pair : values) {
            if (!first) {
                ss << ",\n";
            } else {
                first = false;
            }
            
            ss << "  \"" << escapeJSON(pair.first) << "\": \"" << escapeJSON(pair.second) << "\"";
        }
        
        ss << "\n}";
        return ss.str();
    }

    // Parse a JSON string
    bool parse(const std::string& jsonString) {
        values.clear();
        
        try {
            std::string json = jsonString;
            // Remove whitespace
            json.erase(std::remove_if(json.begin(), json.end(), 
                                    [](unsigned char c) { return std::isspace(c) && c != ' '; }), 
                     json.end());
            
            // Basic validation
            if (json.size() < 2 || json.front() != '{' || json.back() != '}') {
                return false;
            }
            
            // Remove the outer braces
            json = json.substr(1, json.size() - 2);
            
            // Split by commas (not inside quotes)
            size_t pos = 0;
            bool inQuotes = false;
            std::string token;
            
            for (size_t i = 0; i < json.size(); ++i) {
                char c = json[i];
                
                if (c == '\"' && (i == 0 || json[i-1] != '\\')) {
                    inQuotes = !inQuotes;
                }
                
                if (c == ',' && !inQuotes) {
                    // Process the key-value pair
                    std::string pair = json.substr(pos, i - pos);
                    parseKeyValuePair(pair);
                    pos = i + 1;
                }
            }
            
            // Process the last key-value pair
            if (pos < json.size()) {
                std::string pair = json.substr(pos);
                parseKeyValuePair(pair);
            }
            
            return true;
        } catch (...) {
            return false;
        }
    }

private:
    // Parse a key-value pair
    void parseKeyValuePair(const std::string& pair) {
        size_t colonPos = pair.find(':');
        if (colonPos == std::string::npos) return;
        
        // Extract key
        std::string key = pair.substr(0, colonPos);
        key = trimQuotes(trim(key));
        
        // Extract value
        std::string value = pair.substr(colonPos + 1);
        value = trimQuotes(trim(value));
        
        // Store the key-value pair
        values[key] = value;
    }
    
    // Helper methods
    static std::string trim(const std::string& str) {
        size_t first = str.find_first_not_of(" \t\n\r");
        if (first == std::string::npos) return "";
        size_t last = str.find_last_not_of(" \t\n\r");
        return str.substr(first, last - first + 1);
    }
    
    static std::string trimQuotes(const std::string& str) {
        if (str.size() >= 2 && str.front() == '\"' && str.back() == '\"') {
            return str.substr(1, str.size() - 2);
        }
        return str;
    }
    
    static std::string escapeJSON(const std::string& str) {
        std::stringstream ss;
        for (auto c : str) {
            switch (c) {
                case '\"': ss << "\\\""; break;
                case '\\': ss << "\\\\"; break;
                case '\b': ss << "\\b"; break;
                case '\f': ss << "\\f"; break;
                case '\n': ss << "\\n"; break;
                case '\r': ss << "\\r"; break;
                case '\t': ss << "\\t"; break;
                default:
                    if ('\x00' <= c && c <= '\x1f') {
                        ss << "\\u" << std::hex << std::setw(4) << std::setfill('0') << (int)c;
                    } else {
                        ss << c;
                    }
            }
        }
        return ss.str();
    }
};

// Function to save the pet's state to a JSON file
bool saveGame(
    const std::string& petName, const std::string& petType,
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
    const std::chrono::system_clock::time_point* lastQuestionTime
) {
    using namespace Utilities;
    SimpleJSON saveData;
    
    // Store basic pet information
    saveData.set("name", petName);
    saveData.set("type", petType);
    
    // Store timestamps
    saveData.set("last_fed_time", timePointToString(lastFedTime));
    saveData.set("last_attention_time", timePointToString(lastAttentionTime));
    saveData.set("last_sleep_time", timePointToString(lastSleepTime));
    saveData.set("start_time", timePointToString(startTime));
    
    // Store optional timestamps
    saveData.set("sleep_start_time", sleepStartTime ? timePointToString(*sleepStartTime) : "");
    saveData.set("last_insulted_time", lastInsultedTime ? timePointToString(*lastInsultedTime) : "");
    
    // Store statistics
    saveData.set("angry_pet_counter", angryPetCounter);
    saveData.set("total_feedings", totalFeedings);
    saveData.set("total_pettings", totalPettings);
    saveData.set("total_insults", totalInsults);
    saveData.set("total_sleep_sessions", totalSleepSessions);
    
    // Store random event timestamps
    saveData.set("last_item_time", lastItemTime ? timePointToString(*lastItemTime) : "");
    saveData.set("last_advice_time", lastAdviceTime ? timePointToString(*lastAdviceTime) : "");
    saveData.set("last_question_time", lastQuestionTime ? timePointToString(*lastQuestionTime) : "");
    
    // Save to file
    try {
        std::ofstream file(SAVE_FILE);
        if (file.is_open()) {
            file << saveData.dump();
            file.close();
            return true;
        }
    } catch (const std::exception& e) {
        std::cerr << "Error saving game: " << e.what() << std::endl;
    }
    
    return false;
}

// Function to load the pet's state from a JSON file
bool loadGame(
    std::string& petName, std::string& petType,
    std::chrono::system_clock::time_point& lastFedTime,
    std::chrono::system_clock::time_point& lastAttentionTime,
    std::chrono::system_clock::time_point& lastSleepTime,
    std::chrono::system_clock::time_point& startTime,
    std::chrono::system_clock::time_point*& sleepStartTime,
    std::chrono::system_clock::time_point*& lastInsultedTime,
    int& angryPetCounter, int& totalFeedings, int& totalPettings,
    int& totalInsults, int& totalSleepSessions,
    std::chrono::system_clock::time_point*& lastItemTime,
    std::chrono::system_clock::time_point*& lastAdviceTime,
    std::chrono::system_clock::time_point*& lastQuestionTime
) {
    using namespace Utilities;
    
    try {
        std::ifstream file(SAVE_FILE);
        if (!file.is_open()) {
            return false;
        }
        
        std::stringstream buffer;
        buffer << file.rdbuf();
        file.close();
        
        SimpleJSON saveData;
        if (!saveData.parse(buffer.str())) {
            return false;
        }
        
        // Load basic pet information
        petName = saveData.getString("name");
        petType = saveData.getString("type");
        
        // Load timestamps
        lastFedTime = stringToTimePoint(saveData.getString("last_fed_time"));
        lastAttentionTime = stringToTimePoint(saveData.getString("last_attention_time"));
        lastSleepTime = stringToTimePoint(saveData.getString("last_sleep_time"));
        startTime = stringToTimePoint(saveData.getString("start_time"));
        
        // Load optional timestamps
        std::string sleepStartStr = saveData.getString("sleep_start_time");
        if (!sleepStartStr.empty()) {
            sleepStartTime = new std::chrono::system_clock::time_point(stringToTimePoint(sleepStartStr));
        } else {
            sleepStartTime = nullptr;
        }
        
        std::string lastInsultedStr = saveData.getString("last_insulted_time");
        if (!lastInsultedStr.empty()) {
            lastInsultedTime = new std::chrono::system_clock::time_point(stringToTimePoint(lastInsultedStr));
        } else {
            lastInsultedTime = nullptr;
        }
        
        // Load statistics
        angryPetCounter = saveData.getInt("angry_pet_counter");
        totalFeedings = saveData.getInt("total_feedings");
        totalPettings = saveData.getInt("total_pettings");
        totalInsults = saveData.getInt("total_insults");
        totalSleepSessions = saveData.getInt("total_sleep_sessions");
        
        // Load random event timestamps
        std::string lastItemStr = saveData.getString("last_item_time");
        if (!lastItemStr.empty()) {
            lastItemTime = new std::chrono::system_clock::time_point(stringToTimePoint(lastItemStr));
        } else {
            lastItemTime = nullptr;
        }
        
        std::string lastAdviceStr = saveData.getString("last_advice_time");
        if (!lastAdviceStr.empty()) {
            lastAdviceTime = new std::chrono::system_clock::time_point(stringToTimePoint(lastAdviceStr));
        } else {
            lastAdviceTime = nullptr;
        }
        
        std::string lastQuestionStr = saveData.getString("last_question_time");
        if (!lastQuestionStr.empty()) {
            lastQuestionTime = new std::chrono::system_clock::time_point(stringToTimePoint(lastQuestionStr));
        } else {
            lastQuestionTime = nullptr;
        }
        
        return true;
    } catch (const std::exception& e) {
        std::cerr << "Error loading game: " << e.what() << std::endl;
        return false;
    }
}
