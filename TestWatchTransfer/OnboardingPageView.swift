//
//  OnboardingPageView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

/// Reusable onboarding page component with consistent layout
struct OnboardingPageView<Content: View>: View {
    let title: String
    let description: String
    let content: Content

    init(title: String, description: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.content = content()
    }

    var body: some View {
        VStack(spacing: AppTheme.current.spacingXXL) {
            Spacer()

            // Main content (illustration, animation, etc.)
            content
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppTheme.current.spacingXL)

            // Text content
            VStack(spacing: AppTheme.current.spacingM) {
                Text(title)
                    .font(.system(size: AppTheme.current.fontSizeHeading, weight: .bold))
                    .foregroundStyle(AppTheme.current.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.current.spacingXL)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)

                Text(description)
                    .font(.system(size: AppTheme.current.fontSizeBody))
                    .foregroundStyle(AppTheme.current.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.current.spacingXXL)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OnboardingPageView(
        title: "Welcome to Pickleball Rite",
        description: "Track and improve your game by counting mistakes during practice and tournaments"
    ) {
        Image(systemName: "figure.pickleball")
            .font(.system(size: 120))
            .foregroundStyle(AppTheme.current.primary)
    }
    .background(AppTheme.current.backgroundPrimary)
    .environmentObject(ThemeManager.shared)
}
