//
//  SessionListView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import SwiftData


struct SessionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]
    @State private var hasSetupObserver = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Recent Activity Header
                    HStack {
                        Text("Recent Activity")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.primary)

                        Spacer()

                        // History button - future feature
                        Button(action: {
                            // TODO: Navigate to full history
                        }) {
                            Text("History")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    // Session List
                    if sessions.isEmpty {
                        // Empty state
                        VStack(spacing: 16) {
                            Image(systemName: "clock.badge.exclamationmark")
                                .font(.system(size: 60))
                                .foregroundStyle(.orange.opacity(0.3))
                                .padding(.top, 60)

                            Text("No Sessions Yet")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.secondary)

                            Text("Start tracking your practice sessions\nfrom your Apple Watch")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(sessions) { session in
                                NavigationLink {
                                    SessionDetailView(session: session)
                                } label: {
                                    SessionRowView(session: session)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            .onAppear {
                if !hasSetupObserver {
                    setupObserver()
                    hasSetupObserver = true
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


extension SessionListView {
    private func setupObserver() {
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
}
