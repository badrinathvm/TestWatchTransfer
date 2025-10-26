//
//  OnboardingScreen5_Features.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

struct OnboardingScreen5_Features: View {
    private let features = [
        AppFeature(
            icon: "arrow.triangle.2.circlepath",
            title: "Automatic Sync",
            description: "Sessions appear instantly on your iPhone",
            color: .blue
        ),
        AppFeature(
            icon: "chart.line.uptrend.xyaxis",
            title: "Mistake Timelines",
            description: "See exactly when mistakes occurred",
            color: .purple
        ),
        AppFeature(
            icon: "magnifyingglass",
            title: "Search & Filter",
            description: "Find sessions by date, count, or location",
            color: .orange
        ),
        AppFeature(
            icon: "paintpalette.fill",
            title: "Custom Themes",
            description: "Personalize with beautiful color schemes",
            color: .pink
        ),
        AppFeature(
            icon: "mappin.circle.fill",
            title: "Location Tracking",
            description: "Remember where each session took place",
            color: .green
        )
    ]

    var body: some View {
        OnboardingPageView(
            title: "Your Sessions, Automatically Synced",
            description: "Track your progress over time with powerful features designed for serious players."
        ) {
            ScrollView(Axis.Set.vertical, showsIndicators: false) {
                VStack(spacing: AppTheme.current.spacingXXL) {
                    // iPhone mockup with session list
                    ZStack {
                        // iPhone outline
                        RoundedRectangle(cornerRadius: 40)
                            .fill(AppTheme.current.surface)
                            .frame(width: 200, height: 280)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.primary.opacity(0.2), lineWidth: 2)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                        
                        // Simplified session list
                        VStack(spacing: 8) {
                            // Header
                            HStack {
                                Text("Workouts")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(AppTheme.current.textPrimary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // Session cards
                            VStack(spacing: 8) {
                                MiniSessionCard(count: 12, time: "2h ago", color: .green)
                                MiniSessionCard(count: 18, time: "1d ago", color: .yellow)
                                MiniSessionCard(count: 8, time: "3d ago", color: .green)
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                        .frame(width: 200, height: 280)
                    }
                    
                    // Features list
                    VStack(spacing: AppTheme.current.spacingM) {
                        ForEach(features) { feature in
                            FeatureRowCompact(feature: feature)
                        }
                    }
                    .padding(.horizontal, AppTheme.current.spacingXL)
                }
            }
        }
    }
}

// App feature model
struct AppFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// Compact feature row
struct FeatureRowCompact: View {
    let feature: AppFeature

    var body: some View {
        HStack(spacing: AppTheme.current.spacingM) {
            Image(systemName: feature.icon)
                .font(.system(size: 18))
                .foregroundStyle(feature.color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))
                    .foregroundStyle(AppTheme.current.textPrimary)

                Text(feature.description)
                    .font(.system(size: AppTheme.current.fontSizeCaption))
                    .foregroundStyle(AppTheme.current.textSecondary)
            }

            Spacer()
        }
    }
}

// Mini session card for mockup
struct MiniSessionCard: View {
    let count: Int
    let time: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "figure.pickleball")
                        .font(.system(size: 14))
                        .foregroundStyle(color)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Session")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppTheme.current.textPrimary)

                Text("\(count) mistakes")
                    .font(.system(size: 9))
                    .foregroundStyle(AppTheme.current.textSecondary)
            }

            Spacer()

            Text(time)
                .font(.system(size: 9))
                .foregroundStyle(AppTheme.current.textSecondary)
        }
        .padding(8)
        .background(AppTheme.current.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    OnboardingScreen5_Features()
        .background(AppTheme.current.backgroundPrimary)
        .environmentObject(ThemeManager.shared)
}
