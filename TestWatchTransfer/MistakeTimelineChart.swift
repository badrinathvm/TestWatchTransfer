//
//  MistakeTimelineChart.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import Charts

struct MistakeTimelineChart: View {
    let session: Session

    // Convert mistake timeline to chart data
    private var chartData: [ChartDataPoint] {
        var data: [ChartDataPoint] = []
        let startTime = session.startTime

        // Add starting point (0 mistakes at time 0)
        data.append(ChartDataPoint(timeInMinutes: 0, cumulativeMistakes: 0))

        // Add each mistake timestamp
        for (index, mistakeTime) in session.mistakeTimeline.enumerated() {
            let timeInterval = mistakeTime.timeIntervalSince(startTime)
            let minutes = timeInterval / 60.0
            data.append(ChartDataPoint(timeInMinutes: minutes, cumulativeMistakes: index + 1))
        }
        print(data)
        return data
    }

    // Calculate the most active period (15-minute intervals)
    private var mostActivePeriod: String {
        guard !session.mistakeTimeline.isEmpty else { return "N/A" }

        let durationMinutes = Int(session.duration / 60)
        let intervalSize = 15 // 15-minute intervals
        var intervalCounts: [Int: Int] = [:]

        // Count mistakes in each 15-minute interval
        for mistakeTime in session.mistakeTimeline {
            let timeFromStart = mistakeTime.timeIntervalSince(session.startTime)
            let minutes = Int(timeFromStart / 60)
            let interval = minutes / intervalSize
            intervalCounts[interval, default: 0] += 1
        }

        // Find the interval with most mistakes
        if let maxInterval = intervalCounts.max(by: { $0.value < $1.value }) {
            let startMin = maxInterval.key * intervalSize
            let endMin = min(startMin + intervalSize, durationMinutes)
            return "\(startMin)-\(endMin) min"
        }

        return "N/A"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Chart
            Chart(chartData) { dataPoint in
                AreaMark(
                    x: .value("Time", dataPoint.timeInMinutes),
                    y: .value("Mistakes", dataPoint.cumulativeMistakes)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.current.primary.opacity(0.6), AppTheme.current.primary.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Time", dataPoint.timeInMinutes),
                    y: .value("Mistakes", dataPoint.cumulativeMistakes)
                )
                .foregroundStyle(AppTheme.current.primary)
                .lineStyle(StrokeStyle(lineWidth: 2.5))
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let minutes = value.as(Double.self) {
                            Text("\(Int(minutes))")
                                .font(.system(size: AppTheme.current.fontSizeCaption))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let count = value.as(Int.self) {
                            Text("\(count)")
                                .font(.system(size: AppTheme.current.fontSizeCaption))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .chartXAxisLabel("Time (min)", alignment: .center)
            .chartYAxisLabel("Mistakes", alignment: .trailing)
            .frame(height: 200)

            Divider()
                .padding(.vertical, 4)

            // Additional metrics
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mistakes per hour")
                        .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(String(format: "%.1f", session.mistakesPerHour))
                        .font(.system(size: AppTheme.current.fontSizeTitle, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Most active period")
                        .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(mostActivePeriod)
                        .font(.system(size: AppTheme.current.fontSizeTitle, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(AppTheme.current.spacingXL)
        .background(AppTheme.current.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.current.radiusL))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.current.radiusL)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let timeInMinutes: Double
    let cumulativeMistakes: Int
}

#Preview {
    let now = Date()
    let startTime = now.addingTimeInterval(-4380) // 73 minutes ago
    let mistakeTimeline = (0..<15).map { i in
        startTime.addingTimeInterval(Double(i) * 292)
    }

    let session = Session(
        startTime: startTime,
        endTime: now,
        mistakeCount: 15,
        mistakeTimeline: mistakeTimeline
    )

    return MistakeTimelineChart(session: session)
        .padding()
}
