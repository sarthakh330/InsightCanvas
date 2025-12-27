//
//  WelcomeScreen.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI

struct WelcomeScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0

    var body: some View {
        ZStack {
            // Background gradient - subtle and elegant
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.965, green: 0.973, blue: 0.980),
                    Color(red: 0.918, green: 0.945, blue: 0.933)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Logo with smooth animation
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)

                VStack(spacing: 12) {
                    // App name
                    Text("InsightCanvas")
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                        .opacity(textOpacity)

                    // Tagline
                    Text("Transform knowledge into understanding")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                        .opacity(textOpacity)
                }
                .padding(.top, 8)
            }
        }
        .onAppear {
            // Smooth entrance animations
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
