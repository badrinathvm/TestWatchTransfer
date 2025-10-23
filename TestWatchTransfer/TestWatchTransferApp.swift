//
//  TestWatchTransferApp.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import SwiftData

@main
struct TestWatchTransferApp: App {
    @StateObject private var themeManager = ThemeManager.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Session.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        // Initialize WatchConnectivity early
        _ = WatchConnectivityManager.shared

        // Setup observer for incoming sessions at app level
        setupSessionObserver()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
        .modelContainer(sharedModelContainer)
    }

    private func setupSessionObserver() {
        NotificationCenter.default.addObserver(
            forName: .didReceiveSession,
            object: nil,
            queue: .main
        ) { [self] notification in
            if let sessionData = notification.object as? SessionData {
                saveSession(sessionData)
            }
        }
    }

    private func saveSession(_ sessionData: SessionData) {
        let context = sharedModelContainer.mainContext

        let session = Session(
            sessionName: sessionData.sessionName,
            startTime: sessionData.startTime,
            endTime: sessionData.endTime,
            mistakeCount: sessionData.mistakeCount,
            mistakeTimeline: sessionData.mistakeTimeline,
            notes: sessionData.notes,
            latitude: sessionData.latitude,
            longitude: sessionData.longitude,
            locationName: sessionData.locationName,
            errorCounts: sessionData.errorCounts
        )

        context.insert(session)

        do {
            try context.save()
            print("✅ Session saved from Watch: \(session.mistakeCount) mistakes")
            if let locationName = session.locationName {
                print("📍 Location: \(locationName)")
            }
        } catch {
            print("❌ Failed to save session: \(error)")
        }
    }
}


/*
 
 🏓 Common Pickleball Mistakes
     1.    Missing the serve by hitting it into the net.
     2.    Attempting a lob and getting smashed by the opponent.
     3.    Missing the return of serve.
     4.    Hitting the return too long or out of bounds.
     5.    Stepping into the kitchen during a volley.
     6.    Failing to move up to the net after returning the serve.
     7.    Overhitting shots instead of controlling placement.
     8.    Not calling shots early or communicating with your partner.
     9.    Standing flat-footed and reacting too late.
     10.    Forgetting to reset after being pulled wide.
 
 
 Serve Error
 Serve hits the net or lands out of bounds.
 
 Lob Miss
 Lob shot gets attacked or fails to clear the opponent.
 
 Missed Return
 Serve return not executed successfully.
 
 Overhit Return
 Return travels long or outside the court boundaries.
 
 Kitchen Fault
 Stepped into the non-volley zone during a volley.
 
 Slow Net Transition
 Failed to move up to the net after returning serve.
 
 Power Over Control
 Used excessive force instead of controlled placement.
 
 Communication Error
 Lack of coordination or unclear shot call with partner.
 
 Positioning Error
 Late reaction or flat-footed movement during play.
 
 Recovery Miss
 Did not reset position effectively after wide or deep shots
 
 
 
 Location updates for Session Details
 Register the Apple account with Pickerites app.
 Add the Erroro Options selection in session Details.
 Build a graph with Error Rate Consistency
 HealthKit Integration to pull data related to PickleBall Session
 Onboarding screens
 App Logo
 Enhance the Complications UI some times it is navigating to the watch app.
 */
