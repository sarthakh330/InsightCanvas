//
//  ConceptMapView.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI

struct ConceptMapView: View {
    let concepts: [Concept]
    @Binding var selectedConcept: Concept?
    @Binding var searchText: String

    @State private var expandedConceptIDs: Set<UUID> = []
    @State private var visibleConceptCount = 0

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            searchBar

            Divider()

            // Concept hierarchy
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(topLevelConcepts.enumerated()), id: \.element.id) { index, concept in
                        if index < visibleConceptCount {
                            ConceptRow(
                                concept: concept,
                                level: 0,
                                selectedConcept: $selectedConcept,
                                expandedConceptIDs: $expandedConceptIDs,
                                allConcepts: concepts
                            )
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .top)),
                                removal: .opacity
                            ))
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(Color("BG-Sidebar"))
        .onAppear {
            animateConceptsIn()
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 14))

            TextField("Search concepts...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color("BG-Canvas"))
    }

    private var topLevelConcepts: [Concept] {
        concepts
            .filter { $0.parentID == nil }
            .sorted { $0.order < $1.order }
    }

    /// Animate concepts in one by one for progressive reveal
    private func animateConceptsIn() {
        let totalConcepts = topLevelConcepts.count
        guard totalConcepts > 0 else { return }

        // Show first concept immediately
        withAnimation(.easeOut(duration: 0.4)) {
            visibleConceptCount = 1
        }

        // Show remaining concepts with staggered delays
        for index in 1..<totalConcepts {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                withAnimation(.easeOut(duration: 0.4)) {
                    visibleConceptCount = index + 1
                }
            }
        }
    }
}

// MARK: - Concept Row

struct ConceptRow: View {
    let concept: Concept
    let level: Int
    @Binding var selectedConcept: Concept?
    @Binding var expandedConceptIDs: Set<UUID>
    let allConcepts: [Concept]

    private var isSelected: Bool {
        selectedConcept?.id == concept.id
    }

    private var isExpanded: Bool {
        expandedConceptIDs.contains(concept.id)
    }

    private var hasChildren: Bool {
        !children.isEmpty
    }

    private var children: [Concept] {
        allConcepts
            .filter { $0.parentID == concept.id }
            .sorted { $0.order < $1.order }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Current concept row
            Button(action: {
                selectedConcept = concept
                if hasChildren {
                    toggleExpansion()
                }
            }) {
                HStack(spacing: 8) {
                    // Expand/collapse chevron
                    if hasChildren {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(red: 0.561, green: 0.537, blue: 0.494))
                            .frame(width: 12)
                    } else {
                        Spacer()
                            .frame(width: 12)
                    }

                    // Concept title
                    Text(concept.title)
                        .font(.system(size: 14, weight: isSelected ? .medium : .regular))
                        .foregroundColor(isSelected ? Color("Accent") : Color(red: 0.067, green: 0.075, blue: 0.090))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .padding(.leading, CGFloat(level * 16 + 12))
                .padding(.trailing, 12)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                        Color("AccentHighlight") :
                        Color.clear
                )
                .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 4)

            // Child concepts (if expanded)
            if isExpanded && hasChildren {
                ForEach(children, id: \.id) { child in
                    ConceptRow(
                        concept: child,
                        level: level + 1,
                        selectedConcept: $selectedConcept,
                        expandedConceptIDs: $expandedConceptIDs,
                        allConcepts: allConcepts
                    )
                }
            }
        }
    }

    private func toggleExpansion() {
        if isExpanded {
            expandedConceptIDs.remove(concept.id)
        } else {
            expandedConceptIDs.insert(concept.id)
        }
    }
}
