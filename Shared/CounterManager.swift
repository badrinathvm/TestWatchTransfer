//
//  CounterManager.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import Foundation
import ClockKit
import WidgetKit

class CounterManager {
    static let shared = CounterManager()

    private let appGroupID = "group.com.badrinath.watchTransfer"
    private let counterKey = "counterValue"
    private let timelineKey = "mistakeTimeline"
    private let sessionStartKey = "sessionStartTime"

    private lazy var defaults: UserDefaults? = {
        UserDefaults(suiteName: appGroupID)
    }()

    private init() {
        // Ensure defaults is initialized
        _ = defaults
    }

    var currentCount: Int {
        get {
            guard let defaults = defaults else {
                return UserDefaults.standard.integer(forKey: counterKey)
            }
            return defaults.integer(forKey: counterKey)
        }
        set {
            guard let defaults = defaults else {
                UserDefaults.standard.set(newValue, forKey: counterKey)
                return
            }
            defaults.set(newValue, forKey: counterKey)
            defaults.synchronize()
        }
    }

    var mistakeTimeline: [Date] {
        get {
            guard let defaults = defaults,
                  let data = defaults.data(forKey: timelineKey),
                  let timeline = try? JSONDecoder().decode([Date].self, from: data) else {
                return []
            }
            return timeline
        }
        set {
            guard let defaults = defaults,
                  let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            defaults.set(data, forKey: timelineKey)
            defaults.synchronize()
        }
    }

    var sessionStartTime: Date {
        get {
            guard let defaults = defaults,
                  let date = defaults.object(forKey: sessionStartKey) as? Date else {
                return Date()
            }
            return date
        }
        set {
            defaults?.set(newValue, forKey: sessionStartKey)
            defaults?.synchronize()
        }
    }

    func submit() {
        reset()
    }

    func increment() {
        currentCount += 1

        // Append current time to mistake timeline
        var timeline = mistakeTimeline
        timeline.append(Date())
        mistakeTimeline = timeline

        reloadComplications()
    }

    func decrement() {
        guard currentCount > 0 else { return }

        currentCount -= 1

        // Remove last entry from mistake timeline
        var timeline = mistakeTimeline
        if !timeline.isEmpty {
            timeline.removeLast()
            mistakeTimeline = timeline
        }

        reloadComplications()
    }

    func reset() {
        currentCount = 0
        mistakeTimeline = []
        sessionStartTime = Date()
        reloadComplications()
    }


    private func reloadComplications() {
        #if os(watchOS)
        let server = CLKComplicationServer.sharedInstance()
        for complication in server.activeComplications ?? [] {
            server.reloadTimeline(for: complication)
        }
        #endif

        // Also reload any widgets/complications
        WidgetCenter.shared.reloadAllTimelines()
    }
}
