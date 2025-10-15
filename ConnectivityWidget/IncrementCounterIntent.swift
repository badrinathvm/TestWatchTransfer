//
//  IncrementCounterIntent.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import AppIntents
import WidgetKit
import WatchConnectivity

struct IncrementCounterIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment Counter"
    static var description = IntentDescription("Increments the counter by one")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult {
        // Increment the counter
        CounterManager.shared.increment()
        return .result()
    }
}
