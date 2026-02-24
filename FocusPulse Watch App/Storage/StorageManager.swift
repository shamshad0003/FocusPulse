import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let sessionsKey = "completed_sessions"
    private let focusDurationKey = "focus_duration"
    private let shortBreakKey = "short_break_duration"
    private let longBreakKey = "long_break_duration"
    private let dailyGoalKey = "daily_goal"
    private let autoCycleKey = "auto_cycle_enabled"
    
    private init() {}
    
    // MARK: - Sessions
    func saveSession(_ session: FocusSession) {
        var sessions = getAllSessions()
        sessions.append(session)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    func getAllSessions() -> [FocusSession] {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([FocusSession].self, from: data) else {
            return []
        }
        return sessions
    }
    
    // MARK: - Settings
    func saveFocusDuration(_ minutes: Int) {
        UserDefaults.standard.set(minutes, forKey: focusDurationKey)
    }
    
    func getFocusDuration() -> Int {
        let duration = UserDefaults.standard.integer(forKey: focusDurationKey)
        return duration == 0 ? 60 : duration
    }
    
    func saveShortBreakDuration(_ minutes: Int) {
        UserDefaults.standard.set(minutes, forKey: shortBreakKey)
    }
    
    func getShortBreakDuration() -> Int {
        let duration = UserDefaults.standard.integer(forKey: shortBreakKey)
        return duration == 0 ? 25 : duration
    }
    
    func saveLongBreakDuration(_ minutes: Int) {
        UserDefaults.standard.set(minutes, forKey: longBreakKey)
    }
    
    func getLongBreakDuration() -> Int {
        let duration = UserDefaults.standard.integer(forKey: longBreakKey)
        return duration == 0 ? 45 : duration
    }
    
    func saveDailyGoal(_ sessions: Int) {
        UserDefaults.standard.set(sessions, forKey: dailyGoalKey)
    }
    
    func getDailyGoal() -> Int {
        let goal = UserDefaults.standard.integer(forKey: dailyGoalKey)
        return goal == 0 ? 4 : goal
    }
    
    func saveAutoCycleEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: autoCycleKey)
    }
    
    func getAutoCycleEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: autoCycleKey)
    }
    
    // MARK: - Analytics Helpers
    func getWeeklySessions() -> [FocusSession] {
        let sessions = getAllSessions()
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sessions.filter { $0.date >= weekAgo }
    }
    
    func getSessionsGroupedByDate() -> [Date: [FocusSession]] {
        let sessions = getAllSessions()
        let calendar = Calendar.current
        
        return Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.date)
        }
    }
}

