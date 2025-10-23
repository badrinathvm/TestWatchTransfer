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
            Group {
                if searchText.isEmpty {
                    // Zero state - show ContentUnavailableView.search
                    ContentUnavailableView.search
                } else if filteredSessions.isEmpty {
                    // No results state
                    ContentUnavailableView.search(text: searchText)
                } else {
                    // Show search results
                    ScrollView {
                        LazyVStack(spacing: AppTheme.current.spacingM) {
                            ForEach(filteredSessions) { session in
                                NavigationLink {
                                    SessionDetailView(session: session)
                                } label: {
                                    SessionRowView(session: session)
                                }
                                .buttonStyle(.plain)
                                .tint(AppTheme.current.accent)
                            }
                        }
                        .padding(.horizontal, AppTheme.current.spacingXL)
                        .padding(.top, AppTheme.current.spacingS)
                        .padding(.bottom, AppTheme.current.spacingXL)
                    }
                    .background(AppTheme.current.backgroundPrimary)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search sessions")
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(uiColor: .systemBackground), for: .tabBar)
            .toolbarColorScheme(colorScheme, for: .tabBar)
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(for: Session.self)
}
