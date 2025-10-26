//
//  ContentView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        if #available(iOS 18.0, *) {
            TabView {
                Tab("Workouts", systemImage: "figure.pickleball") {
                    SessionListView()
                }

//                Tab("Search", systemImage: "magnifyingglass", role: .search) {
//                    SearchView()
//                }

                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
            .tint(themeManager.currentTheme.primary)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(themeManager.currentTheme.backgroundPrimary, for: .tabBar)
            .toolbarColorScheme(colorScheme, for: .tabBar)
            .onAppear {
                updateTabBarAppearance()
            }
            .onChange(of: themeManager.selectedTheme) { _, _ in
                updateTabBarAppearance()
            }
        } else {
            // Fallback for iOS 17 and earlier
            TabView {
                SessionListView()
                    .tabItem {
                        Label("Workouts", systemImage: "figure.pickleball")
                    }

                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .tint(themeManager.currentTheme.primary)
            .onAppear {
                updateTabBarAppearance()
            }
            .onChange(of: themeManager.selectedTheme) { _, _ in
                updateTabBarAppearance()
            }
        }
    }

    private func updateTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        // Set background color to match theme
        appearance.backgroundColor = UIColor(themeManager.currentTheme.backgroundPrimary)

        // Configure item colors
        let itemAppearance = UITabBarItemAppearance()

        // Normal state (unselected)
        itemAppearance.normal.iconColor = .systemGray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]

        // Selected state
        itemAppearance.selected.iconColor = UIColor(themeManager.currentTheme.primary)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(themeManager.currentTheme.primary)]

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        // Apply to all tab bar states
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
