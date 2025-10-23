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

    init() {
        // Force tab bar to use proper dark mode colors
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground

        // Apply to all states to override search role styling
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        if #available(iOS 18.0, *) {
            TabView {
                Tab("Workouts", systemImage: "figure.pickleball") {
                    SessionListView()
                }

                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    SearchView()
                }

                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
            .tint(AppTheme.current.accent)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(uiColor: .systemBackground), for: .tabBar)
            .toolbarColorScheme(colorScheme, for: .tabBar)
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
            .tint(AppTheme.current.accent)
        }
    }
}
