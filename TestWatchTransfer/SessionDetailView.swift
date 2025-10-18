//
//  SessionDetailView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//
import SwiftUI
import SwiftData

struct SessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var session: Session
    @State private var isEditingName = false
    @FocusState private var isNameFieldFocused: Bool

    // Formatted date string
    private var dateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: session.startTime)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                VStack(spacing: 12) {
                    // Activity Icon
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 80, height: 80)

                        Image(systemName: "figure.pickleball")
                            .font(.system(size: 40))
                            .foregroundStyle(.orange)
                    }
                    .padding(.top, 20)

                    // Session Name (Editable)
                    if isEditingName {
                        TextField("Session Name", text: $session.sessionName)
                            .font(.system(size: 28, weight: .bold))
                            .multilineTextAlignment(.center)
                            .focused($isNameFieldFocused)
                            .textFieldStyle(.plain)
                            .onSubmit {
                                isEditingName = false
                                saveChanges()
                            }
                            .padding(.horizontal, 40)
                    } else {
                        HStack(spacing: 8) {
                            Text(session.sessionName)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.primary)

                            Button(action: {
                                isEditingName = true
                                isNameFieldFocused = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.orange)
                            }
                        }
                    }

                    // Date and Time
                    Text(dateTimeString)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }

                // Metrics Cards (2-column grid)
                HStack(spacing: 12) {
                    MetricCardView(
                        icon: "clock.fill",
                        value: session.formattedDuration,
                        label: "Duration",
                        iconColor: .orange
                    )

                    MetricCardView(
                        icon: "exclamationmark.circle.fill",
                        value: "\(session.mistakeCount)",
                        label: "Mistakes",
                        iconColor: .orange
                    )
                }
                .padding(.horizontal, 20)

                // Mistake Timeline Chart
                MistakeTimelineChart(session: session)
                    .padding(.horizontal, 20)

                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.system(size: 28))
//                        .foregroundStyle(.secondary.opacity(0.3))
//                        .symbolRenderingMode(.hierarchical)
//                }
//            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // TODO: Share functionality
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundStyle(.orange)
                }
            }
        }
    }

    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save session: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Session.self, configurations: config)

    let now = Date()
    let startTime = now.addingTimeInterval(-4380) // 73 minutes ago
    let mistakeTimeline = (0..<15).map { i in
        startTime.addingTimeInterval(Double(i) * 292)
    }

    let session = Session(
        sessionName: "Pickleball",
        startTime: startTime,
        endTime: now,
        mistakeCount: 15,
        mistakeTimeline: mistakeTimeline
    )

    container.mainContext.insert(session)

    return NavigationStack {
        SessionDetailView(session: session)
            .modelContainer(container)
    }
}
