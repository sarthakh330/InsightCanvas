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
            MainCoordinator()
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1200, height: 800)
    }
}
