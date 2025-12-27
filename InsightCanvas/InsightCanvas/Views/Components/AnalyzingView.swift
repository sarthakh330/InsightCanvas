//
//  AnalyzingView.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI

struct AnalyzingView: View {
    let documentName: String
    @Binding var progress: String
    @Binding var error: String?
    var onBackToHome: (() -> Void)?

    var body: some View {
        ZStack {
            // Clean warm beige background
            Color(red: 0.992, green: 0.988, blue: 0.976)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Animated icon with glow effect
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Color("Accent").opacity(0.15))
                        .frame(width: 140, height: 140)
                        .scaleEffect(error == nil ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: error == nil)

                    // Inner glow
                    Circle()
                        .fill(Color("Accent").opacity(0.1))
                        .frame(width: 120, height: 120)
                        .scaleEffect(error == nil ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: error == nil)

                    // Main icon
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 72, weight: .light))
                        .foregroundColor(Color("Accent"))
                        .symbolEffect(.pulse, options: .repeating)
                }
                .padding(.bottom, 40)

                // Text content
                VStack(spacing: 16) {
                    Text("Analyzing \(documentName)")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    // Progress text with fade animation
                    Text(progress)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .id(progress)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                        .frame(minHeight: 22)
                }
                .padding(.horizontal, 40)

                if let errorMessage = error {
                    errorView(errorMessage)
                        .padding(.top, 32)
                } else {
                    // Custom animated dots
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color("Accent"))
                                .frame(width: 8, height: 8)
                                .scaleEffect(error == nil ? 1.0 : 0.5)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: error == nil
                                )
                        }
                    }
                    .padding(.top, 32)
                }

                Spacer()
            }
            .padding(40)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundColor(.red)

            Text("Analysis Failed")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.red)

            ScrollView {
                Text(message.isEmpty ? "Unknown error occurred" : message)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                    .padding(16)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(white: 0.95))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .frame(maxHeight: 300)
            .padding(.horizontal, 16)

            Button(action: {
                onBackToHome?()
            }) {
                Text("Back to Home")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.898, green: 0.949, blue: 0.925))
            )
        }
        .padding(32)
        .frame(maxWidth: 650)
        .background(Color("BG-Surface"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}
