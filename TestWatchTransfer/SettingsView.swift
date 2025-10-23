//
//  SettingsView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/15/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @Query(sort: \Session.startTime, order: .reverse) private var sessions: [Session]
    @State private var showClearDataAlert = false

    private var currentThemeName: String {
        switch themeManager.selectedTheme {
        case "blue": return "Ocean Depths"
        case "pickleball": return "Flame Burst"
        case "opticYellow": return "Optic Energy"
        default: return "Ocean Depths"
        }
    }

    private var currentThemeColor: Color {
        switch themeManager.selectedTheme {
        case "blue": return .blue
        case "pickleball": return .orange
        case "opticYellow":
            // Adaptive color matching OpticYellow theme
            #if os(iOS)
            return Color(UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    // Bright optic yellow for dark mode
                    return UIColor(red: 0.97, green: 1.0, blue: 0.0, alpha: 1.0)
                default:
                    // Parrot green for light mode
                    return UIColor(red: 0.3, green: 0.7, blue: 0.2, alpha: 1.0)
                }
            })
            #else
            return Color(red: 0.97, green: 1.0, blue: 0.0)
            #endif
        default: return .blue
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Appearance Section
                Section(header: Text("Appearance")) {
                    NavigationLink(destination: ThemeSelectionView()) {
                        HStack(spacing: AppTheme.current.spacingM) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(currentThemeColor.opacity(0.15))
                                    .frame(width: 32, height: 32)

                                Image(systemName: "paintpalette.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(currentThemeColor)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("App Theme")
                                    .font(.system(size: AppTheme.current.fontSizeBody))
                                    .foregroundStyle(AppTheme.current.textPrimary)

                                Text(currentThemeName)
                                    .font(.system(size: AppTheme.current.fontSizeFootnote))
                                    .foregroundStyle(AppTheme.current.textSecondary)
                            }

                            Spacer()

                            Circle()
                                .fill(currentThemeColor)
                                .frame(width: 24, height: 24)
                        }
                    }
                }

                Section(header: Text("App Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundStyle(.secondary)
                    }
                }

                Section(header: Text("About")) {
                    Text("Pickleball Rite helps you monitor and improve your game by analyzing mistakes during practice and tournaments.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section(header: Text("Data Management")) {
                    Button(role: .destructive) {
                        showClearDataAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear All Data")
                        }
                    }
                    .disabled(sessions.isEmpty)
                }

                Section(header: Text("Storage")) {
                    HStack {
                        Text("Total Sessions")
                        Spacer()
                        Text("\(sessions.count)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.current.backgroundPrimary)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Clear All Data?", isPresented: $showClearDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This will permanently delete all \(sessions.count) session(s) and reset your data. This action cannot be undone.")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(uiColor: .systemBackground), for: .tabBar)
            .toolbarColorScheme(colorScheme, for: .tabBar)
        }
    }

    private func clearAllData() {
        // Delete all sessions from SwiftData
        for session in sessions {
            modelContext.delete(session)
        }

        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to clear data: \(error)")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Session.self)
        .environmentObject(ThemeManager.shared)
}
