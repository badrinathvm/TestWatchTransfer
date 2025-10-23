//
//  SessionData.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import Foundation

struct SessionData: Codable {
    let sessionName: String?
    let startTime: Date
    let endTime: Date
    let mistakeCount: Int
    let mistakeTimeline: [Date]
    let notes: String?
    let latitude: Double?
    let longitude: Double?
    let locationName: String?
    let errorCounts: [String: Int]?

    init(sessionName: String? = nil, startTime: Date, endTime: Date, mistakeCount: Int, mistakeTimeline: [Date] = [], notes: String? = nil, latitude: Double? = nil, longitude: Double? = nil, locationName: String? = nil, errorCounts: [String: Int]? = nil) {
        self.sessionName = sessionName
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

    // Convert to dictionary for WatchConnectivity
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "startTime": startTime,
            "endTime": endTime,
            "mistakeCount": mistakeCount,
            "mistakeTimeline": mistakeTimeline
        ]

        if let sessionName = sessionName {
            dict["sessionName"] = sessionName
        }

        if let notes = notes {
            dict["notes"] = notes
        }

        if let latitude = latitude {
            dict["latitude"] = latitude
        }

        if let longitude = longitude {
            dict["longitude"] = longitude
        }

        if let locationName = locationName {
            dict["locationName"] = locationName
        }

        if let errorCounts = errorCounts {
            dict["errorCounts"] = errorCounts
        }

        return dict
    }

    // Create from dictionary received via WatchConnectivity
    static func fromDictionary(_ dict: [String: Any]) -> SessionData? {
        guard let startTime = dict["startTime"] as? Date,
              let endTime = dict["endTime"] as? Date,
              let mistakeCount = dict["mistakeCount"] as? Int,
              let mistakeTimeline = dict["mistakeTimeline"] as? [Date] else {
            return nil
        }

        let sessionName = dict["sessionName"] as? String
        let notes = dict["notes"] as? String
        let latitude = dict["latitude"] as? Double
        let longitude = dict["longitude"] as? Double
        let locationName = dict["locationName"] as? String
        let errorCounts = dict["errorCounts"] as? [String: Int]

        return SessionData(
            sessionName: sessionName,
            startTime: startTime,
            endTime: endTime,
            mistakeCount: mistakeCount,
            mistakeTimeline: mistakeTimeline,
            notes: notes,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            errorCounts: errorCounts
        )
    }
}
