//
//  WelcomeScreen.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI

struct WelcomeScreen: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var logoRotation: Double = -10
    @State private var logoOffset: CGFloat = -20

    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20

    @State private var taglineOpacity: Double = 0
    @State private var taglineOffset: CGFloat = 20

    @State private var backgroundOpacity: Double = 0
    @State private var gradientRotation: Double = 0

    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.965, green: 0.973, blue: 0.980),
                    Color(red: 0.918, green: 0.945, blue: 0.933),
                    Color(red: 0.945, green: 0.965, blue: 0.950)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(backgroundOpacity)
            .hueRotation(.degrees(gradientRotation))

            // Subtle overlay blur circles for depth
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.184, green: 0.561, blue: 0.420).opacity(0.15),
                                Color.clear
                            ]),
                            center: .topLeading,
                            startRadius: 50,
                            endRadius: 400
                        )
                    )
                    .frame(width: 600, height: 600)
                    .offset(x: -200, y: -200)
                    .blur(radius: 60)
                    .opacity(backgroundOpacity)

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.184, green: 0.561, blue: 0.420).opacity(0.1),
                                Color.clear
                            ]),
                            center: .bottomTrailing,
                            startRadius: 50,
                            endRadius: 350
                        )
                    )
                    .frame(width: 500, height: 500)
                    .offset(x: 200, y: 200)
                    .blur(radius: 50)
                    .opacity(backgroundOpacity)
            }

            VStack(spacing: 24) {
                // Logo with floating animation
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .rotationEffect(.degrees(logoRotation))
                    .offset(y: logoOffset)
                    .shadow(color: Color.black.opacity(0.12), radius: 30, x: 0, y: 15)
                    .shadow(color: Color(red: 0.184, green: 0.561, blue: 0.420).opacity(0.2), radius: 40, x: 0, y: 20)

                VStack(spacing: 16) {
                    // App name with smooth entrance
                    Text("InsightCanvas")
                        .font(.system(size: 42, weight: .semibold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.067, green: 0.075, blue: 0.090),
                                    Color(red: 0.184, green: 0.561, blue: 0.420)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    // Tagline with elegant fade
                    Text("Transform knowledge into understanding")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                        .opacity(taglineOpacity)
                        .offset(y: taglineOffset)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 16)
            }
        }
        .onAppear {
            // Stage 1: Background fade in
            withAnimation(.easeOut(duration: 0.4)) {
                backgroundOpacity = 1.0
            }

            // Stage 2: Logo entrance with bounce
            withAnimation(
                .spring(response: 0.8, dampingFraction: 0.65, blendDuration: 0)
                .delay(0.15)
            ) {
                logoScale = 1.0
                logoOpacity = 1.0
                logoRotation = 0
                logoOffset = 0
            }

            // Stage 3: Title slide and fade
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.75, blendDuration: 0)
                .delay(0.4)
            ) {
                titleOpacity = 1.0
                titleOffset = 0
            }

            // Stage 4: Tagline slide and fade
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.75, blendDuration: 0)
                .delay(0.55)
            ) {
                taglineOpacity = 1.0
                taglineOffset = 0
            }

            // Subtle gradient rotation for movement
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                gradientRotation = 3
            }

            // Subtle floating animation for logo
            withAnimation(
                .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
                .delay(0.8)
            ) {
                logoOffset = -8
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}
