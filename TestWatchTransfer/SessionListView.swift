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
    @EnvironmentObject var themeManager: ThemeManager
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Summary Graphs Section
                    if !sessions.isEmpty {
                        SessionSummaryGraphView(sessions: sessions, days: 30)
                            .padding(.horizontal, AppTheme.current.spacingXL)
                            .padding(.top, AppTheme.current.spacingM)
                    }

                    // Recent Activity Header
                    HStack {
                        Text("Recent Activity")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppTheme.current.primary)

                        Spacer()

                        // History button - future feature
                        Button(action: {
                            // TODO: Navigate to full history
                        }) {
                            Text("History")
                                .font(.system(size: AppTheme.current.fontSizeBody, weight: .medium))
                                .foregroundStyle(AppTheme.current.primary)
                        }
                    }
                    .padding(.horizontal, AppTheme.current.spacingXL)
                    .padding(.top, AppTheme.current.spacingS)

                    // Session List
                    if sessions.isEmpty {
                        // Empty state
                        VStack(spacing: AppTheme.current.spacingL) {
                            Image(systemName: "clock.badge.exclamationmark")
                                .font(.system(size: 60))
                                .foregroundStyle(AppTheme.current.primary.opacity(0.3))
                                .padding(.top, 60)

                            Text("No Sessions Yet")
                                .font(.system(size: AppTheme.current.fontSizeTitle, weight: .semibold))
                                .foregroundStyle(AppTheme.current.textSecondary)

                            Text("Start tracking your practice sessions\nfrom your Apple Watch")
                                .font(.system(size: AppTheme.current.fontSizeBody))
                                .foregroundStyle(AppTheme.current.textSecondary.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        // Use List for swipe actions support
                        ForEach(groupedSessions, id: \.0) { (sectionTitle, sectionSessions) in
                            VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                                // Section header
                                Text(sectionTitle)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(AppTheme.current.textPrimary)
                                    .padding(.horizontal, AppTheme.current.spacingXL)
                                    .padding(.top, AppTheme.current.spacingM)

                                // Sessions List with swipe actions
                                List {
                                    ForEach(sectionSessions) { session in
                                        ZStack {
                                            NavigationLink {
                                                SessionDetailView(session: session)
                                            } label: {
                                                EmptyView()
                                            }
                                            .opacity(0)

                                            SessionRowView(session: session)
                                                .padding(.vertical, 4)
                                        }
                                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                deleteSession(session)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                                .listStyle(.plain)
                                .scrollDisabled(true)
                                .frame(height: CGFloat(sectionSessions.count) * 112)
                            }
                        }
                    }
                }
                .padding(.bottom, AppTheme.current.spacingXL)
            }
            .scrollIndicators(.hidden)
            .background(AppTheme.current.backgroundPrimary)
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        populateDummyData()
                    }) {
                        Image(systemName: "gear")
                            .frame(width: 25, height: 25)
                    }
                }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(themeManager.currentTheme.backgroundPrimary, for: .tabBar)
            .toolbarColorScheme(colorScheme, for: .tabBar)
        }
        .overlay {
            
        }
    }
    
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

    // Generate dummy data for testing UI
    private func populateDummyData() {
        let calendar = Calendar.current
        let now = Date()

        // This Week sessions (3 sessions)
        for i in 0..<3 {
            let daysAgo = i * 2 // 0, 2, 4 days ago
            if let sessionDate = calendar.date(byAdding: .day, value: -daysAgo, to: now) {
                createDummySession(
                    name: "This Week Session \(i + 1)",
                    startDate: sessionDate,
                    mistakes: Int.random(in: 5...15)
                )
            }
        }

        // This Month sessions (4 sessions)
        for i in 0..<4 {
            let daysAgo = 7 + (i * 3) // 7, 10, 13, 16 days ago
            if let sessionDate = calendar.date(byAdding: .day, value: -daysAgo, to: now) {
                createDummySession(
                    name: "This Month Session \(i + 1)",
                    startDate: sessionDate,
                    mistakes: Int.random(in: 8...20)
                )
            }
        }

        // Previous months sessions (6 sessions spread across 2-3 months)
        let previousMonthsOffsets = [35, 42, 50, 65, 72, 90] // Days ago
        for (index, daysAgo) in previousMonthsOffsets.enumerated() {
            if let sessionDate = calendar.date(byAdding: .day, value: -daysAgo, to: now) {
                let monthYear = sessionDate.formatted(.dateTime.month(.wide).year())
                createDummySession(
                    name: "Session \(index + 1)",
                    startDate: sessionDate,
                    mistakes: Int.random(in: 3...25)
                )
            }
        }
    }

    private func createDummySession(name: String, startDate: Date, mistakes: Int) {
        let duration = TimeInterval.random(in: 1800...7200) // 30 min to 2 hours
        let endDate = startDate.addingTimeInterval(duration)

        // Generate realistic mistake timeline
        var mistakeTimeline: [Date] = []
        let timeInterval = duration / Double(mistakes)
        for i in 0..<mistakes {
            let mistakeTime = startDate.addingTimeInterval(timeInterval * Double(i) + Double.random(in: -30...30))
            mistakeTimeline.append(mistakeTime)
        }

        let session = Session(
            sessionName: name,
            startTime: startDate,
            endTime: endDate,
            mistakeCount: mistakes,
            mistakeTimeline: mistakeTimeline,
            notes: "Dummy data for testing UI"
        )

        modelContext.insert(session)

        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to save dummy session: \(error)")
        }
    }

    // Delete a session from the model context
    private func deleteSession(_ session: Session) {
        withAnimation {
            modelContext.delete(session)

            do {
                try modelContext.save()
            } catch {
                print("❌ Failed to delete session: \(error)")
            }
        }
    }
}
