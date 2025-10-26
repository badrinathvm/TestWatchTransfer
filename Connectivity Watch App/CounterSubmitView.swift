//
//  CounterSubmitView.swift
//  Connectivity Watch App
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import WidgetKit
import Combine
import CoreLocation

struct CounterSubmitView: View {
    @State private var count: Int = 0
    @State private var showSubmitConfirmation = false
    @State private var submittedCount: Int = 0
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var locationManager = LocationManager.shared

    // Color based on mistake count
    private var countColor: Color {
        switch count {
        case 0...10: return AppTheme.current.success
        case 11...20: return AppTheme.current.warning
        default: return AppTheme.current.error
        }
    }

    // Progress value for circular ring (0.0 to 1.0)
    private var progress: Double {
        min(Double(count) / 30.0, 1.0)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with pickleball icon
            HStack {
                Image(systemName: "figure.pickleball")
                    .font(.system(size: AppTheme.current.iconSizeMedium, weight: .semibold))
                    .foregroundStyle(AppTheme.current.primary)

                Spacer()
            }
            .padding(.horizontal, AppTheme.current.spacingL)
            .padding(.top, AppTheme.current.spacingS)

            // Main counter area with circular progress ring (tap to increment)
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 12)
                    .frame(width: 140, height: 140)

                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(countColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: progress)

                // Counter text
                VStack(spacing: AppTheme.current.spacingXS) {
                    Text("\(count)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(countColor)
                        .contentTransition(.numericText())

                    Text("mistakes")
                        .font(.system(size: AppTheme.current.fontSizeCaption, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                incrementWithHaptic()
            }

            // Bottom action buttons - single row
            HStack(spacing: AppTheme.current.spacingS) {
                // Minus button
                Button(action: {
                    decrementWithHaptic()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: AppTheme.current.iconSizeLarge, weight: .medium))
                        .foregroundStyle(AppTheme.current.error)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .disabled(count == 0)
                .opacity(count == 0 ? 0.3 : 1.0)

                // Plus button
                Button(action: {
                    incrementWithHaptic()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: AppTheme.current.iconSizeLarge, weight: .medium))
                        .foregroundStyle(AppTheme.current.success)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)

                // Reset button
                Button(action: {
                    resetWithHaptic()
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: AppTheme.current.iconSizeLarge, weight: .medium))
                        .foregroundStyle(AppTheme.current.warning)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)

                // Submit button
                Button(action: {
                    submitSession()
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.system(size: AppTheme.current.iconSizeLarge, weight: .medium))
                        .foregroundStyle(AppTheme.current.primary)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .disabled(count == 0)
                .opacity(count == 0 ? 0.3 : 1.0)
            }
            .padding(.all, AppTheme.current.spacingM)
        }
        .alert("Session Submitted!", isPresented: $showSubmitConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your session with \(submittedCount) mistakes has been saved to your iPhone")
        }
        .onAppear {
            refreshCount()

            // Clear any cached location from previous session
            locationManager.clearLocation()

            // Debug: Print current authorization status
            print("📍 Current location authorization: \(locationManager.authorizationStatus.rawValue)")
            print("📍 Status details: \(authorizationStatusString(locationManager.authorizationStatus))")

            // Request location permission on first launch
            if locationManager.authorizationStatus == .notDetermined {
                print("📍 Requesting location permission...")
                locationManager.requestLocationPermission()
            } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                print("⚠️ Location permission denied or restricted. User needs to enable in Settings.")
            } else {
                print("✅ Location permission already granted")
                // Request location early for better accuracy when submitting
                locationManager.requestLocation()
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                refreshCount()

                // Request fresh location when app becomes active
                if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    print("📍 App became active - requesting location update")
                    locationManager.requestLocation()
                }
            }
        }
    }

    private func refreshCount() {
        count = CounterManager.shared.currentCount
    }

    private func incrementWithHaptic() {
        CounterManager.shared.increment()
        count = CounterManager.shared.currentCount

        // Haptic feedback
        WKInterfaceDevice.current().play(.click)
    }

    private func decrementWithHaptic() {
        if count > 0 {
            CounterManager.shared.decrement()
            count = CounterManager.shared.currentCount

            // Haptic feedback
            WKInterfaceDevice.current().play(.click)
        }
    }

    private func resetWithHaptic() {
        CounterManager.shared.reset()
        count = CounterManager.shared.currentCount

        // Haptic feedback
        WKInterfaceDevice.current().play(.success)
    }

    private func authorizationStatusString(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Authorized Always"
        case .authorizedWhenInUse: return "Authorized When In Use"
        @unknown default: return "Unknown"
        }
    }

    private func submitSession() {
        // Save the count before resetting
        submittedCount = count

        // Request FRESH location right before submitting
        print("📍 Requesting FRESH location for submission...")
        print("📍 Authorization status: \(authorizationStatusString(locationManager.authorizationStatus))")

        // Store old location and name for comparison
        let oldLocation = locationManager.currentLocation
        let oldLocationName = locationManager.locationName
        if let old = oldLocation {
            print("📍 Old cached location: \(old.coordinate.latitude), \(old.coordinate.longitude)")
            print("📍 Old location timestamp: \(old.timestamp)")
            print("📍 Old location name: \(oldLocationName ?? "nil")")
        } else {
            print("📍 No old location cached")
        }

        locationManager.requestLocation()

        // Give location more time to acquire fresh GPS position AND complete reverse geocoding (4 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Log geocoding status
            if locationManager.isGeocodingInProgress {
                print("⚠️ WARNING: Reverse geocoding still in progress, location name may be incomplete")
            }

            // Determine which location name to use
            var finalLocationName = locationManager.locationName

            // If location is the same as before and we have an old name, use it
            if let newLocation = locationManager.currentLocation,
               let old = oldLocation,
               old.coordinate.latitude == newLocation.coordinate.latitude &&
               old.coordinate.longitude == newLocation.coordinate.longitude {
                print("⚠️ Same location as before, preserving old location name")
                finalLocationName = oldLocationName
            }

            let sessionData = SessionData(
                sessionName: nil, // Will auto-generate based on time
                startTime: CounterManager.shared.sessionStartTime,
                endTime: Date(),
                mistakeCount: submittedCount,
                mistakeTimeline: CounterManager.shared.mistakeTimeline,
                notes: nil,
                latitude: locationManager.currentLocation?.coordinate.latitude,
                longitude: locationManager.currentLocation?.coordinate.longitude,
                locationName: finalLocationName
            )

            print("📤 Submitting session with \(submittedCount) mistakes")
            if let location = locationManager.currentLocation {
                print("📍 Final location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                print("📍 Location timestamp: \(location.timestamp)")
                print("📍 Location age: \(Date().timeIntervalSince(location.timestamp)) seconds")
                print("📍 Final location name being saved: \(finalLocationName ?? "Unknown")")

                // Check if this is a fresh location
                if let old = oldLocation, old.coordinate.latitude == location.coordinate.latitude && old.coordinate.longitude == location.coordinate.longitude {
                    print("⚠️ WARNING: Using same location as before - preserved old name")
                } else {
                    print("✅ New location acquired with new name")
                }
            } else {
                print("⚠️ No location available for this session")
            }

            WatchConnectivityManager.shared.sendSession(sessionData)

            // Haptic feedback
            WKInterfaceDevice.current().play(.success)

            // Reset for next session
            CounterManager.shared.reset()
            count = 0

            showSubmitConfirmation = true
        }
    }
}
