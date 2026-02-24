import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var isActive = false
    @Published var sessionMode: SessionMode = .focus
    @Published var progress: Double = 1.0
    
    private var totalTime: TimeInterval
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    let cycleManager = CycleManager.shared
    
    init() {
        let initialDuration = Double(CycleManager.shared.getDuration(for: .focus) * 60)
        self.timeRemaining = initialDuration
        self.totalTime = initialDuration
        
        cycleManager.$isAutoCycleEnabled.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    func start() {
        print("Timer started")
        isActive = true
        NotificationManager.shared.cancelReminders()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func pause() {
        isActive = false
        timer?.cancel()
    }
    
    func reset() {
        isActive = false
        timer?.cancel()
        cycleManager.resetCycles()
        sessionMode = .focus
        setupDuration(for: .focus)
    }
    
    private func setupDuration(for mode: SessionMode) {
        let minutes = cycleManager.getDuration(for: mode)
        totalTime = Double(minutes * 60)
        timeRemaining = totalTime
        progress = 1.0
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            progress = timeRemaining / totalTime
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        pause()
        
        if sessionMode == .focus {
            let session = FocusSession(date: Date(), duration: totalTime, mode: .focus)
            StorageManager.shared.saveSession(session)
            
            // Check daily goal
            if AnalyticsManager.shared.completedSessionsToday == StorageManager.shared.getDailyGoal() {
                NotificationManager.shared.sendGoalAchievedNotification()
            }
        }
        
        let next = cycleManager.nextMode(after: sessionMode)
        sessionMode = next
        setupDuration(for: next)
        
        NotificationManager.shared.sendSessionCompleteNotification(mode: next)
        
        if cycleManager.isAutoCycleEnabled {
            // Small delay before auto-starting next session
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.start()
            }
        }
    }
    
    var timeString: String {
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
