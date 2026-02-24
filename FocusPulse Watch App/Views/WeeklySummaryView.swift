import SwiftUI

struct WeeklySummaryView: View {
    // Use computed properties to ensure data is fresh
    private var groupedSessions: [Date: [FocusSession]] {
        StorageManager.shared.getSessionsGroupedByDate()
    }
    
    private var weeklyTotal: Int {
        StorageManager.shared.getWeeklySessions().count
    }
    
    var body: some View {
        List {
            Section(footer: Text("Weekly Total: \(weeklyTotal) Sessions")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)) {
                
                ForEach(lastSevenDays(), id: \.self) { date in
                    HStack {
                        Text(dayName(for: date))
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(countForDate(date)) Sessions")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Summary")
    }
    
    private func lastSevenDays() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0...6).compactMap { day in
            calendar.date(byAdding: .day, value: -day, to: today)
        }.reversed()
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full day name like "Monday"
        return formatter.string(from: date)
    }
    
    private func countForDate(_ date: Date) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return groupedSessions[startOfDay]?.count ?? 0
    }
}

#Preview {
    WeeklySummaryView()
}
