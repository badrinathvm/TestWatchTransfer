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
    private let counterKey = "counterValue1"
    private let timelineKey = "mistakeTimeline"
    private let sessionStartKey = "sessionStartTime"

    private lazy var defaults: UserDefaults? = {
        UserDefaults(suiteName: appGroupID)
    }()

    private init() {
        // Ensure defaults is initialized
        _ = defaults

        // Debug: Verify App Group is accessible
        if let defaults = defaults {
            print("✅ App Group UserDefaults initialized successfully")
            print("🔑 App Group ID: \(appGroupID)")
            print("🗂️ Storage Key: \(counterKey)")
        } else {
            print("❌ Failed to initialize App Group UserDefaults!")
        }
    }

    var currentCount: Int {
        get {
            guard let defaults = defaults else {
                print("⚠️ App Group UserDefaults not available, using standard defaults")
                return UserDefaults.standard.integer(forKey: counterKey)
            }
            let value = defaults.integer(forKey: counterKey)
            print("📖 GET counterValue1 = \(value) from App Group UserDefaults")
            return value
        }
        set {
            guard let defaults = defaults else {
                print("⚠️ App Group UserDefaults not available, using standard defaults")
                UserDefaults.standard.set(newValue, forKey: counterKey)
                return
            }
            print("💾 SET counterValue1 = \(newValue) to App Group UserDefaults")
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
        // TODO: Future implementation - send session data to iOS app
        print("📊 Submit: \(currentCount) mistakes recorded")
        reset()
    }
    
    func increment() {
        let oldValue = currentCount
        currentCount += 1

        // Append current time to mistake timeline
        var timeline = mistakeTimeline
        timeline.append(Date())
        mistakeTimeline = timeline

        let newValue = currentCount
        print("➕ INCREMENT: \(oldValue) -> \(newValue), Timeline count: \(timeline.count)")
        reloadComplications()
    }

    func reset() {
        currentCount = 0
        mistakeTimeline = []
        sessionStartTime = Date()
        print("🔄 Counter reset. New value: \(currentCount), Timeline cleared, Session start time reset")
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
