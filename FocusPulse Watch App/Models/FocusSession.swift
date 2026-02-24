import Foundation

struct FocusSession: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let duration: TimeInterval
    let mode: SessionMode
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
