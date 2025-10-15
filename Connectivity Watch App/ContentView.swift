//
//  ContentView.swift
//  Connectivity Watch App
//
//  Created by Rani Badri on 10/14/25.
//

import SwiftUI

struct WatchContentView: View {
    @State private var textInput: String = ""
    @State private var status: String = "Ready"

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Watch App")
                    .font(.headline)

                TextField("Enter text", text: $textInput)
                    .textFieldStyle(.plain)

                Button {
                    sendToiPhone()
                } label: {
                    Label("Send", systemImage: "paperplane.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(textInput.isEmpty)

                Text(status)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }

    private func sendToiPhone() {
        guard !textInput.isEmpty else { return }

        status = "Sending..."
        WatchConnectivityManager.shared.sendMessage(textInput)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            status = "Sent: \(textInput)"
            textInput = ""
        }
    }
}
