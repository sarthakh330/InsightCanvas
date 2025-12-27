//
//  MainCoordinator.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI
import SwiftData

enum AppState {
    case home
    case analyzing(documentName: String)
    case canvas(analysis: Analysis)
}

struct MainCoordinator: View {
    @Environment(\.modelContext) private var modelContext
    @State private var appState: AppState = .home
    @State private var analyzingProgress = ""
    @State private var analyzingError: String?
    @State private var documentSnippets: [String] = []

    @StateObject private var documentParser = DocumentParser()
    @StateObject private var aiAnalyzer = AIAnalyzer()

    var body: some View {
        Group {
            switch appState {
            case .home:
                HomeView(onDocumentSelected: handleDocumentSelection)

            case .analyzing(let documentName):
                AnalyzingView(
                    documentName: documentName,
                    progress: $analyzingProgress,
                    error: $analyzingError,
                    snippets: documentSnippets,
                    onBackToHome: {
                        appState = .home
                        analyzingError = nil
                    }
                )

            case .canvas(let analysis):
                ConceptCanvasView(analysis: analysis)
            }
        }
    }

    private func handleDocumentSelection(url: URL) {
        Task {
            do {
                // Update state to analyzing
                await MainActor.run {
                    appState = .analyzing(documentName: url.lastPathComponent)
                    analyzingProgress = "Reading document..."
                    analyzingError = nil
                }

                // Parse document
                let parsedDoc = try await documentParser.parseDocument(at: url)

                // Extract interesting snippets from the document
                let snippets = extractKeySnippets(from: parsedDoc.text)
                await MainActor.run {
                    documentSnippets = snippets
                    analyzingProgress = "Extracting concepts..."
                }

                // Analyze with AI - observe progress updates
                // Start a task to monitor progress
                Task {
                    while aiAnalyzer.isAnalyzing {
                        await MainActor.run {
                            analyzingProgress = aiAnalyzer.progress
                        }
                        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                    }
                }

                // Run the analysis
                let analysisResponse = try await aiAnalyzer.analyzeDocument(parsedDoc)

                await MainActor.run {
                    analyzingProgress = "Creating concept map..."
                }

                // Create Analysis object
                let analysis = Analysis(
                    documentName: parsedDoc.fileName,
                    documentType: parsedDoc.documentType,
                    modelUsed: Config.defaultModel,
                    wordCount: parsedDoc.wordCount,
                    sourceURL: url.absoluteString
                )

                // Convert and add concepts
                var conceptMap: [String: Concept] = [:]

                for conceptResponse in analysisResponse.concepts {
                    let concept = conceptResponse.toConcept()
                    conceptMap[conceptResponse.id] = concept
                    analysis.concepts.append(concept)
                    concept.analysis = analysis
                }

                // Update parent references
                for conceptResponse in analysisResponse.concepts {
                    if let parentId = conceptResponse.parentId,
                       let parent = conceptMap[parentId],
                       let concept = conceptMap[conceptResponse.id] {
                        concept.parentID = parent.id
                    }
                }

                // Save to SwiftData
                modelContext.insert(analysis)
                try modelContext.save()

                // Navigate to canvas
                await MainActor.run {
                    appState = .canvas(analysis: analysis)
                }

            } catch {
                await MainActor.run {
                    let errorMessage = error.localizedDescription
                    print("❌ Analysis error: \(errorMessage)")
                    print("❌ Error type: \(type(of: error))")
                    print("❌ Full error: \(error)")

                    analyzingError = """
                    Error Type: \(type(of: error))

                    Details: \(errorMessage)

                    Debug Info:
                    - Document: \(url.lastPathComponent)
                    - File exists: \(FileManager.default.fileExists(atPath: url.path))
                    """
                }
            }
        }
    }

    /// Extract interesting sentences from the document to show during analysis
    private func extractKeySnippets(from text: String) -> [String] {
        // Split into sentences (simplified - look for periods followed by spaces or newlines)
        let sentences = text.components(separatedBy: .newlines)
            .flatMap { $0.components(separatedBy: ". ") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.count > 40 && $0.count < 200 } // Good length for display

        // Take up to 5 interesting sentences
        // Prefer sentences with key phrases that suggest important content
        let keyPhrases = ["key", "important", "core", "principle", "challenge", "approach",
                          "insight", "concept", "framework", "model", "strategy", "goal",
                          "because", "therefore", "however", "essential", "critical", "fundamental"]

        let prioritized = sentences.filter { sentence in
            let lowerSentence = sentence.lowercased()
            return keyPhrases.contains(where: { lowerSentence.contains($0) })
        }

        // Combine prioritized and regular sentences, take 5 max
        let selected = Array((prioritized + sentences).prefix(5))

        return selected.isEmpty ? ["Analyzing document structure..."] : selected
    }
}

#Preview {
    MainCoordinator()
        .modelContainer(for: [Analysis.self, Concept.self, Excerpt.self])
}
