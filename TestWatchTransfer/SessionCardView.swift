//
//  SessionCardView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI

struct SessionCardView: View {
    let session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.current.spacingS) {
            HStack {
                Text(session.relativeTimeString)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(session.timeString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("\(session.mistakeCount)")
                .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold, design: .rounded))
                .foregroundColor(mistakeColor)

            Text("mistakes")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(session.formattedDuration)
                .font(.caption2)
                .foregroundColor(.secondary)

            if let notes = session.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(AppTheme.current.spacingL)
        .frame(width: 150)
        .background(mistakeColor.opacity(0.1))
        .cornerRadius(AppTheme.current.radiusM)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.current.radiusM)
                .stroke(mistakeColor.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    private var mistakeColor: Color {
        switch session.mistakeCount {
        case 0...5: return AppTheme.current.success
        case 6...10: return AppTheme.current.warning
        default: return AppTheme.current.error
        }
    }
}
