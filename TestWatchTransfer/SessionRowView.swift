//
//  SessionRowView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI

struct SessionRowView: View {
    let session: Session
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: AppTheme.current.spacingL) {
            // Counter icon on the left
            ZStack {
                Circle()
                    .fill(AppTheme.current.primaryLight)
                    .frame(width: 56, height: 56)

                Image(systemName: "figure.pickleball")
                    .foregroundStyle(AppTheme.current.primary)
                    .font(.system(size: AppTheme.current.iconSizeLarge))
            }

            // Session info
            VStack(alignment: .leading, spacing: AppTheme.current.spacingXS) {
                Text(session.sessionName)
                    .font(.system(size: AppTheme.current.fontSizeTitle, weight: .semibold))
                    .foregroundStyle(.primary)

                HStack(spacing: AppTheme.current.spacingS) {
                    // Mistake count
                    HStack(spacing: AppTheme.current.spacingXS) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: AppTheme.current.fontSizeCaption))
                            .foregroundStyle(AppTheme.current.primary)
                        Text("\(session.mistakeCount)")
                            .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    Text("•")
                        .foregroundStyle(.secondary.opacity(0.5))

                    // Duration
                    Text(session.formattedDuration)
                        .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Time on the right
            VStack(alignment: .trailing, spacing: AppTheme.current.spacingXS) {
                Text(session.relativeTimeString)
                    .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                    .foregroundStyle(.secondary)

                Text(session.timeString)
                    .font(.system(size: AppTheme.current.fontSizeCaption))
                    .foregroundStyle(.secondary.opacity(0.7))
            }
        }
        .padding(AppTheme.current.spacingL)
        .background(AppTheme.current.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.current.radiusL))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.current.radiusL)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    let now = Date()
    let startTime = now.addingTimeInterval(-4380) // 73 minutes ago
    let mistakeTimeline = (0..<15).map { i in
        startTime.addingTimeInterval(Double(i) * 292) // Spread over 73 minutes
    }

    let session = Session(
        startTime: startTime,
        endTime: now,
        mistakeCount: 15,
        mistakeTimeline: mistakeTimeline
    )

    return SessionRowView(session: session)
        .environmentObject(ThemeManager.shared)
        .padding()
}
