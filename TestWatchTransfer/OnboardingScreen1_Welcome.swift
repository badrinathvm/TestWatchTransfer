//
//  OnboardingScreen1_Welcome.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

struct OnboardingScreen1_Welcome: View {
    var body: some View {
        OnboardingPageView(
            title: "Welcome to Picklerite",
            description: "Track and improve your game by counting mistakes during practice and tournaments—right from your Apple Watch"
        ) {
            // Sleeping/relaxed character illustration (similar to reference screenshot)
            ZStack {
                Circle()
                    .fill(AppTheme.current.primaryLight)
                    .frame(width: 240, height: 240)

                VStack(spacing: AppTheme.current.spacingL) {
                    // Watch + Pickleball icon combo
                    ZStack {
                        Image(systemName: "applewatch")
                            .font(.system(size: 80))
                            .foregroundStyle(AppTheme.current.primary)

                        Image(systemName: "figure.pickleball")
                            .font(.system(size: 40))
                            .foregroundStyle(AppTheme.current.accent)
                            .offset(x: 40, y: -30)
                    }
                    .padding(.top, AppTheme.current.spacingL)

                    // App name badge
                    Text("Pickle Rite")
                        .font(.system(size: AppTheme.current.fontSizeTitle, weight: .bold))
                        .foregroundStyle(AppTheme.current.primary)
                        .padding(.horizontal, AppTheme.current.spacingL)
                        .padding(.vertical, AppTheme.current.spacingS)
                        .background(AppTheme.current.surface)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.current.radiusL))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
            }
        }
    }
}

#Preview {
    OnboardingScreen1_Welcome()
        .background(AppTheme.current.backgroundPrimary)
        .environmentObject(ThemeManager.shared)
}
