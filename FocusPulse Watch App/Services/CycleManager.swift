import SwiftUI
import Combine


class CycleManager: ObservableObject {
    static let shared = CycleManager()
    
    @Published var cycleCount: Int = 0
    @Published var isAutoCycleEnabled: Bool = false
    
    private init() {
        self.isAutoCycleEnabled = StorageManager.shared.getAutoCycleEnabled()
    }
    
    func toggleAutoCycle() {
        isAutoCycleEnabled.toggle()
        StorageManager.shared.saveAutoCycleEnabled(isAutoCycleEnabled)
    }
    
    func nextMode(after currentMode: SessionMode) -> SessionMode {
        if currentMode == .focus {
            cycleCount += 1
            if cycleCount % 4 == 0 {
                return .longBreak
            } else {
                return .breakTime
            }
        } else {
            return .focus
        }
    }
    
    func resetCycles() {
        cycleCount = 0
    }
    
    func getDuration(for mode: SessionMode) -> Int {
        switch mode {
        case .focus:
            return StorageManager.shared.getFocusDuration()
        case .breakTime:
            return StorageManager.shared.getShortBreakDuration()
        case .longBreak:
            return StorageManager.shared.getLongBreakDuration()
        }
    }
}
