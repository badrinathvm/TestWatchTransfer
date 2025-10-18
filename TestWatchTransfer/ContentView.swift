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
            .tint(.orange)
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
            .tint(.orange)
        }
    }
}
