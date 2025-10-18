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
    @Environment(\.colorScheme) var colorScheme
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]

    // Group sessions by time periods
    private var groupedSessions: [(String, [Session])] {
        let calendar = Calendar.current
        let now = Date()

        // Get start of current week (Monday)
        let weekComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        guard let weekStart = calendar.date(from: weekComponents) else {
            // Fallback: return flat list if calendar calculation fails
            return [("All Sessions", sessions)]
        }

        // Get start of current month
        let monthComponents = calendar.dateComponents([.year, .month], from: now)
        guard let monthStart = calendar.date(from: monthComponents) else {
            // Fallback: return flat list if calendar calculation fails
            return [("All Sessions", sessions)]
        }

        var groups: [String: [Session]] = [:]

        for session in sessions {
            let sessionDate = session.startTime

            if sessionDate >= weekStart {
                // This Week
                let key = "This Week"
                groups[key, default: []].append(session)
            } else if sessionDate >= monthStart {
                // This Month (but not this week)
                let key = "This Month"
                groups[key, default: []].append(session)
            } else {
                // Older sessions - group by month and year
                let monthYear = sessionDate.formatted(.dateTime.month(.wide).year())
                groups[monthYear, default: []].append(session)
            }
        }

        // Sort groups: This Week, This Month, then by date descending
        let sortedGroups = groups.sorted { (group1, group2) in
            if group1.key == "This Week" { return true }
            if group2.key == "This Week" { return false }
            if group1.key == "This Month" { return true }
            if group2.key == "This Month" { return false }

            // For month/year groups, compare dates
            let date1 = group1.value.first?.startTime ?? .distantPast
            let date2 = group2.value.first?.startTime ?? .distantPast
            return date1 > date2
        }

        return sortedGroups
    }

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
                        LazyVStack(spacing: 20) {
                            ForEach(groupedSessions, id: \.0) { (sectionTitle, sectionSessions) in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Section header
                                    Text(sectionTitle)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.primary)
                                        .padding(.horizontal, 20)

                                    // Sessions in this section
                                    LazyVStack(spacing: 12) {
                                        ForEach(sectionSessions) { session in
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
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Image(systemName: "gear")
                        .frame(width: 25 , height: 25)
                })
            }
        }
    }
}
