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
        VStack(alignment: .leading, spacing: 8) {
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
                .font(.system(size: 36, weight: .bold, design: .rounded))
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
        .padding()
        .frame(width: 150)
        .background(mistakeColor.opacity(0.1))
        .cornerRadius(12)
    }

    private var mistakeColor: Color {
        switch session.mistakeCount {
        case 0...5: return .green
        case 6...10: return .orange
        default: return .red
        }
    }
}
