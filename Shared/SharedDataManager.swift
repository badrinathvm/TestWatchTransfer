//
//  SharedDataManager.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import Foundation

struct MessageItem: Codable, Identifiable {
    let id: UUID
    let text: String
    let timestamp: Date

    init(text: String) {
        self.id = UUID()
        self.text = text
        self.timestamp = Date()
    }
}

class SharedDataManager {
    static let shared = SharedDataManager()

    private let appGroupID = "group.com.badrinath.watchTransfer"
    private let messagesKey = "savedMessages"

    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    private init() {}

    // MARK: - Save Message
    func saveMessage(_ text: String) {
        var messages = getMessages()
        let newMessage = MessageItem(text: text)
        messages.insert(newMessage, at: 0) // Add to beginning

        if let encoded = try? JSONEncoder().encode(messages) {
            userDefaults?.set(encoded, forKey: messagesKey)
        }
    }

    // MARK: - Get Messages
    func getMessages() -> [MessageItem] {
        guard let data = userDefaults?.data(forKey: messagesKey),
              let messages = try? JSONDecoder().decode([MessageItem].self, from: data) else {
            return []
        }
        return messages
    }

    // MARK: - Delete Message
    func deleteMessage(_ message: MessageItem) {
        var messages = getMessages()
        messages.removeAll { $0.id == message.id }

        if let encoded = try? JSONEncoder().encode(messages) {
            userDefaults?.set(encoded, forKey: messagesKey)
        }
    }

    // MARK: - Clear All Messages
    func clearAllMessages() {
        userDefaults?.removeObject(forKey: messagesKey)
    }
}
