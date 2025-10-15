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

    init(sessionName: String? = nil, startTime: Date, endTime: Date, mistakeCount: Int, mistakeTimeline: [Date] = [], notes: String? = nil) {
        self.sessionName = sessionName
        self.startTime = startTime
        self.endTime = endTime
        self.mistakeCount = mistakeCount
        self.mistakeTimeline = mistakeTimeline
        self.notes = notes
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

        return SessionData(
            sessionName: sessionName,
            startTime: startTime,
            endTime: endTime,
            mistakeCount: mistakeCount,
            mistakeTimeline: mistakeTimeline,
            notes: notes
        )
    }
}
