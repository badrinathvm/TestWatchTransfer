//
//  OnboardingScreen4_Complications.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

struct OnboardingScreen4_Complications: View {
    private let steps = [
        ComplicationStep(number: 1, text: "Long press your watch face", icon: "hand.point.up.left.fill"),
        ComplicationStep(number: 2, text: "Tap 'Edit' or 'Customize'", icon: "pencil.circle.fill"),
        ComplicationStep(number: 3, text: "Select a complication slot", icon: "circle.grid.3x3.fill"),
        ComplicationStep(number: 4, text: "Choose 'Pickleball Rite'", icon: "checkmark.circle.fill")
    ]

    var body: some View {
        OnboardingPageView(
            title: "Quick Access from Your Watch Face",
            description: "Add Pickleball Rite to your watch face for instant access during games. No need to scroll through apps!"
        ) {
            VStack(spacing: AppTheme.current.spacingXXL) {
                // Watch face mockup
                ZStack {
                    // Watch outline
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.black)
                        .frame(width: 180, height: 220)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 3)
                        )

                    // Simplified watch face
                    VStack(spacing: 8) {
                        // Time display
                        Text("9:41")
                            .font(.system(size: 36, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)

                        // Date
                        Text("Monday, Oct 23")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))

                        Spacer()
                            .frame(height: 20)

                        // Complications area
                        HStack(spacing: 12) {
                            // Left complication
                            ComplicationBadge(icon: "heart.fill", color: .red)

                            // Center complication (Pickleball Rite - highlighted)
                            ComplicationBadge(
                                icon: "figure.pickleball",
                                color: AppTheme.current.primary,
                                isHighlighted: true
                            )

                            // Right complication
                            ComplicationBadge(icon: "calendar", color: .blue)
                        }
                    }
                    .padding(.vertical, 30)
                }

                // Step-by-step instructions
                VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                    Text("How to Add:")
                        .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))
                        .foregroundStyle(AppTheme.current.textPrimary)
                        .padding(.horizontal, AppTheme.current.spacingL)

                    VStack(spacing: AppTheme.current.spacingS) {
                        ForEach(steps) { step in
                            StepRow(step: step)
                        }
                    }
                    .padding(.horizontal, AppTheme.current.spacingL)
                }
            }
        }
    }
}

// Complication step model
struct ComplicationStep: Identifiable {
    let id = UUID()
    let number: Int
    let text: String
    let icon: String
}

// Step row component
struct StepRow: View {
    let step: ComplicationStep

    var body: some View {
        HStack(spacing: AppTheme.current.spacingM) {
            ZStack {
                Circle()
                    .fill(AppTheme.current.primaryLight)
                    .frame(width: 32, height: 32)

                Text("\(step.number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppTheme.current.primary)
            }

            Text(step.text)
                .font(.system(size: AppTheme.current.fontSizeBody))
                .foregroundStyle(AppTheme.current.textPrimary)

            Spacer()

            Image(systemName: step.icon)
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.current.textSecondary)
        }
        .padding(.vertical, AppTheme.current.spacingXS)
    }
}

// Complication badge component
struct ComplicationBadge: View {
    let icon: String
    let color: Color
    var isHighlighted: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: 40, height: 40)

            if isHighlighted {
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: 46, height: 46)
            }

            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
        }
    }
}

#Preview {
    OnboardingScreen4_Complications()
        .background(AppTheme.current.backgroundPrimary)
        .environmentObject(ThemeManager.shared)
}
