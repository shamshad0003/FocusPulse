import Foundation

class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    var dailyMinutes: Int {
        let sessions = StorageManager.shared.getAllSessions()
        let today = Calendar.current.startOfDay(for: Date())
        let todaySessions = sessions.filter { Calendar.current.isDate($0.date, inSameDayAs: today) && $0.mode == .focus }
        return Int(todaySessions.reduce(0) { $0 + $1.duration }) / 60
    }
    
    var weeklyHours: Double {
        let sessions = StorageManager.shared.getWeeklySessions()
        let focusMinutes = sessions.filter { $0.mode == .focus }.reduce(0) { $0 + $1.duration }
        return Double(focusMinutes) / 3600.0
    }
    
    var currentStreak: Int {
        let sessions = StorageManager.shared.getAllSessions()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let focusDates = Set(sessions.filter { $0.mode == .focus }.map { calendar.startOfDay(for: $0.date) })
        
        var streak = 0
        var checkDate = today
        
        // If no sessions today, check yesterday to see if streak is still alive
        if !focusDates.contains(today) {
            checkDate = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        }
        
        while focusDates.contains(checkDate) {
            streak += 1
            guard let nextDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = nextDate
        }
        
        return streak
    }
    
    var dailyGoalProgress: Double {
        let goal = max(StorageManager.shared.getDailyGoal(), 1) // Avoid division by zero
        let completedToday = StorageManager.shared.getAllSessions().filter { 
            Calendar.current.isDate($0.date, inSameDayAs: Date()) && $0.mode == .focus 
        }.count
        return min(Double(completedToday) / Double(goal), 1.0)
    }
    
    var completedSessionsToday: Int {
        StorageManager.shared.getAllSessions().filter { 
            Calendar.current.isDate($0.date, inSameDayAs: Date()) && $0.mode == .focus 
        }.count
    }
}
