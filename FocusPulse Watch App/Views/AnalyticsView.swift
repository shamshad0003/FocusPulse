import SwiftUI

struct AnalyticsView: View {
    let analytics = AnalyticsManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Progress Circle for Daily Goal
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: analytics.dailyGoalProgress)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(Int(analytics.dailyGoalProgress * 100))%")
                            .font(.headline)
                        Text("of goal")
                            .font(.caption2)
                    }
                }
                .frame(width: 80, height: 80)
                .padding(.top, 8)
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    StatBox(label: "Today", value: "\(analytics.dailyMinutes)m")
                    StatBox(label: "Week", value: String(format: "%.1fh", analytics.weeklyHours))
                    StatBox(label: "Streak", value: "\(analytics.currentStreak)d")
                    StatBox(label: "Cycles", value: "\(CycleManager.shared.cycleCount)")
                }
                
                NavigationLink(destination: WeeklySummaryView()) {
                    Text("Session History")
                        .font(.caption)
                }
            }
            .padding()
        }
        .navigationTitle("Analytics")
    }
}

struct StatBox: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    AnalyticsView()
}
