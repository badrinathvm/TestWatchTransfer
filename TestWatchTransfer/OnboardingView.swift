//
//  OnboardingView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage: Int = 0
    @EnvironmentObject var themeManager: ThemeManager

    private let totalPages = 5

    var body: some View {
        ZStack {
            // Background
            AppTheme.current.backgroundPrimary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with progress indicators and skip button
                HStack {
                    // Progress indicators (dots)
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? AppTheme.current.accent : Color.gray.opacity(0.3))
                                .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.leading, AppTheme.current.spacingXL)

                    Spacer()

                    // Skip button (only show on first 4 pages)
                    if currentPage < totalPages - 1 {
                        Button(action: completeOnboarding) {
                            Text("Skip")
                                .font(.system(size: AppTheme.current.fontSizeBody, weight: .medium))
                                .foregroundStyle(AppTheme.current.textSecondary)
                        }
                        .padding(.trailing, AppTheme.current.spacingXL)
                    } else {
                        // Empty spacer to maintain layout
                        Spacer()
                            .frame(width: 60)
                    }
                }
                .padding(.top, AppTheme.current.spacingXL)
                .padding(.bottom, AppTheme.current.spacingM)

                // Main content - TabView with pages
                TabView(selection: $currentPage) {
                    OnboardingScreen1_Welcome()
                        .tag(0)

                    OnboardingScreen2_WatchCounter()
                        .tag(1)

                    OnboardingScreen3_MistakeGuide()
                        .tag(2)

                    OnboardingScreen4_Complications()
                        .tag(3)

                    OnboardingScreen5_Features()
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                // Bottom navigation buttons
                VStack(spacing: AppTheme.current.spacingM) {
                    if currentPage < totalPages - 1 {
                        // Next button
                        Button(action: nextPage) {
                            HStack(spacing: AppTheme.current.spacingS) {
                                Text("Next")
                                    .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))

                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.current.spacingL)
                            .background(AppTheme.current.accent)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.current.radiusL))
                            .shadow(color: AppTheme.current.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    } else {
                        // Get Started button (final page)
                        Button(action: completeOnboarding) {
                            HStack(spacing: AppTheme.current.spacingS) {
                                Text("Get Started")
                                    .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))

                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.current.spacingL)
                            .background(AppTheme.current.accent)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.current.radiusL))
                            .shadow(color: AppTheme.current.accent.opacity(0.3), radius: 12, x: 0, y: 6)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.current.spacingXXL)
                .padding(.vertical, AppTheme.current.spacingXL)
            }
        }
    }

    // Navigate to next page
    private func nextPage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }
        }
    }

    // Complete onboarding and dismiss
    private func completeOnboarding() {
        // The binding in TestWatchTransferApp will handle setting hasCompletedOnboarding
        withAnimation {
            isPresented = false
        }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
        .environmentObject(ThemeManager.shared)
}
