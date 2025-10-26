//
//  SessionSummaryGraphView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/24/25.
//

import SwiftUI

struct SessionSummaryGraphView: View {
    @EnvironmentObject var themeManager: ThemeManager

    let sessions: [Session]
    let days: Int // Number of days to analyze (default 30)

    init(sessions: [Session], days: Int = 30) {
        self.sessions = sessions
        self.days = days
    }

    // MARK: - Data Filtering

    // Sessions in the current period
    private var currentPeriodSessions: [Session] {
        filterSessions(daysBack: days)
    }

    // Sessions in the previous period (for comparison)
    private var previousPeriodSessions: [Session] {
        filterSessions(daysBack: days * 2, endDaysBack: days)
    }

    private func filterSessions(daysBack: Int, endDaysBack: Int = 0) -> [Session] {
        let calendar = Calendar.current
        let now = Date()

        guard let startDate = calendar.date(byAdding: .day, value: -daysBack, to: now),
              let endDate = endDaysBack > 0 ? calendar.date(byAdding: .day, value: -endDaysBack, to: now) : now else {
            return []
        }

        return sessions.filter { session in
            session.startTime >= startDate && session.startTime < endDate
        }
    }

    // MARK: - Computed Stats

    private var totalSessions: Int {
        currentPeriodSessions.count
    }

    private var previousTotalSessions: Int {
        previousPeriodSessions.count
    }

    private var sessionsTrend: Double? {
        guard previousTotalSessions > 0 else { return nil }
        let change = Double(totalSessions - previousTotalSessions)
        return (change / Double(previousTotalSessions)) * 100
    }

    private var avgMistakes: Double {
        guard !currentPeriodSessions.isEmpty else { return 0 }
        let total = currentPeriodSessions.reduce(0) { $0 + $1.mistakeCount }
        return Double(total) / Double(currentPeriodSessions.count)
    }

    private var previousAvgMistakes: Double {
        guard !previousPeriodSessions.isEmpty else { return 0 }
        let total = previousPeriodSessions.reduce(0) { $0 + $1.mistakeCount }
        return Double(total) / Double(previousPeriodSessions.count)
    }

    private var mistakesTrend: Double? {
        guard previousAvgMistakes > 0 else { return nil }
        let change = avgMistakes - previousAvgMistakes
        // Negative is good (fewer mistakes), so invert the sign
        return -(change / previousAvgMistakes) * 100
    }

    private var bestSession: Int? {
        currentPeriodSessions.map { $0.mistakeCount }.min()
    }

    private var avgMistakesPerHour: Double {
        guard !currentPeriodSessions.isEmpty else { return 0 }
        let total = currentPeriodSessions.reduce(0.0) { $0 + $1.mistakesPerHour }
        return total / Double(currentPeriodSessions.count)
    }

    private var previousAvgMistakesPerHour: Double {
        guard !previousPeriodSessions.isEmpty else { return 0 }
        let total = previousPeriodSessions.reduce(0.0) { $0 + $1.mistakesPerHour }
        return total / Double(previousPeriodSessions.count)
    }

    private var mistakesPerHourTrend: Double? {
        guard previousAvgMistakesPerHour > 0 else { return nil }
        let change = avgMistakesPerHour - previousAvgMistakesPerHour
        // Negative is good (fewer mistakes per hour), so invert the sign
        return -(change / previousAvgMistakesPerHour) * 100
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: themeManager.currentTheme.spacingL) {
            // Summary Stats Row
            VStack(spacing: themeManager.currentTheme.spacingM) {
                HStack(spacing: themeManager.currentTheme.spacingM) {
                    SessionStatsCardView(
                        title: "Sessions",
                        value: "\(totalSessions)",
                        subtitle: "Last \(days) days",
                        trendValue: sessionsTrend,
                        icon: "figure.pickleball"
                    )

                    SessionStatsCardView(
                        title: "Avg Mistakes",
                        value: String(format: "%.1f", avgMistakes),
                        subtitle: "Per session",
                        trendValue: mistakesTrend,
                        icon: "exclamationmark.circle.fill"
                    )
                }

                HStack(spacing: themeManager.currentTheme.spacingM) {
                    SessionStatsCardView(
                        title: "Best Session",
                        value: bestSession != nil ? "\(bestSession!)" : "-",
                        subtitle: "Fewest mistakes",
                        icon: "star.fill"
                    )

                    SessionStatsCardView(
                        title: "Mistakes/Hour",
                        value: String(format: "%.1f", avgMistakesPerHour),
                        subtitle: "Average rate",
                        trendValue: mistakesPerHourTrend,
                        icon: "clock.fill"
                    )
                }
            }

            // Trend Chart
            if !currentPeriodSessions.isEmpty {
                SessionTrendChart(sessions: currentPeriodSessions, days: days)
                    .padding(themeManager.currentTheme.spacingM)
                    .background(themeManager.currentTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusL))
                    .overlay(
                        RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusL)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
            }

            // Error Breakdown Chart
            if !currentPeriodSessions.isEmpty {
                ErrorTypeBreakdownChart(sessions: currentPeriodSessions)
                    .padding(themeManager.currentTheme.spacingM)
                    .background(themeManager.currentTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusL))
                    .overlay(
                        RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusL)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    let calendar = Calendar.current
    let now = Date()

    // Generate sample sessions
    var sessions: [Session] = []
    for i in 0..<40 {
        let daysAgo = i
        if let sessionDate = calendar.date(byAdding: .day, value: -daysAgo, to: now) {
            let mistakes = Int.random(in: 5...20)
            let duration = TimeInterval.random(in: 3600...7200)

            var mistakeTimeline: [Date] = []
            for j in 0..<mistakes {
                mistakeTimeline.append(sessionDate.addingTimeInterval(Double(j) * (duration / Double(mistakes))))
            }

            // Random error distribution
            let errorCounts: [String: Int] = [
                "Serve Error": Int.random(in: 0...4),
                "Missed Return": Int.random(in: 0...5),
                "Kitchen Fault": Int.random(in: 0...3),
                "Overhit Return": Int.random(in: 0...4),
                "Lob Miss": Int.random(in: 0...2)
            ]

            let session = Session(
                sessionName: "Practice",
                startTime: sessionDate,
                endTime: sessionDate.addingTimeInterval(duration),
                mistakeCount: mistakes,
                mistakeTimeline: mistakeTimeline,
                errorCounts: errorCounts
            )
            sessions.append(session)
        }
    }

    return ScrollView {
        SessionSummaryGraphView(sessions: sessions, days: 30)
            .environmentObject(ThemeManager.shared)
            .padding()
    }
    .background(AppTheme.current.backgroundPrimary)
}
