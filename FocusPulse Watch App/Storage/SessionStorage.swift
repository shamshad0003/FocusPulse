//
//  SessionStorage.swift
//  FocusPulse
//
//  Created by Shamshad on 2/24/26.
//
import Foundation

class SessionStorage {
    
    private let key = "dailySessions"
    
    func saveSession() {
        var sessions = UserDefaults.standard.dictionary(forKey: key) as? [String: Int] ?? [:]
        
        let today = formattedDate(Date())
        
        sessions[today, default: 0] += 1
        
        UserDefaults.standard.set(sessions, forKey: key)
    }
    
    func getWeeklySessions() -> [String: Int] {
        UserDefaults.standard.dictionary(forKey: key) as? [String: Int] ?? [:]
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
