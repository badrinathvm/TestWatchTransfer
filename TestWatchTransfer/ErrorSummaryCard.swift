//
//  ErrorSummaryCard.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/21/25.
//

import SwiftUI

struct ErrorSummaryCard: View {
    let session: Session
    @State private var showErrorCategorize: Bool = false

    private var errorCounts: [(ErrorType, Int)] {
        guard let counts = session.errorCounts else { return [] }

        return counts.compactMap { key, value in
            guard let errorType = ErrorType.allCases.first(where: { $0.rawValue == key }) else {
                return nil
            }
            return (errorType, value)
        }
        .filter { $0.1 > 0 }
        .sorted { $0.1 > $1.1 } // Sort by count descending
    }

    private var totalCategorizedErrors: Int {
        errorCounts.reduce(0) { $0 + $1.1 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
            if errorCounts.isEmpty {
                // Empty state
                HStack(spacing: AppTheme.current.spacingM) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.current.primaryLight)
                            .frame(width: 44, height: 44)

                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: AppTheme.current.iconSizeMedium))
                            .foregroundStyle(AppTheme.current.primary)
                    }

                    VStack(alignment: .leading, spacing: AppTheme.current.spacingXS) {
                        Text("No Errors Categorized")
                            .font(.system(size: AppTheme.current.fontSizeBody, weight: .medium))
                            .foregroundStyle(AppTheme.current.textPrimary)

                        Text("Tap to classify your \(session.mistakeCount) mistakes")
                            .font(.system(size: 14))
                            .foregroundStyle(AppTheme.current.textSecondary)
                    }

                    Spacer()
                }
                .padding(AppTheme.current.spacingL)
                .background(AppTheme.current.surface)
                .cornerRadius(AppTheme.current.radiusM)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.current.radiusM)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            } else {
                // Error breakdown
                VStack(alignment: .leading, spacing: AppTheme.current.spacingM) {
                    // Header
                    HStack {
                        Image(systemName: "chart.pie.fill")
                            .font(.system(size: AppTheme.current.iconSizeSmall))
                            .foregroundStyle(AppTheme.current.primary)

                        Text("\(totalCategorizedErrors) of \(session.mistakeCount) errors categorized")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppTheme.current.textSecondary)

                        Spacer()
                    }

                    // Top 3 errors
                    VStack(spacing: AppTheme.current.spacingS) {
                        ForEach(errorCounts.prefix(3), id: \.0.id) { errorType, count in
                            HStack {
                                // Error dot
                                Circle()
                                    .fill(colorForErrorType(errorType))
                                    .frame(width: 8, height: 8)

                                Text(errorType.rawValue)
                                    .font(.system(size: AppTheme.current.fontSizeBody))
                                    .foregroundStyle(AppTheme.current.textPrimary)

                                Spacer()

                                Text("\(count)")
                                    .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))
                                    .foregroundStyle(AppTheme.current.textSecondary)

                                // Percentage bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(AppTheme.current.textSecondary.opacity(0.1))
                                            .frame(height: 4)
                                            .cornerRadius(2)

                                        Rectangle()
                                            .fill(colorForErrorType(errorType))
                                            .frame(width: geometry.size.width * CGFloat(count) / CGFloat(session.mistakeCount), height: 4)
                                            .cornerRadius(2)
                                    }
                                }
                                .frame(width: 60, height: 4)
                            }
                        }
                    }

                    if errorCounts.count > 3 {
                        Text("+ \(errorCounts.count - 3) more")
                            .font(.system(size: AppTheme.current.fontSizeCaption))
                            .foregroundStyle(AppTheme.current.textSecondary)
                            .padding(.top, AppTheme.current.spacingXS)
                    }
                }
                .padding(AppTheme.current.spacingL)
                .background(AppTheme.current.surface)
                .cornerRadius(AppTheme.current.radiusM)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.current.radiusM)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
        }
        .onTapGesture {
            self.showErrorCategorize = true
        }
        .sheet(isPresented: self.$showErrorCategorize) {
            ErrorTrackingView(session: session)
        }
    }

    private func colorForErrorType(_ errorType: ErrorType) -> Color {
        let colors: [Color] = [
            AppTheme.current.primary,
            AppTheme.current.info,
            .purple,
            .pink,
            AppTheme.current.success,
            AppTheme.current.error,
            AppTheme.current.warning,
            .indigo,
            .teal,
            .cyan
        ]
        let index = ErrorType.allCases.firstIndex(of: errorType) ?? 0
        return colors[index % colors.count]
    }
}

#Preview {
    let session = Session(
        sessionName: "Practice Session",
        startTime: Date().addingTimeInterval(-3600),
        endTime: Date(),
        mistakeCount: 15,
        mistakeTimeline: [],
        errorCounts: [
            "Serve Error": 5,
            "Lob Miss": 3,
            "Kitchen Fault": 2
        ]
    )

    return ErrorSummaryCard(session: session)
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
}
