//
//  ContentView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]

    @State private var messages: [MessageItem] = []
    @State private var latestMessage: String = "Waiting for message from Watch..."
    @State private var counterValue: Int = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Counter Section
                VStack(spacing: 10) {
                    Text("Counter from Watch:")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("\(counterValue)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(gaugeColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(gaugeColor.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding()

                Divider()

                // Latest Message Section
                VStack(spacing: 10) {
                    Text("Latest Message:")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(latestMessage)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding()

                Divider()

                // Sessions Section
                if !sessions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Sessions")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(sessions.prefix(5)) { session in
                                    SessionCardView(session: session)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)

                    Divider()
                }

                // Messages List
                List {
                    ForEach(messages) { message in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(message.text)
                                .font(.body)
                                .fontWeight(.medium)

                            Text(formatDate(message.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteMessages)
                }
                .listStyle(.inset)
            }
            .navigationTitle("iPhone App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !messages.isEmpty {
                        Button(role: .destructive) {
                            clearAllMessages()
                        } label: {
                            Label("Clear All", systemImage: "trash")
                        }
                    }
                }
            }
            .onAppear {
                loadMessages()
                loadCounter()
                setupObserver()
            }
        }
    }

    private var gaugeColor: Color {
        switch counterValue {
        case 1...5: return .green
        case 6...10: return .orange
        default: return .red
        }
    }

    private func loadMessages() {
        messages = SharedDataManager.shared.getMessages()
        if let first = messages.first {
            latestMessage = first.text
        }
    }

    private func loadCounter() {
        counterValue = CounterManager.shared.currentCount
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(
            forName: .didReceiveMessage,
            object: nil,
            queue: .main
        ) { notification in
            if let text = notification.object as? String {
                latestMessage = text
                loadMessages()
            }
        }

        NotificationCenter.default.addObserver(
            forName: .didReceiveCounter,
            object: nil,
            queue: .main
        ) { notification in
            if let count = notification.object as? Int {
                counterValue = count
            }
        }

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
        let session = Session(
            sessionName: sessionData.sessionName,
            startTime: sessionData.startTime,
            endTime: sessionData.endTime,
            mistakeCount: sessionData.mistakeCount,
            mistakeTimeline: sessionData.mistakeTimeline,
            notes: sessionData.notes
        )

        modelContext.insert(session)

        do {
            try modelContext.save()
            print("✅ Session saved: \(session.mistakeCount) mistakes")
        } catch {
            print("❌ Failed to save session: \(error)")
        }
    }

    private func deleteMessages(at offsets: IndexSet) {
        for index in offsets {
            let message = messages[index]
            SharedDataManager.shared.deleteMessage(message)
        }
        loadMessages()
    }

    private func clearAllMessages() {
        SharedDataManager.shared.clearAllMessages()
        messages = []
        latestMessage = "No messages"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
