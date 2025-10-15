//
//  WatchConnectivityManager.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import Foundation
import WatchConnectivity

#if os(watchOS)
import WidgetKit
#endif

// Notification for UI updates
extension Notification.Name {
    static let didReceiveMessage = Notification.Name("didReceiveMessage")
    static let didReceiveCounter = Notification.Name("didReceiveCounter")
    static let didReceiveSession = Notification.Name("didReceiveSession")
}

class WatchConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()

    private override init() {
        super.init()

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // MARK: - Send Message
    func sendMessage(_ text: String) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated")
            return
        }

        #if os(watchOS)
        guard WCSession.default.isReachable else {
            print("iPhone not reachable")
            return
        }
        #endif

        let messageData = ["text": text]
        WCSession.default.sendMessage(messageData, replyHandler: nil) { error in
            print("Send error: \(error.localizedDescription)")
        }
    }

    // MARK: - Send Counter
    func sendCounter(_ count: Int) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated")
            return
        }

        let messageData = ["counter": count]
        WCSession.default.sendMessage(messageData, replyHandler: nil) { error in
            print("Send error: \(error.localizedDescription)")
        }
    }

    // MARK: - Send Session
    func sendSession(_ sessionData: SessionData) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated")
            return
        }

        var messageData = sessionData.toDictionary()
        messageData["type"] = "session" // Add type identifier

        WCSession.default.sendMessage(messageData, replyHandler: nil) { error in
            print("Send session error: \(error.localizedDescription)")
        }
        print("📤 Sent session: \(sessionData.mistakeCount) mistakes")
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activated: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // Check message type
        if let type = message["type"] as? String, type == "session" {
            // Handle session data
            if let sessionData = SessionData.fromDictionary(message) {
                print("📥 Received session: \(sessionData.mistakeCount) mistakes")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: .didReceiveSession,
                        object: sessionData
                    )
                }
            }
            return
        }

        if let text = message["text"] as? String {
            // Save to shared UserDefaults
            SharedDataManager.shared.saveMessage(text)

            #if os(watchOS)
            // Refresh complications on watchOS
            WidgetCenter.shared.reloadAllTimelines()
            #endif

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .didReceiveMessage,
                    object: text
                )
            }
        }

        if let counter = message["counter"] as? Int {
            // Save counter to shared UserDefaults
            CounterManager.shared.currentCount = counter

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .didReceiveCounter,
                    object: counter
                )
            }
        }
    }

    // MARK: - Handle transferUserInfo
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print("didReceiveUserInfo: \(userInfo)")

        if let text = userInfo["text"] as? String {
            // Save to shared UserDefaults
            SharedDataManager.shared.saveMessage(text)

            #if os(watchOS)
            // Refresh complications on watchOS
            WidgetCenter.shared.reloadAllTimelines()
            #endif

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .didReceiveMessage,
                    object: text
                )
            }
        }

        if let counter = userInfo["counter"] as? Int {
            print("Received counter via transferUserInfo: \(counter)")
            // Save counter to shared UserDefaults
            CounterManager.shared.currentCount = counter

            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .didReceiveCounter,
                    object: counter
                )
            }
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}

