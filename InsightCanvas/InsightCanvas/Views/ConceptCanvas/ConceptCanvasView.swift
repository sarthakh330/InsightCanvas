//
//  ConceptCanvasView.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI
import SwiftData

struct ConceptCanvasView: View {
    let analysis: Analysis

    @State private var selectedConcept: Concept?
    @State private var searchText = ""

    @Query private var allConcepts: [Concept]

    var body: some View {
        HSplitView {
            // Left: Concept Map (Sidebar)
            ConceptMapView(
                concepts: analysis.concepts,
                selectedConcept: $selectedConcept,
                searchText: $searchText
            )
            .frame(minWidth: 280, idealWidth: 320, maxWidth: 400)

            // Right: Concept Detail
            if let selected = selectedConcept {
                ConceptDetailView(concept: selected)
                    .frame(minWidth: 500)
            } else {
                emptyStateView
            }
        }
        .background(Color("BG-Canvas"))
        .onAppear {
            // Select the first top-level concept by default
            if selectedConcept == nil {
                selectedConcept = analysis.concepts
                    .filter { $0.parentID == nil }
                    .sorted { $0.order < $1.order }
                    .first
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("Select a concept to explore")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BG-Canvas"))
    }
}
