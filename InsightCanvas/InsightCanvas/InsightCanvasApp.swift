//
//  InsightCanvasApp.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI
import SwiftData

@main
struct InsightCanvasApp: App {
    @State private var showingAPIKeyAlert = false
    @State private var showWelcomeScreen = true

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Analysis.self,
            Concept.self,
            Excerpt.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainCoordinator()
                    .opacity(showWelcomeScreen ? 0 : 1)

                if showWelcomeScreen {
                    WelcomeScreen()
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Show welcome screen for 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showWelcomeScreen = false
                    }

                    // Check API key after welcome screen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if !Config.isAPIKeyConfigured() {
                            showingAPIKeyAlert = true
                        }
                    }
                }
            }
            .alert("API Key Required", isPresented: $showingAPIKeyAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(Config.getSetupMessage())
            }
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1200, height: 800)
    }
}
