//
//  SessionRowView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI

struct SessionRowView: View {
    let session: Session

    var body: some View {
        HStack(spacing: 16) {
            // Counter icon on the left
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: "figure.pickleball")
                    .font(.system(size: 28))
                    .foregroundStyle(.orange)
            }

            // Session info
            VStack(alignment: .leading, spacing: 4) {
                Text(session.sessionName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)

                HStack(spacing: 8) {
                    // Mistake count
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.orange)
                        Text("\(session.mistakeCount)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    Text("•")
                        .foregroundStyle(.secondary.opacity(0.5))

                    // Duration
                    Text(session.formattedDuration)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Time on the right
            VStack(alignment: .trailing, spacing: 4) {
                Text(session.relativeTimeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)

                Text(session.timeString)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary.opacity(0.7))
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
        .padding()
}
