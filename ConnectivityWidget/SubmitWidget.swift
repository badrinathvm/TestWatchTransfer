//
//  SubmitWidget.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import WidgetKit

struct SubmitEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct SubmitWidgetEntryView: View {
    var entry: SubmitProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        widgetContent
          //  .widgetURL(URL(string: "watchapp://counter-submit"))
    }

    @ViewBuilder
    private var widgetContent: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 2) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                    Text("\(entry.count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
            }

        case .accessoryRectangular:
            HStack(spacing: 8) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Submit Counter")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text("\(entry.count)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }

        case .accessoryCorner:
            ZStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.green)
            }
            .widgetLabel {
                Text("Submit")
                    .font(.system(size: 12, weight: .semibold))
            }

        case .accessoryInline:
            HStack(spacing: 4) {
                Image(systemName: "paperplane.fill")
                Text("Submit: \(entry.count)")
                    .fontWeight(.semibold)
            }

        @unknown default:
            Text("\(entry.count)")
        }
    }
}

struct SubmitWidget: Widget {
    let kind: String = "SubmitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SubmitProvider()) { entry in
            SubmitWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Submit Counter")
        .description("Tap to open app and submit counter to iPhone")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryCorner,
            .accessoryInline
        ])
    }
}

struct SubmitProvider: TimelineProvider {
    func placeholder(in context: Context) -> SubmitEntry {
        SubmitEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SubmitEntry) -> ()) {
        let count = context.isPreview ? 0 : CounterManager.shared.currentCount
        let entry = SubmitEntry(date: Date(), count: count)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SubmitEntry>) -> ()) {
        let currentDate = Date()
        let count = CounterManager.shared.currentCount
        let entry = SubmitEntry(date: currentDate, count: count)

        // Update timeline in 1 hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

        completion(timeline)
    }
}
