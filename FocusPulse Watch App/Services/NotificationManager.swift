import UserNotifications
import WatchKit

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendSessionCompleteNotification(mode: SessionMode) {
        let content = UNMutableNotificationContent()
        content.title = "FocusPulse"
        
        switch mode {
        case .focus:
            content.body = "Focus session completed! Time for a break."
            WKInterfaceDevice.current().play(.success)
        case .breakTime:
            content.body = "Short break finished. Time to focus again."
            WKInterfaceDevice.current().play(.stop)
        case .longBreak:
            content.body = "Long break finished. Ready for a new cycle?"
            WKInterfaceDevice.current().play(.retry)
        }
        
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "SessionComplete", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        
        // Schedule smart reminder if auto-cycle is OFF
        if !CycleManager.shared.isAutoCycleEnabled {
            scheduleSmartReminder()
        }
    }
    
    func scheduleSmartReminder() {
        let content = UNMutableNotificationContent()
        content.title = "FocusPulse Reminder"
        content.body = "Don't forget to start your next session!"
        content.sound = .default
        
        // Trigger after 2 minutes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
        let request = UNNotificationRequest(identifier: "SmartReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["SmartReminder"])
    }
    
    func sendGoalAchievedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Goal Achieved! 🎉"
        content.body = "You've reached your daily focus goal. Great job!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "GoalAchieved", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
        WKInterfaceDevice.current().play(.notification)
    }
}
