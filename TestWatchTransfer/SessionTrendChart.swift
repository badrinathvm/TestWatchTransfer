//
//  SessionTrendChart.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/24/25.
//

import SwiftUI
import Charts

struct SessionTrendChart: View {
    @EnvironmentObject var themeManager: ThemeManager

    let sessions: [Session]
    let days: Int // Number of days to show (default 30)

    init(sessions: [Session], days: Int = 30) {
        self.sessions = sessions
        self.days = days
    }

    // Filter sessions to last N days
    private var filteredSessions: [Session] {
        let calendar = Calendar.current
        let now = Date()
        guard let cutoffDate = calendar.date(byAdding: .day, value: -days, to: now) else {
            return sessions
        }

        return sessions.filter { $0.startTime >= cutoffDate }
            .sorted(by: { $0.startTime < $1.startTime })
    }

    // Chart data points
    private var chartData: [TrendDataPoint] {
        filteredSessions.map { session in
            TrendDataPoint(
                date: session.startTime,
                mistakes: session.mistakeCount,
                mistakesPerHour: session.mistakesPerHour
            )
        }
    }

    // Calculate 7-day moving average
    private var movingAverageData: [MovingAveragePoint] {
        guard chartData.count >= 2 else { return [] }

        var result: [MovingAveragePoint] = []
        let windowSize = 7

        for i in 0..<chartData.count {
            let startIndex = max(0, i - windowSize + 1)
            let endIndex = i + 1
            let window = Array(chartData[startIndex..<endIndex])

            let average = window.reduce(0.0) { $0 + Double($1.mistakes) } / Double(window.count)

            result.append(MovingAveragePoint(
                date: chartData[i].date,
                average: average
            ))
        }

        return result
    }

    var body: some View {
        VStack(alignment: .leading, spacing: themeManager.currentTheme.spacingM) {
            // Chart title
            HStack {
                Text("Mistake Trend")
                    .font(.system(size: themeManager.currentTheme.fontSizeBody, weight: .semibold))
                    .foregroundStyle(themeManager.currentTheme.textPrimary)

                Spacer()

                Text("Last \(days) days")
                    .font(.system(size: themeManager.currentTheme.fontSizeCaption))
                    .foregroundStyle(themeManager.currentTheme.textSecondary)
            }

            if chartData.isEmpty {
                // Empty state
                VStack(spacing: themeManager.currentTheme.spacingS) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: themeManager.currentTheme.iconSizeLarge))
                        .foregroundStyle(themeManager.currentTheme.textSecondary.opacity(0.3))

                    Text("No data for this period")
                        .font(.system(size: themeManager.currentTheme.fontSizeFootnote))
                        .foregroundStyle(themeManager.currentTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(themeManager.currentTheme.surface.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusM))
            } else {
                // Chart
                Chart {
                    // Moving average line (background)
                    if movingAverageData.count >= 2 {
                        ForEach(movingAverageData) { point in
                            LineMark(
                                x: .value("Date", point.date),
                                y: .value("Average", point.average)
                            )
                            .foregroundStyle(themeManager.currentTheme.primary.opacity(0.4))
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 3]))
                        }
                    }

                    // Actual data points
                    ForEach(chartData) { point in
                        // Area fill
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Mistakes", point.mistakes)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    themeManager.currentTheme.primary.opacity(0.6),
                                    themeManager.currentTheme.primary.opacity(0.1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        // Line
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Mistakes", point.mistakes)
                        )
                        .foregroundStyle(themeManager.currentTheme.primary)
                        .lineStyle(StrokeStyle(lineWidth: 2.5))

                        // Points
                        PointMark(
                            x: .value("Date", point.date),
                            y: .value("Mistakes", point.mistakes)
                        )
                        .foregroundStyle(themeManager.currentTheme.primary)
                        .symbolSize(40)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: max(days / 4, 1))) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                            .font(.system(size: themeManager.currentTheme.fontSizeCaption))
                            .foregroundStyle(.secondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing) { value in
                        AxisGridLine()
                        AxisValueLabel()
                            .font(.system(size: themeManager.currentTheme.fontSizeCaption))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(height: 140)

                // Legend
                HStack(spacing: themeManager.currentTheme.spacingL) {
                    HStack(spacing: themeManager.currentTheme.spacingXS) {
                        Circle()
                            .fill(themeManager.currentTheme.primary)
                            .frame(width: 8, height: 8)

                        Text("Mistakes")
                            .font(.system(size: themeManager.currentTheme.fontSizeFootnote))
                            .foregroundStyle(themeManager.currentTheme.textSecondary)
                    }

                    if movingAverageData.count >= 2 {
                        HStack(spacing: themeManager.currentTheme.spacingXS) {
                            Rectangle()
                                .fill(themeManager.currentTheme.primary.opacity(0.4))
                                .frame(width: 12, height: 2)

                            Text("7-day avg")
                                .font(.system(size: themeManager.currentTheme.fontSizeFootnote))
                                .foregroundStyle(themeManager.currentTheme.textSecondary)
                        }
                    }
                }
            }
        }
    }
}

struct TrendDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let mistakes: Int
    let mistakesPerHour: Double
}

struct MovingAveragePoint: Identifiable {
    let id = UUID()
    let date: Date
    let average: Double
}

#Preview {
    let calendar = Calendar.current
    let now = Date()

    // Generate sample sessions
    var sessions: [Session] = []
    for i in 0..<25 {
        let daysAgo = i
        if let sessionDate = calendar.date(byAdding: .day, value: -daysAgo, to: now) {
            let mistakes = Int.random(in: 5...20)
            let duration = TimeInterval.random(in: 3600...7200)

            var mistakeTimeline: [Date] = []
            for j in 0..<mistakes {
                mistakeTimeline.append(sessionDate.addingTimeInterval(Double(j) * (duration / Double(mistakes))))
            }

            let session = Session(
                sessionName: "Practice",
                startTime: sessionDate,
                endTime: sessionDate.addingTimeInterval(duration),
                mistakeCount: mistakes,
                mistakeTimeline: mistakeTimeline
            )
            sessions.append(session)
        }
    }

    return SessionTrendChart(sessions: sessions)
        .environmentObject(ThemeManager.shared)
        .padding()
        .background(AppTheme.current.backgroundPrimary)
}
