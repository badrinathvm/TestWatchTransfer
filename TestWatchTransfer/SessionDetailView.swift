//
//  SessionDetailView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//
import SwiftUI
import SwiftData
import MapKit

struct SessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme

    @Bindable var session: Session
    @State private var isEditingName = false
    @FocusState private var isNameFieldFocused: Bool
    @State private var isEditingLocation = false
    @FocusState private var isLocationFieldFocused: Bool

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
                            .fill(AppTheme.current.primaryLight)
                            .frame(width: 80, height: 80)

                        Image(systemName: "figure.pickleball")
                            .font(.system(size: AppTheme.current.iconSizeXLarge))
                            .foregroundStyle(AppTheme.current.primary)
                    }
                    .padding(.top, AppTheme.current.spacingXL)

                    // Session Name (Editable)
                    if isEditingName {
                        TextField("Session Name", text: $session.sessionName)
                            .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold))
                            .multilineTextAlignment(.center)
                            .focused($isNameFieldFocused)
                            .textFieldStyle(.plain)
                            .onSubmit {
                                isEditingName = false
                                saveChanges()
                            }
                            .padding(.horizontal, 40)
                    } else {
                        HStack(spacing: AppTheme.current.spacingS) {
                            Text(session.sessionName)
                                .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold))
                                .foregroundStyle(AppTheme.current.textPrimary)

                            Button(action: {
                                isEditingName = true
                                isNameFieldFocused = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: AppTheme.current.iconSizeMedium))
                                    .foregroundStyle(AppTheme.current.primary)
                            }
                        }
                    }

                    // Date and Time
                    Text(dateTimeString)
                        .font(.system(size: AppTheme.current.fontSizeBody))
                        .foregroundStyle(AppTheme.current.textSecondary)
                }

                // Metrics Cards (2-column grid)
                HStack(spacing: AppTheme.current.spacingM) {
                    MetricCardView(
                        icon: "clock.fill",
                        value: session.formattedDuration,
                        label: "Duration",
                        iconColor: AppTheme.current.primary
                    )

                    MetricCardView(
                        icon: "exclamationmark.circle.fill",
                        value: "\(session.mistakeCount)",
                        label: "Mistakes",
                        iconColor: AppTheme.current.primary
                    )
                }
                .padding(.horizontal, AppTheme.current.spacingXL)

                // Mistake Timeline Chart
                MistakeTimelineChart(session: session)
                    .padding(.horizontal, AppTheme.current.spacingXL)

                // Error Tracking Section
                VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                    // Error summary card
                    ErrorSummaryCard(session: session)
                        .padding(.horizontal, AppTheme.current.spacingXL)
                }

                // Location Section (if available)
                if let latitude = session.latitude,
                   let longitude = session.longitude {
                    VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                        // Section title
                        Text("Location")
                            .font(.system(size: AppTheme.current.fontSizeTitle, weight: .semibold))
                            .foregroundStyle(AppTheme.current.textPrimary)
                            .padding(.horizontal, AppTheme.current.spacingXL)

                        // Map view
                        Map(position: .constant(.region(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )))) {
                            Marker("Session Location", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                .tint(AppTheme.current.primary)
                        }
                        .frame(height: 200)
                        .cornerRadius(AppTheme.current.radiusM)
                        .padding(.horizontal, AppTheme.current.spacingXL)

                        // Location details card
                        VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                            // Location name (editable)
                            HStack(spacing: AppTheme.current.spacingS) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: AppTheme.current.iconSizeMedium))
                                    .foregroundStyle(AppTheme.current.primary)

                                if isEditingLocation {
                                    TextField("Location Name", text: Binding(
                                        get: { session.locationName ?? "" },
                                        set: { session.locationName = $0.isEmpty ? nil : $0 }
                                    ))
                                    .font(.system(size: AppTheme.current.fontSizeBody, weight: .medium))
                                    .focused($isLocationFieldFocused)
                                    .textFieldStyle(.plain)
                                    .onSubmit {
                                        isEditingLocation = false
                                        saveChanges()
                                    }
                                } else {
                                    Text(session.locationName ?? "Unknown Location")
                                        .font(.system(size: AppTheme.current.fontSizeBody, weight: .medium))
                                        .foregroundStyle(AppTheme.current.textPrimary)

                                    Button(action: {
                                        isEditingLocation = true
                                        isLocationFieldFocused = true
                                    }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.system(size: AppTheme.current.iconSizeSmall))
                                            .foregroundStyle(AppTheme.current.primary)
                                    }
                                }

                                Spacer()

                                // Maps button
                                Button(action: {
                                    openInMaps(latitude: latitude, longitude: longitude)
                                }) {
                                    Image(systemName: "arrow.up.right.circle.fill")
                                        .font(.system(size: AppTheme.current.iconSizeMedium))
                                        .foregroundStyle(AppTheme.current.primary)
                                }
                            }
                        }
                        .padding(AppTheme.current.spacingL)
                        .background(AppTheme.current.surface)
                        .cornerRadius(AppTheme.current.radiusM)
                        .padding(.horizontal, AppTheme.current.spacingXL)
                    }
                }

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
                        .font(.system(size: AppTheme.current.iconSizeMedium))
                        .foregroundStyle(AppTheme.current.primary)
                }
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(uiColor: .systemBackground), for: .tabBar)
        .toolbarColorScheme(colorScheme, for: .tabBar)
    }

    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save session: \(error)")
        }
    }

    private func openInMaps(latitude: Double, longitude: Double) {
        let urlString = "maps://?ll=\(latitude),\(longitude)&q=Session%20Location"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
