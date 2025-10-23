//
//  ThemeSelectionView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

// Theme option model
struct ThemeOption: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let colorPreview: Color
    let themeKey: String
}

struct ThemeSelectionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    private var selectedTheme: String {
        themeManager.selectedTheme
    }

    private let themes: [ThemeOption] = [
        ThemeOption(
            name: "Ocean Depths",
            description: "Cool and refreshing - ideal for endurance and flow states",
            colorPreview: .blue,
            themeKey: "blue"
        ),
        ThemeOption(
            name: "Flame Burst",
            description: "Energetic and motivating - great for high-intensity training",
            colorPreview: .orange,
            themeKey: "pickleball"
        ),
        ThemeOption(
            name: "Optic Energy",
            description: "Vibrant and dynamic - perfect for power and focus",
            colorPreview: Color(red: 0.97, green: 1.0, blue: 0.0),
            themeKey: "opticYellow"
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.current.spacingXXL) {
                // Header with icon
                VStack(spacing: AppTheme.current.spacingL) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.current.primary.opacity(0.15))
                            .frame(width: 100, height: 100)

                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.current.primary)
                    }
                    .padding(.top, AppTheme.current.spacingXL)

                    VStack(spacing: AppTheme.current.spacingS) {
                        Text("Choose Your Theme")
                            .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold))
                            .foregroundStyle(AppTheme.current.textPrimary)

                        Text("Personalize your experience with your preferred color theme.")
                            .font(.system(size: AppTheme.current.fontSizeBody))
                            .foregroundStyle(AppTheme.current.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppTheme.current.spacingXXL)
                    }
                }

                // Available Themes Section
                VStack(alignment: .leading, spacing: AppTheme.current.spacingL) {
                    Text("Available Themes")
                        .font(.system(size: AppTheme.current.fontSizeTitle, weight: .semibold))
                        .foregroundStyle(AppTheme.current.textPrimary)
                        .padding(.horizontal, AppTheme.current.spacingXL)

                    VStack(spacing: AppTheme.current.spacingM) {
                        ForEach(themes) { theme in
                            ThemeOptionRow(
                                theme: theme,
                                isSelected: selectedTheme == theme.themeKey,
                                onSelect: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        themeManager.selectedTheme = theme.themeKey
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, AppTheme.current.spacingXL)
                }

                Spacer(minLength: AppTheme.current.spacingXXL)
            }
        }
        .background(AppTheme.current.backgroundPrimary)
        .navigationTitle("Theme")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ThemeOptionRow: View {
    let theme: ThemeOption
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppTheme.current.spacingL) {
                // Color preview square
                RoundedRectangle(cornerRadius: AppTheme.current.radiusM)
                    .fill(theme.colorPreview)
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.current.radiusM)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )

                // Theme info
                VStack(alignment: .leading, spacing: AppTheme.current.spacingXS) {
                    Text(theme.name)
                        .font(.system(size: AppTheme.current.fontSizeTitle, weight: .semibold))
                        .foregroundStyle(AppTheme.current.textPrimary)

                    Text(theme.description)
                        .font(.system(size: AppTheme.current.fontSizeFootnote))
                        .foregroundStyle(AppTheme.current.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? theme.colorPreview : Color.secondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(theme.colorPreview)
                    }
                }
            }
            .padding(AppTheme.current.spacingL)
            .background(AppTheme.current.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.current.radiusL))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.current.radiusL)
                    .stroke(isSelected ? theme.colorPreview : Color.primary.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ThemeSelectionView()
            .environmentObject(ThemeManager.shared)
    }
}
