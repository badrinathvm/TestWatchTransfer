//
//  MetricCardView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI

struct MetricCardView: View {
    let icon: String
    let value: String
    let label: String
    let iconColor: Color

    var body: some View {
        VStack(spacing: AppTheme.current.spacingM) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: AppTheme.current.iconSizeLarge))
                    .foregroundStyle(iconColor)
            }

            // Value
            Text(value)
                .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            // Label
            Text(label)
                .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.current.spacingXL)
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
    HStack(spacing: AppTheme.current.spacingM) {
        MetricCardView(
            icon: "clock.fill",
            value: "1h 13m",
            label: "Duration",
            iconColor: AppTheme.current.primary
        )

        MetricCardView(
            icon: "exclamationmark.circle.fill",
            value: "15",
            label: "Mistakes",
            iconColor: AppTheme.current.primary
        )
    }
    .padding()
}

