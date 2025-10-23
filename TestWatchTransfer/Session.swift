//
//  Session.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import Foundation
import SwiftData

@Model
final class Session {
    var id: UUID
    var sessionName: String
    var startTime: Date
    var endTime: Date
    var mistakeCount: Int
    var mistakeTimeline: [Date]
    var notes: String?
    var latitude: Double?
    var longitude: Double?
    var locationName: String?
    var errorCounts: [String: Int]? // Dictionary mapping ErrorType.rawValue to count

    // Computed property for duration
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }

    // Computed property for mistakes per hour
    var mistakesPerHour: Double {
        let hours = duration / 3600
        return hours > 0 ? Double(mistakeCount) / hours : 0
    }

    // Computed property for formatted duration
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }

    // Computed property for relative time display
    var relativeTimeString: String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(startTime) {
            return "Today"
        } else if calendar.isDateInYesterday(startTime) {
            return "Yesterday"
        } else {
            let days = calendar.dateComponents([.day], from: startTime, to: now).day ?? 0
            if days < 7 {
                return "\(days)d ago"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d"
                return formatter.string(from: startTime)
            }
        }
    }

    // Computed property for time display
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }

    init(id: UUID = UUID(), sessionName: String? = nil, startTime: Date, endTime: Date, mistakeCount: Int, mistakeTimeline: [Date], notes: String? = nil, latitude: Double? = nil, longitude: Double? = nil, locationName: String? = nil, errorCounts: [String: Int]? = nil) {
        self.id = id
        self.sessionName = sessionName ?? Session.generateSessionName(for: startTime)
        self.startTime = startTime
        self.endTime = endTime
        self.mistakeCount = mistakeCount
        self.mistakeTimeline = mistakeTimeline
        self.notes = notes
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.errorCounts = errorCounts
    }

    // Auto-generate session name based on time of day
    static func generateSessionName(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12:
            return "Morning Practice"
        case 12..<17:
            return "Afternoon Practice"
        case 17..<21:
            return "Evening Practice"
        default:
            return "Practice Session"
        }
    }
}
