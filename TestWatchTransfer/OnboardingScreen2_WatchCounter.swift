//
//  OnboardingScreen2_WatchCounter.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

struct OnboardingScreen2_WatchCounter: View {
    @State private var demoCount: Int = 0

    private var demoColor: Color {
        switch demoCount {
        case 0...10:
            return .green
        case 11...20:
            return .yellow
        default:
            return .red
        }
    }

    private var progressValue: Double {
        min(Double(demoCount) / 30.0, 1.0)
    }

    var body: some View {
        OnboardingPageView(
            title: "Count Mistakes on Your Watch",
            description: "Tap the counter during play. It's fast, glanceable, and won't interrupt your game."
        ) {
            VStack(spacing: AppTheme.current.spacingXXL) {
                // Watch counter mockup (interactive)
                VStack(spacing: AppTheme.current.spacingL) {
                    // Circular progress ring with count
                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                            .frame(width: 160, height: 160)

                        // Progress ring
                        Circle()
                            .trim(from: 0, to: progressValue)
                            .stroke(demoColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.3), value: progressValue)

                        // Tap target
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 140, height: 140)
                            .contentShape(Circle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    demoCount += 1
                                }
                            }

                        // Count display
                        VStack(spacing: 4) {
                            Text("\(demoCount)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(demoColor)
                                .contentTransition(.numericText())

                            Text("mistakes")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Instruction text
                    Text("👆 Tap the circle to try it")
                        .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                        .foregroundStyle(AppTheme.current.primary)
                        .opacity(demoCount == 0 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: demoCount)
                }

                // Feature highlights
                VStack(spacing: AppTheme.current.spacingM) {
                    FeatureRow(
                        icon: "hand.tap.fill",
                        text: "Tap the ring to count",
                        color: AppTheme.current.primary
                    )

                    FeatureRow(
                        icon: "plus.slash.minus",
                        text: "Use +/− for adjustments",
                        color: AppTheme.current.primary
                    )

                    FeatureRow(
                        icon: "paperplane.fill",
                        text: "Submit when done",
                        color: AppTheme.current.primary
                    )
                }
                .padding(.horizontal, AppTheme.current.spacingXL)

                // Reset demo button
                if demoCount > 0 {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            demoCount = 0
                        }
                    }) {
                        Text("Reset Demo")
                            .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                            .foregroundStyle(AppTheme.current.textSecondary)
                    }
                }
            }
        }
    }
}

// Feature row component
struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: AppTheme.current.spacingM) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 24)

            Text(text)
                .font(.system(size: AppTheme.current.fontSizeBody))
                .foregroundStyle(AppTheme.current.textPrimary)

            Spacer()
        }
    }
}

#Preview {
    OnboardingScreen2_WatchCounter()
        .background(AppTheme.current.backgroundPrimary)
        .environmentObject(ThemeManager.shared)
}
