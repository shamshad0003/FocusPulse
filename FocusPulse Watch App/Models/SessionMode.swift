import SwiftUI

enum SessionMode: String, Codable {
    case focus
    case breakTime
    case longBreak
    
    var label: String {
        switch self {
        case .focus: return "Focus"
        case .breakTime: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
    
    var color: Color {
        switch self {
        case .focus: return .red
        case .breakTime: return .green
        case .longBreak: return .blue
        }
    }
}
