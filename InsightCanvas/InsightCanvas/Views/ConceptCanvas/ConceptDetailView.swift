//
//  ConceptDetailView.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI

struct ConceptDetailView: View {
    let concept: Concept

    @State private var isExcerptsExpanded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Title Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(concept.title)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))

                    // One-line summary (emphasized)
                    Text(concept.oneLineSummary)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))
                        .lineSpacing(4)
                }
                .padding(.bottom, 8)

                Divider()

                // Three-Paragraph Summary
                VStack(alignment: .leading, spacing: 24) {
                    // Paragraph 1: What This Is
                    summaryParagraph(
                        number: "1",
                        title: "What",
                        content: concept.whatThisIs
                    )

                    // Paragraph 2: Why It Matters
                    summaryParagraph(
                        number: "2",
                        title: "Why",
                        content: concept.whyItMatters
                    )

                    // Paragraph 3: Key Insight (first key point)
                    if let firstPoint = concept.keyPoints.first {
                        summaryParagraph(
                            number: "3",
                            title: "Key Insight",
                            content: firstPoint
                        )
                    }
                }

                Divider()

                // Core Takeaways (remaining key points)
                if concept.keyPoints.count > 1 {
                    coreTakeawaysSection
                }

                // From the Document (Excerpts)
                if !concept.excerpts.isEmpty {
                    excerptsSection
                }

                Spacer(minLength: 40)
            }
            .padding(40)
        }
        .background(Color("BG-Canvas"))
    }

    private func summaryParagraph(number: String, title: String, content: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Number badge
            ZStack {
                Circle()
                    .fill(Color(red: 0.184, green: 0.561, blue: 0.420).opacity(0.12))
                    .frame(width: 32, height: 32)

                Text(number)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.561, green: 0.537, blue: 0.494))
                    .tracking(0.8)

                Text(content)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                    .lineSpacing(7)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var coreTakeawaysSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CORE TAKEAWAYS")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                .tracking(1.0)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(concept.keyPoints.dropFirst().enumerated()), id: \.offset) { index, point in
                    HStack(alignment: .top, spacing: 14) {
                        // Bullet with number
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.184, green: 0.561, blue: 0.420))
                                .frame(width: 24, height: 24)

                            Text("\(index + 1)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Text(point)
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                .tracking(0.5)

            Text(content)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                .lineSpacing(6)
        }
    }

    private var keyPointsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("KEY POINTS")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                .tracking(0.5)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(concept.keyPoints.enumerated()), id: \.offset) { index, point in
                    HStack(alignment: .top, spacing: 12) {
                        // Custom bullet
                        Circle()
                            .fill(Color("Accent"))
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)

                        Text(point)
                            .font(.system(size: 15))
                            .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                            .lineSpacing(4)
                    }
                }
            }
        }
    }

    private var excerptsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExcerptsExpanded.toggle()
                }
            }) {
                HStack {
                    Text("FROM THE DOCUMENT")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                        .tracking(0.5)

                    Spacer()

                    HStack(spacing: 4) {
                        Text("\(concept.excerpts.count) excerpts")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))

                        Image(systemName: isExcerptsExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
                    }
                }
            }
            .buttonStyle(.plain)

            if isExcerptsExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(concept.excerpts, id: \.id) { excerpt in
                        excerptCard(excerpt)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private func excerptCard(_ excerpt: Excerpt) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Quote
            Text("\"\(excerpt.text)\"")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                .italic()
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("BG-Surface"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("BorderBeige"), lineWidth: 1)
                )

            // Location
            Text(excerpt.location)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))
        }
    }
}

#Preview {
    ConceptDetailView(concept: Concept(
        title: "Memory Systems",
        parentID: nil,
        order: 0,
        oneLineSummary: "Different approaches to storing and retrieving information in AI agents",
        whatThisIs: "Memory systems are architectural components that enable AI agents to store, organize, and retrieve information across conversations and sessions. They range from simple key-value stores to sophisticated graph databases.",
        whyItMatters: "Without effective memory, agents can't maintain context, learn from interactions, or build on previous knowledge. The choice of memory system fundamentally shapes what an agent can do.",
        keyPoints: [
            "Short-term memory handles within-conversation context",
            "Long-term memory persists across sessions",
            "Semantic memory enables concept-based retrieval"
        ]
    ))
}
