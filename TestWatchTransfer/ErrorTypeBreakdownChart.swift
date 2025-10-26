//
//  ErrorTypeBreakdownChart.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/24/25.
//

import SwiftUI
import Charts

struct ErrorTypeBreakdownChart: View {
    @EnvironmentObject var themeManager: ThemeManager

    let sessions: [Session]
    let topCount: Int // Number of top errors to show (default 5)

    init(sessions: [Session], topCount: Int = 5) {
        self.sessions = sessions
        self.topCount = topCount
    }

    // Aggregate error counts across all sessions
    private var aggregatedErrors: [ErrorBreakdownData] {
        var errorTotals: [String: Int] = [:]

        // Sum up all error counts from sessions
        for session in sessions {
            if let errorCounts = session.errorCounts {
                for (errorType, count) in errorCounts {
                    errorTotals[errorType, default: 0] += count
                }
            }
        }

        // Convert to array and sort by count
        let sorted = errorTotals.map { (key, value) in
            ErrorBreakdownData(errorType: key, count: value)
        }.sorted { $0.count > $1.count }

        // Return top N errors
        return Array(sorted.prefix(topCount))
    }

    private var totalErrors: Int {
        aggregatedErrors.reduce(0) { $0 + $1.count }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: themeManager.currentTheme.spacingM) {
            // Chart title
            HStack {
                Text("Top Mistakes")
                    .font(.system(size: themeManager.currentTheme.fontSizeBody, weight: .semibold))
                    .foregroundStyle(themeManager.currentTheme.textPrimary)

                Spacer()

                if totalErrors > 0 {
                    Text("\(totalErrors) total")
                        .font(.system(size: themeManager.currentTheme.fontSizeCaption))
                        .foregroundStyle(themeManager.currentTheme.textSecondary)
                }
            }

            if aggregatedErrors.isEmpty {
                // Empty state
                VStack(spacing: themeManager.currentTheme.spacingS) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: themeManager.currentTheme.iconSizeLarge))
                        .foregroundStyle(themeManager.currentTheme.textSecondary.opacity(0.3))

                    Text("No error data available")
                        .font(.system(size: themeManager.currentTheme.fontSizeFootnote))
                        .foregroundStyle(themeManager.currentTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(themeManager.currentTheme.surface.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusM))
            } else {
                // Horizontal bar chart
                VStack(spacing: themeManager.currentTheme.spacingS) {
                    ForEach(aggregatedErrors) { error in
                        HStack(spacing: themeManager.currentTheme.spacingM) {
                            // Error name
                            Text(error.errorType)
                                .font(.system(size: themeManager.currentTheme.fontSizeFootnote, weight: .medium))
                                .foregroundStyle(themeManager.currentTheme.textPrimary)
                                .frame(width: 100, alignment: .leading)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)

                            // Bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    // Background
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(themeManager.currentTheme.primary.opacity(0.1))
                                        .frame(height: 20)

                                    // Foreground
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    themeManager.currentTheme.primary,
                                                    themeManager.currentTheme.primary.opacity(0.7)
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(
                                            width: geometry.size.width * (Double(error.count) / Double(totalErrors)),
                                            height: 20
                                        )
                                }
                            }
                            .frame(height: 20)

                            // Count and percentage
                            VStack(alignment: .trailing, spacing: 0) {
                                Text("\(error.count)")
                                    .font(.system(size: themeManager.currentTheme.fontSizeFootnote, weight: .bold))
                                    .foregroundStyle(themeManager.currentTheme.textPrimary)

                                Text("\(Int((Double(error.count) / Double(totalErrors)) * 100))%")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(themeManager.currentTheme.textSecondary)
                            }
                            .frame(width: 40, alignment: .trailing)
                        }
                    }
                }
                .padding(.vertical, themeManager.currentTheme.spacingS)
            }
        }
    }
}

struct ErrorBreakdownData: Identifiable {
    let id = UUID()
    let errorType: String
    let count: Int
}

#Preview {
    let calendar = Calendar.current
    let now = Date()

    // Generate sample sessions with error data
    var sessions: [Session] = []
    for i in 0..<15 {
        let daysAgo = i
        if let sessionDate = calendar.date(byAdding: .day, value: -daysAgo, to: now) {
            let mistakes = Int.random(in: 5...15)
            let duration = TimeInterval.random(in: 3600...5400)

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
                "Lob Miss": Int.random(in: 0...2),
                "Power Over Control": Int.random(in: 0...3)
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

    return ErrorTypeBreakdownChart(sessions: sessions)
        .environmentObject(ThemeManager.shared)
        .padding()
        .background(AppTheme.current.backgroundPrimary)
}
