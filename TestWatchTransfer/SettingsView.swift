//
//  SettingsView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/15/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]
    @State private var showClearDataAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("App Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundStyle(.secondary)
                    }
                }

                Section(header: Text("About")) {
                    Text("Pickleball Rite helps you monitor and improve your game by analyzing mistakes during practice and tournaments.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section(header: Text("Data Management")) {
                    Button(role: .destructive) {
                        showClearDataAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear All Data")
                        }
                    }
                    .disabled(sessions.isEmpty)
                }

                Section(header: Text("Storage")) {
                    HStack {
                        Text("Total Sessions")
                        Spacer()
                        Text("\(sessions.count)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Clear All Data?", isPresented: $showClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This will permanently delete all \(sessions.count) session(s) and reset your data. This action cannot be undone.")
            }
        }
    }

    private func clearAllData() {
        // Delete all sessions from SwiftData
        for session in sessions {
            modelContext.delete(session)
        }

        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to clear data: \(error)")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Session.self)
}
