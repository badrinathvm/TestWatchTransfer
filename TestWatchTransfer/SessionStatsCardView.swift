//
//  SessionStatsCardView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/24/25.
//

import SwiftUI

struct SessionStatsCardView: View {
    @EnvironmentObject var themeManager: ThemeManager

    let title: String
    let value: String
    let subtitle: String?
    let trendValue: Double? // Positive for improvement, negative for decline
    let icon: String?

    init(title: String, value: String, subtitle: String? = nil, trendValue: Double? = nil, icon: String? = nil) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.trendValue = trendValue
        self.icon = icon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: themeManager.currentTheme.spacingS) {
            // Header with icon
            HStack(spacing: themeManager.currentTheme.spacingXS) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: themeManager.currentTheme.fontSizeCaption))
                        .foregroundStyle(themeManager.currentTheme.textSecondary)
                }

                Text(title)
                    .font(.system(size: themeManager.currentTheme.fontSizeCaption, weight: .medium))
                    .foregroundStyle(themeManager.currentTheme.textSecondary)
                    .lineLimit(1)

                Spacer()
            }

            // Main value
            HStack(alignment: .firstTextBaseline, spacing: themeManager.currentTheme.spacingXS) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(themeManager.currentTheme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                // Trend indicator
                if let trendValue = trendValue {
                    HStack(spacing: 2) {
                        Image(systemName: trendValue > 0 ? "arrow.up.right" : trendValue < 0 ? "arrow.down.right" : "minus")
                            .font(.system(size: 10, weight: .bold))

                        Text("\(abs(Int(trendValue)))%")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(trendValue > 0 ? .green : trendValue < 0 ? .red : .gray)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill((trendValue > 0 ? Color.green : trendValue < 0 ? Color.red : Color.gray).opacity(0.15))
                    )
                }
            }

            // Subtitle
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: themeManager.currentTheme.fontSizeFootnote))
                    .foregroundStyle(themeManager.currentTheme.textSecondary.opacity(0.8))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(themeManager.currentTheme.spacingM)
        .background(themeManager.currentTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusM))
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.currentTheme.radiusM)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            SessionStatsCardView(
                title: "Total Sessions",
                value: "24",
                subtitle: "Last 30 days",
                trendValue: 12,
                icon: "figure.pickleball"
            )

            SessionStatsCardView(
                title: "Avg Mistakes",
                value: "8.5",
                subtitle: "Per session",
                trendValue: -15,
                icon: "exclamationmark.circle.fill"
            )
        }

        HStack(spacing: 12) {
            SessionStatsCardView(
                title: "Best Session",
                value: "3",
                subtitle: "Mistakes",
                icon: "star.fill"
            )

            SessionStatsCardView(
                title: "Mistakes/Hour",
                value: "12.4",
                subtitle: "Average",
                trendValue: -8,
                icon: "clock.fill"
            )
        }
    }
    .environmentObject(ThemeManager.shared)
    .padding()
    .background(AppTheme.current.backgroundPrimary)
}
