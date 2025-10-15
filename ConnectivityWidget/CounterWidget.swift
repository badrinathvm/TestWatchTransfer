import AppIntents
import WidgetKit
import SwiftUI

struct IncrementProvider: TimelineProvider {
    func placeholder(in context: Context) -> IncrementEntry {
        IncrementEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (IncrementEntry) -> ()) {
        let count = context.isPreview ? 0 : CounterManager.shared.currentCount
        let entry = IncrementEntry(date: Date(), count: count)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<IncrementEntry>) -> ()) {
        let currentDate = Date()
        let count = CounterManager.shared.currentCount
        let entry = IncrementEntry(date: currentDate, count: count)

        // Update timeline in 1 hour, but will be updated sooner when counter changes
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

        completion(timeline)
    }
}

struct IncrementEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct CounterWidgetEntryView : View {
    var entry: IncrementProvider.Entry
    @Environment(\.widgetFamily) var family

    // Progress gauge thresholds
    private var gaugeColor: Color {
        switch entry.count {
        case 1...5: return .green
        case 6...10: return .orange
        default: return .red
        }
    }

    private var progress: Double {
        // Scale progress to max of 15 for visualization
        min(Double(entry.count) / 15.0, 1.0)
    }

    var body: some View {
        switch family {
        case .accessoryCircular:
            Button(intent: IncrementCounterIntent()) {
                ZStack {
                    // Gauge progress
                    Gauge(value: progress) {
                        Text("\(entry.count)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(gaugeColor)
                }
            }
            .buttonStyle(.plain)

        case .accessoryRectangular:
            Button(intent: IncrementCounterIntent()) {
                Gauge(value: progress) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(gaugeColor)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Counter")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text("\(entry.count)")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                    }
                } currentValueLabel: {
                    Text("")
                }
                .gaugeStyle(.accessoryLinearCapacity)
                .tint(gaugeColor)
            }
            .buttonStyle(.plain)

        case .accessoryCorner:
            Button(intent: IncrementCounterIntent()) {
                // Gauge text style - shows count with curved progress arc
                Text("\(entry.count)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .widgetLabel {
                Gauge(value: progress) {
                    EmptyView()
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(gaugeColor)
            }

        case .accessoryInline:
            Button(intent: IncrementCounterIntent()) {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                    Text("\(entry.count)")
                        .fontWeight(.semibold)
                }
            }
            .buttonStyle(.plain)

        @unknown default:
            Button(intent: IncrementCounterIntent()) {
                Text("\(entry.count)")
            }
            .buttonStyle(.plain)
        }
    }
}

struct CounterWidget: Widget {
    let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: IncrementProvider()) { entry in
            CounterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Increment")
        .description("Track your increment counter")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryCorner,
            .accessoryInline
        ])
    }
}

#Preview(as: .accessoryCircular) {
    CounterWidget()
} timeline: {
    IncrementEntry(date: .now, count: 42)
    IncrementEntry(date: .now, count: 100)
}

#Preview(as: .accessoryRectangular) {
    CounterWidget()
} timeline: {
    IncrementEntry(date: .now, count: 42)
}    
