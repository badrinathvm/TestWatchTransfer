//
//  GIFImageView.swift
//  TestWatchTransfer
//
//  Created by Rani Badri on 10/23/25.
//

import SwiftUI
import UIKit
import ImageIO

/// UIViewRepresentable wrapper for displaying animated GIFs
struct GIFImageView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        // Load GIF from bundle
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL),
           let source = CGImageSourceCreateWithData(gifData as CFData, nil) {

            var images: [UIImage] = []
            var totalDuration: TimeInterval = 0

            let frameCount = CGImageSourceGetCount(source)

            for i in 0..<frameCount {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let image = UIImage(cgImage: cgImage)
                    images.append(image)

                    // Get frame duration
                    if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                       let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                       let frameDuration = gifProperties[kCGImagePropertyGIFDelayTime as String] as? TimeInterval {
                        totalDuration += frameDuration
                    } else {
                        totalDuration += 0.1 // Default duration
                    }
                }
            }

            imageView.animationImages = images
            imageView.animationDuration = totalDuration
            imageView.animationRepeatCount = 0 // Infinite loop
            imageView.startAnimating()
        }

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // No updates needed
    }
}

/// Placeholder view for when GIF is not yet added
struct GIFPlaceholderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: AppTheme.current.spacingM) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.current.radiusL)
                    .fill(AppTheme.current.primaryLight)
                    .frame(height: 200)

                VStack(spacing: AppTheme.current.spacingS) {
                    Image(systemName: "film")
                        .font(.system(size: 50))
                        .foregroundStyle(AppTheme.current.primary)

                    Text(title)
                        .font(.system(size: AppTheme.current.fontSizeBody, weight: .semibold))
                        .foregroundStyle(AppTheme.current.textPrimary)

                    Text(subtitle)
                        .font(.system(size: AppTheme.current.fontSizeFootnote))
                        .foregroundStyle(AppTheme.current.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.current.spacingL)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        GIFPlaceholderView(
            title: "Counting Demo",
            subtitle: "GIF placeholder - Add your counting demonstration here"
        )
        .padding()
    }
    .environmentObject(ThemeManager.shared)
}
