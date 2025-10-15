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
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 20) {
            Text("Counter")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("\(count)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.blue)

            HStack(spacing: 15) {
                Button(action: {
                  //  CounterManager.shared.decrement()
                    count = CounterManager.shared.currentCount
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)

                Button(action: {
                    CounterManager.shared.increment()
                    count = CounterManager.shared.currentCount
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 10) {
                Button(action: {
                    CounterManager.shared.reset()
                    count = CounterManager.shared.currentCount
                }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .tint(.orange)

                Button(action: {
                    submitSession()
                }) {
                    Label("Submit", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .disabled(count == 0)
            }
        }
        .padding()
        .alert("Session Submitted!", isPresented: $showSubmitConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your session has been saved to the iOS app")
        }
        .onAppear {
            // Always refresh count when view appears
            refreshCount()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // Refresh when app becomes active
            if newPhase == .active {
                refreshCount()
            }
        }
    }

    private func refreshCount() {
        count = CounterManager.shared.currentCount
    }

    private func submitSession() {
        let sessionData = SessionData(
            sessionName: nil, // Will auto-generate based on time
            startTime: CounterManager.shared.sessionStartTime,
            endTime: Date(),
            mistakeCount: count,
            mistakeTimeline: CounterManager.shared.mistakeTimeline,
            notes: nil
        )

        WatchConnectivityManager.shared.sendSession(sessionData)

        // Reset for next session
        CounterManager.shared.reset()
        count = 0

        showSubmitConfirmation = true
    }
}
