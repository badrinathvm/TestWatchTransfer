//
//  CounterSubmitView.swift
//  Connectivity Watch App
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import WidgetKit
import Combine

struct CounterSubmitView: View {
    @State private var count: Int = 0
    @State private var showSubmitConfirmation = false
    @State private var submittedCount: Int = 0
    @Environment(\.scenePhase) private var scenePhase

    // Color based on mistake count
    private var countColor: Color {
        switch count {
        case 0...10: return .green
        case 11...20: return .orange
        default: return .red
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
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.orange)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

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
                VStack(spacing: 4) {
                    Text("\(count)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(countColor)
                        .contentTransition(.numericText())

                    Text("mistakes")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                incrementWithHaptic()
            }

            // Bottom action buttons - single row
            HStack(spacing: 8) {
                // Minus button
                Button(action: {
                    decrementWithHaptic()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.red)
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
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.green)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)

                // Reset button
                Button(action: {
                    resetWithHaptic()
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)

                // Submit button
                Button(action: {
                    submitSession()
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .disabled(count == 0)
                .opacity(count == 0 ? 0.3 : 1.0)
            }
            .padding(.all, 12)
        }
        .alert("Session Submitted!", isPresented: $showSubmitConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your session with \(submittedCount) mistakes has been saved to your iPhone")
        }
        .onAppear {
            refreshCount()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                refreshCount()
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

    private func submitSession() {
        // Save the count before resetting
        submittedCount = count

        let sessionData = SessionData(
            sessionName: nil, // Will auto-generate based on time
            startTime: CounterManager.shared.sessionStartTime,
            endTime: Date(),
            mistakeCount: submittedCount,
            mistakeTimeline: CounterManager.shared.mistakeTimeline,
            notes: nil
        )

        print("📤 Submitting session with \(submittedCount) mistakes")
        WatchConnectivityManager.shared.sendSession(sessionData)

        // Haptic feedback
        WKInterfaceDevice.current().play(.success)

        // Reset for next session
        CounterManager.shared.reset()
        count = 0

        showSubmitConfirmation = true
    }
}
