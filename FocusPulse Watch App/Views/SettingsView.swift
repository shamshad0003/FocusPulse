import SwiftUI

struct SettingsView: View {
    @State private var focusDuration: Int = StorageManager.shared.getFocusDuration()
    @State private var shortBreak: Int = StorageManager.shared.getShortBreakDuration()
    @State private var longBreak: Int = StorageManager.shared.getLongBreakDuration()
    @State private var dailyGoal: Int = StorageManager.shared.getDailyGoal()
    
    var body: some View {
        List {
            Section(header: Text("Durations")) {
                Stepper(value: $focusDuration, in: 5...120, step: 5) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Focus")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(focusDuration) min")
                            .font(.body)
                    }
                }
                .onChange(of: focusDuration) { oldValue, newValue in 
                    StorageManager.shared.saveFocusDuration(newValue) 
                }
                
                Stepper(value: $shortBreak, in: 1...30, step: 1) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Short Break")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(shortBreak) min")
                            .font(.body)
                    }
                }
                .onChange(of: shortBreak) { oldValue, newValue in 
                    StorageManager.shared.saveShortBreakDuration(newValue) 
                }
                
                Stepper(value: $longBreak, in: 5...60, step: 5) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Long Break")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(longBreak) min")
                            .font(.body)
                    }
                }
                .onChange(of: longBreak) { oldValue, newValue in 
                    StorageManager.shared.saveLongBreakDuration(newValue) 
                }
            }
            
            Section(header: Text("Goals")) {
                Stepper(value: $dailyGoal, in: 1...20, step: 1) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily Goal")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("\(dailyGoal) sessions")
                            .font(.body)
                    }
                }
                .onChange(of: dailyGoal) { oldValue, newValue in 
                    StorageManager.shared.saveDailyGoal(newValue) 
                }
            }
            
            Section {
                Button(role: .destructive, action: {
                    // Reset logic could be implemented here
                }) {
                    Text("Reset History")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
