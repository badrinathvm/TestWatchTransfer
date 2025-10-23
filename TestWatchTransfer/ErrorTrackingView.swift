//
//  ErrorTrackingView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/21/25.
//

import SwiftUI
import SwiftData

enum ViewMode {
    case list
    case grid
}

struct ErrorTrackingView: View {
    @Bindable var session: Session
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewMode: ViewMode = .list
    @State private var errorCounts: [ErrorType: Int] = [:]
    @State private var selectedErrors: Set<ErrorType> = []
    
    private var totalErrors: Int {
        errorCounts.values.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Image(systemName: "figure.pickleball")
                        .font(.system(size: AppTheme.current.iconSizeLarge))
                        .foregroundStyle(AppTheme.current.primary)

                    Text("Categorize")
                        .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold))

                    Spacer()
                }
                .padding(.horizontal, AppTheme.current.spacingXL)
                .padding(.top, AppTheme.current.spacingXL)
                .padding(.bottom, AppTheme.current.spacingL)
                
                // Section header
                Text("ALL SESSION ERRORS")
                    .font(.system(size: AppTheme.current.fontSizeFootnote, weight: .semibold))
                    .foregroundStyle(AppTheme.current.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppTheme.current.spacingXL)
                    .padding(.bottom, AppTheme.current.spacingM)
                
                // Error list
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(ErrorType.allCases) { errorType in
                            ErrorRowView(
                                errorType: errorType,
                                count: errorCounts[errorType] ?? 0,
                                isSelected: selectedErrors.contains(errorType),
                                onIncrement: {
                                    incrementError(errorType)
                                },
                                onDecrement: {
                                    decrementError(errorType)
                                },
                                onToggleSelection: {
                                    toggleSelection(errorType)
                                }
                            )
                            
                            if errorType != ErrorType.allCases.last {
                                Divider()
                                    .padding(.leading, 72)
                            }
                        }
                    }
                    .background(AppTheme.current.surface)
                    .cornerRadius(AppTheme.current.radiusM)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.current.radiusM)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, AppTheme.current.spacingXL)
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Text("\(totalErrors) errors | \(session.mistakeCount) total")
                        .font(.system(size: AppTheme.current.fontSizeBody, weight: .medium))
                        .foregroundStyle(AppTheme.current.textSecondary)

                    Spacer()

                    //                Button(action: {
                    //                    // TODO: View heat map
                    //                }) {
                    //                    HStack(spacing: 6) {
                    //                        Image(systemName: "chart.bar.fill")
                    //                            .font(.system(size: 14, weight: .semibold))
                    //                        Text("View Heat Map")
                    //                            .font(.system(size: 16, weight: .semibold))
                    //                    }
                    //                    .foregroundStyle(.white)
                    //                    .padding(.horizontal, 20)
                    //                    .padding(.vertical, 12)
                    //                    .background(AppTheme.current.success)
                    //                    .cornerRadius(AppTheme.current.radiusXL)
                    //                }
                }
                .padding(.horizontal, AppTheme.current.spacingXL)
                .padding(.vertical, AppTheme.current.spacingL)
                .background(AppTheme.current.backgroundPrimary)
            }
            .background(AppTheme.current.backgroundPrimary)
            .onAppear {
                loadErrorCounts()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppTheme.current.primary)
                    }
                }

//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: {
//                        // TODO: Add custom error type
//                    }) {
//                        HStack(spacing: AppTheme.current.spacingXS) {
//                            Image(systemName: "plus")
//                                .font(.system(size: 14, weight: .semibold))
//                            Text("Custom")
//                                .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))
//                        }
//                        .foregroundStyle(.white)
//                        .padding(.horizontal, 14)
//                        .padding(.vertical, AppTheme.current.spacingS)
//                        .background(AppTheme.current.primary)
//                        .cornerRadius(AppTheme.current.radiusL)
//                    }
//                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    private func loadErrorCounts() {
        if let counts = session.errorCounts {
            for (key, value) in counts {
                if let errorType = ErrorType.allCases.first(where: { $0.rawValue == key }) {
                    errorCounts[errorType] = value
                }
            }
        }
    }
    
    private func saveErrorCounts() {
        var countsDict: [String: Int] = [:]
        for (errorType, count) in errorCounts {
            if count > 0 {
                countsDict[errorType.rawValue] = count
            }
        }
        session.errorCounts = countsDict.isEmpty ? nil : countsDict
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to save error counts: \(error)")
        }
    }
    
    private func incrementError(_ errorType: ErrorType) {
        errorCounts[errorType, default: 0] += 1
        saveErrorCounts()
    }
    
    private func decrementError(_ errorType: ErrorType) {
        let current = errorCounts[errorType, default: 0]
        if current > 0 {
            errorCounts[errorType] = current - 1
            saveErrorCounts()
        }
    }
    
    private func toggleSelection(_ errorType: ErrorType) {
        if selectedErrors.contains(errorType) {
            selectedErrors.remove(errorType)
        } else {
            selectedErrors.insert(errorType)
        }
    }
}

struct ErrorRowView: View {
    let errorType: ErrorType
    let count: Int
    let isSelected: Bool
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onToggleSelection: () -> Void
    
    var body: some View {
        HStack(spacing: AppTheme.current.spacingM) {
            // Selection circle
            Button(action: onToggleSelection) {
                Circle()
                    .stroke(AppTheme.current.textSecondary.opacity(0.3), lineWidth: 2)
                    .fill(isSelected ? AppTheme.current.accentLight : Color.clear)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(AppTheme.current.primary)
                            .frame(width: 12, height: 12)
                            .opacity(isSelected ? 1 : 0)
                    )
            }
            .buttonStyle(.plain)

            // Error info
            VStack(alignment: .leading, spacing: AppTheme.current.spacingXS) {
                Text(errorType.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppTheme.current.textPrimary)

                Text(errorType.description)
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.current.textSecondary)
            }

            Spacer()

            // Counter controls
            HStack(spacing: AppTheme.current.spacingM) {
                // Decrement button
                Button(action: onDecrement) {
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "minus")
                                .font(.system(size: AppTheme.current.iconSizeSmall, weight: .semibold))
                                .foregroundStyle(count > 0 ? AppTheme.current.primary : AppTheme.current.textSecondary.opacity(0.5))
                        )
                }
                .buttonStyle(.plain)
                .disabled(count == 0)

                // Count
                Text("\(count)")
                    .font(.system(size: AppTheme.current.fontSizeTitle, weight: .bold))
                    .foregroundStyle(AppTheme.current.primary)
                    .frame(minWidth: 30)

                // Increment button
                Button(action: onIncrement) {
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: AppTheme.current.iconSizeSmall, weight: .semibold))
                                .foregroundStyle(AppTheme.current.primary)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppTheme.current.spacingXL)
        .padding(.vertical, AppTheme.current.spacingM)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Session.self, configurations: config)
    
    let session = Session(
        sessionName: "Practice Session",
        startTime: Date().addingTimeInterval(-3600),
        endTime: Date(),
        mistakeCount: 15,
        mistakeTimeline: []
    )
    
    container.mainContext.insert(session)
    
    return ErrorTrackingView(session: session)
        .modelContainer(container)
}
