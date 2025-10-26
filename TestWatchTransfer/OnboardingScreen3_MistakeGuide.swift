//
//  OnboardingScreen3_MistakeGuide.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

struct OnboardingScreen3_MistakeGuide: View {
    // List of common pickleball mistakes
    private let mistakes = [
        MistakeType(icon: "exclamationmark.triangle.fill", text: "Serve errors (net or out)", color: .red),
        MistakeType(icon: "hand.raised.fill", text: "Missed returns", color: .orange),
        MistakeType(icon: "figure.walk", text: "Kitchen faults", color: .yellow),
        MistakeType(icon: "bolt.fill", text: "Overhits/unforced errors", color: .purple),
        MistakeType(icon: "arrow.triangle.2.circlepath", text: "Poor positioning/recovery", color: .blue)
    ]

    var body: some View {
        OnboardingPageView(
            title: "What Should I Count?",
            description: "Track common mistakes to identify patterns and improve your game. Every mistake is a learning opportunity!"
        ) {
            VStack(spacing: AppTheme.current.spacingXL) {
                // GIF placeholder (will show actual counting demo when GIF is added)
                GIFPlaceholderView(
                    title: "Counting Demo",
                    subtitle: "Add your GIF demonstrating when to tap the counter"
                )
                .frame(height: 180)

                // Common mistakes list
                VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                    Text("Common Mistakes to Track:")
                        .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))
                        .foregroundStyle(AppTheme.current.textPrimary)
                        .padding(.horizontal, AppTheme.current.spacingL)

                    VStack(spacing: AppTheme.current.spacingS) {
                        ForEach(mistakes) { mistake in
                            MistakeRow(mistake: mistake)
                        }
                    }
                    .padding(.horizontal, AppTheme.current.spacingL)
                }
            }
        }
    }
}

// Mistake type model
struct MistakeType: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
}

// Mistake row component
struct MistakeRow: View {
    let mistake: MistakeType

    var body: some View {
        HStack(spacing: AppTheme.current.spacingM) {
            ZStack {
                Circle()
                    .fill(mistake.color.opacity(0.15))
                    .frame(width: 32, height: 32)

                Image(systemName: mistake.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(mistake.color)
            }

            Text(mistake.text)
                .font(.system(size: AppTheme.current.fontSizeBody))
                .foregroundStyle(AppTheme.current.textPrimary)

            Spacer()
        }
        .padding(.vertical, AppTheme.current.spacingXS)
    }
}

#Preview {
    OnboardingScreen3_MistakeGuide()
        .background(AppTheme.current.backgroundPrimary)
        .environmentObject(ThemeManager.shared)
}
