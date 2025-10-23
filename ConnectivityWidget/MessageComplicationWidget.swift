//
//  MessageComplicationView.swift
//  Connectivity Watch App
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import WidgetKit

struct MessageEntry: TimelineEntry {
    let date: Date
    let message: String
}

struct MessageComplicationView: View {
    let entry: MessageEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            RectangularView(entry: entry)
        case .accessoryInline:
            InlineView(entry: entry)
        case .accessoryCircular:
            CircularView(entry: entry)
        case .accessoryCorner:
            CornerView(entry: entry)
        default:
            RectangularView(entry: entry)
        }
    }
}

// Rectangular complication view
struct RectangularView: View {
    let entry: MessageEntry

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.current.spacingXS) {
            HStack {
                Image(systemName: "message.fill")
                    .font(.caption2)
                Text("Latest Message")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(AppTheme.current.primary)

            Text(entry.message)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Inline complication view
struct InlineView: View {
    let entry: MessageEntry

    var body: some View {
        HStack(spacing: AppTheme.current.spacingXS) {
            Image(systemName: "message.fill")
            Text(entry.message)
                .lineLimit(1)
        }
    }
}

// Circular complication view
struct CircularView: View {
    let entry: MessageEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Image(systemName: "message.fill")
                    .font(.title3)
                Text(String(entry.message.prefix(2)))
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
    }
}

// Corner complication view
struct CornerView: View {
    let entry: MessageEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            Image(systemName: "message.fill")
                .font(.title2)
        }
        .widgetLabel {
            Text(entry.message)
                .lineLimit(1)
        }
    }
}

struct MessageComplicationWidget: Widget {
    let kind: String = "MessageComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MessageProvider()) { entry in
            MessageComplicationView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Latest Message")
        .description("Shows the most recent message received from iPhone")
        .supportedFamilies([
            .accessoryRectangular,
            .accessoryInline,
            .accessoryCircular,
            .accessoryCorner
        ])
    }
}

struct MessageProvider: TimelineProvider {
    func placeholder(in context: Context) -> MessageEntry {
        MessageEntry(date: Date(), message: "No messages yet")
    }

    func getSnapshot(in context: Context, completion: @escaping (MessageEntry) -> Void) {
        let entry = MessageEntry(date: Date(), message: getLatestMessage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> Void) {
        let currentDate = Date()
        let message = getLatestMessage()
        let entry = MessageEntry(date: currentDate, message: message)

        // Refresh every 15 minutes
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }

    private func getLatestMessage() -> String {
        let messages = SharedDataManager.shared.getMessages()
        return messages.first?.text ?? "No messages"
    }
}
