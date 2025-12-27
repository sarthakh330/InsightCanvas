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
    var onBackToHome: (() -> Void)?

    @State private var selectedConcept: Concept?
    @State private var searchText = ""

    @Query private var allConcepts: [Concept]

    var body: some View {
        VStack(spacing: 0) {
            // Top navigation bar
            topNavigationBar

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

    private var topNavigationBar: some View {
        HStack(spacing: 12) {
            // Back button
            Button(action: {
                onBackToHome?()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 13, weight: .medium))
                    Text("Home")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.898, green: 0.949, blue: 0.925))
                )
            }
            .buttonStyle(.plain)

            // Document name
            Text(analysis.documentName)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                .lineLimit(1)

            Spacer()

            // Analysis metadata
            HStack(spacing: 16) {
                Label("\(analysis.wordCount) words", systemImage: "doc.text")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                Label(analysis.analyzedAt.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color("BG-Surface"))
        .overlay(
            Divider(),
            alignment: .bottom
        )
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
