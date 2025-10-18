//
//  SearchView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/15/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]
    @State private var searchText = ""

    // Filtered sessions based on search text
    private var filteredSessions: [Session] {
        if searchText.isEmpty {
            return sessions
        } else {
            return sessions.filter { session in
                session.sessionName.localizedCaseInsensitiveContains(searchText) ||
                session.notes?.localizedCaseInsensitiveContains(searchText) == true ||
                "\(session.mistakeCount)".contains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if searchText.isEmpty {
                        // Header for recent sessions
                        Text("Recent Sessions")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    } else {
                        // Header for search results
                        Text("\(filteredSessions.count) Results")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    }

                    // Session List
                    if searchText.isEmpty {
                        // Show recent sessions (last 10)
                        if sessions.isEmpty {
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
                                ForEach(sessions.prefix(10)) { session in
                                    NavigationLink {
                                        SessionDetailView(session: session)
                                    } label: {
                                        SessionRowView(session: session)
                                    }
                                    .buttonStyle(.plain)
                                    .tint(.orange)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    } else {
                        // Show filtered results
                        if filteredSessions.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.orange.opacity(0.3))
                                    .padding(.top, 60)

                                Text("No Results")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.secondary)

                                Text("No sessions match '\(searchText)'")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredSessions) { session in
                                    NavigationLink {
                                        SessionDetailView(session: session)
                                    } label: {
                                        SessionRowView(session: session)
                                    }
                                    .buttonStyle(.plain)
                                    .tint(.orange)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search sessions")
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(for: Session.self)
}
