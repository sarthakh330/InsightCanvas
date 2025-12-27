//
//  AIAnalyzer.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import Foundation
import SwiftData

enum AIAnalyzerError: Error, LocalizedError {
    case invalidResponse
    case networkError(String)
    case parsingError(String)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Received an invalid response from the AI."
        case .networkError(let message):
            return "Network error: \(message)"
        case .parsingError(let message):
            return "Error parsing AI response: \(message)"
        case .apiError(let message):
            return "API error: \(message)"
        }
    }
}

// MARK: - Response Models

struct ConceptResponse: Codable {
    let id: String
    let title: String
    let parentId: String?
    let order: Int
    let oneLineSummary: String
    let whatThisIs: String
    let whyItMatters: String
    let keyPoints: [String]
    let excerpts: [ExcerptResponse]

    enum CodingKeys: String, CodingKey {
        case id, title, order
        case parentId = "parent_id"
        case oneLineSummary = "one_line_summary"
        case whatThisIs = "what_this_is"
        case whyItMatters = "why_it_matters"
        case keyPoints = "key_points"
        case excerpts
    }
}

struct ExcerptResponse: Codable {
    let text: String
    let location: String
    let context: String?
}

struct AnalysisResponse: Codable {
    let concepts: [ConceptResponse]
    let mentalModel: MentalModelResponse?

    enum CodingKeys: String, CodingKey {
        case concepts
        case mentalModel = "mental_model"
    }
}

struct MentalModelResponse: Codable {
    let name: String
    let description: String
}

// MARK: - AI Analyzer

class AIAnalyzer: ObservableObject {
    @Published var isAnalyzing = false
    @Published var progress: String = ""

    private let apiKey = Config.anthropicAPIKey
    private let model = Config.defaultModel
    private let apiURL = URL(string: Config.apiEndpoint)!

    /// Analyze a document and return structured concepts
    func analyzeDocument(_ document: ParsedDocument) async throws -> AnalysisResponse {
        await MainActor.run {
            isAnalyzing = true
        }
        await updateProgress("Preparing analysis...")

        // Check if document needs chunking (> 3000 words for now - simplified)
        if document.wordCount > 3000 {
            return try await analyzeDocumentInChunks(document)
        } else {
            return try await analyzeSingleDocument(document)
        }
    }

    /// Analyze a document in one go (for smaller documents)
    private func analyzeSingleDocument(_ document: ParsedDocument) async throws -> AnalysisResponse {
        let startTime = Date()
        print("📝 [AIAnalyzer] Starting single document analysis")
        print("📝 [AIAnalyzer] Document: \(document.fileName), Word count: \(document.wordCount)")

        // Build the analysis prompt
        let systemPrompt = buildSystemPrompt()
        let userPrompt = buildUserPrompt(for: document)

        print("📝 [AIAnalyzer] System prompt length: \(systemPrompt.count) chars")
        print("📝 [AIAnalyzer] User prompt length: \(userPrompt.count) chars")

        await updateProgress("Analyzing content...")

        // Call Claude API
        let apiStartTime = Date()
        print("🌐 [AIAnalyzer] Calling Claude API...")
        let response = try await callClaudeAPI(
            system: systemPrompt,
            userMessage: userPrompt
        )
        let apiDuration = Date().timeIntervalSince(apiStartTime)
        print("✅ [AIAnalyzer] API call completed in \(String(format: "%.2f", apiDuration))s")
        print("✅ [AIAnalyzer] Response length: \(response.count) chars")

        await updateProgress("Parsing concepts...")

        // Parse the response
        let parseStartTime = Date()
        let analysis = try parseAnalysisResponse(response)
        let parseDuration = Date().timeIntervalSince(parseStartTime)
        print("✅ [AIAnalyzer] Parsing completed in \(String(format: "%.2f", parseDuration))s")
        print("✅ [AIAnalyzer] Found \(analysis.concepts.count) concepts")

        await MainActor.run {
            isAnalyzing = false
        }
        await updateProgress("Analysis complete")

        let totalDuration = Date().timeIntervalSince(startTime)
        print("🎉 [AIAnalyzer] Total analysis time: \(String(format: "%.2f", totalDuration))s")

        return analysis
    }

    /// Analyze a large document by breaking it into chunks
    private func analyzeDocumentInChunks(_ document: ParsedDocument) async throws -> AnalysisResponse {
        // Split document into chunks of ~800 words each for better token efficiency
        let chunkSize = 800
        let chunks = splitIntoChunks(document.text, targetWords: chunkSize)

        await updateProgress("Document is large (\(document.wordCount) words). Analyzing in \(chunks.count) parts...")

        var allConcepts: [ConceptResponse] = []

        // Analyze each chunk
        for (index, chunk) in chunks.enumerated() {
            await updateProgress("Analyzing part \(index + 1) of \(chunks.count)...")

            let chunkDoc = ParsedDocument(
                text: chunk,
                documentType: document.documentType,
                fileName: document.fileName
            )

            let systemPrompt = buildSystemPrompt(isChunk: true)
            let userPrompt = buildUserPrompt(for: chunkDoc, chunkInfo: "Part \(index + 1) of \(chunks.count)")

            let response = try await callClaudeAPI(
                system: systemPrompt,
                userMessage: userPrompt
            )

            let chunkAnalysis = try parseAnalysisResponse(response)
            allConcepts.append(contentsOf: chunkAnalysis.concepts)
        }

        await updateProgress("Merging concepts...")

        // Deduplicate and merge similar concepts
        let mergedConcepts = mergeSimilarConcepts(allConcepts)

        await MainActor.run {
            isAnalyzing = false
        }
        await updateProgress("Analysis complete")

        return AnalysisResponse(concepts: mergedConcepts, mentalModel: nil)
    }

    /// Split text into chunks of approximately target word count
    private func splitIntoChunks(_ text: String, targetWords: Int) -> [String] {
        let paragraphs = text.components(separatedBy: "\n\n")
        var chunks: [String] = []
        var currentChunk = ""
        var currentWordCount = 0

        for paragraph in paragraphs {
            let paragraphWords = paragraph.split(separator: " ").count

            if currentWordCount + paragraphWords > targetWords && !currentChunk.isEmpty {
                // Current chunk is full, start a new one
                chunks.append(currentChunk)
                currentChunk = paragraph
                currentWordCount = paragraphWords
            } else {
                // Add to current chunk
                if !currentChunk.isEmpty {
                    currentChunk += "\n\n"
                }
                currentChunk += paragraph
                currentWordCount += paragraphWords
            }
        }

        // Add the last chunk
        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }

        return chunks
    }

    /// Merge similar concepts to avoid duplication
    private func mergeSimilarConcepts(_ concepts: [ConceptResponse]) -> [ConceptResponse] {
        // For now, just reorder concepts and remove exact duplicates by title
        var seen: Set<String> = []
        var unique: [ConceptResponse] = []

        for concept in concepts {
            if !seen.contains(concept.title) {
                seen.insert(concept.title)
                unique.append(concept)
            }
        }

        // Reorder concepts
        return unique.enumerated().map { index, concept in
            ConceptResponse(
                id: concept.id,
                title: concept.title,
                parentId: concept.parentId,
                order: index,
                oneLineSummary: concept.oneLineSummary,
                whatThisIs: concept.whatThisIs,
                whyItMatters: concept.whyItMatters,
                keyPoints: concept.keyPoints,
                excerpts: concept.excerpts
            )
        }
    }

    // MARK: - Prompt Construction

    private func buildSystemPrompt(isChunk: Bool = false) -> String {
        """
        You are an expert learning assistant. Extract multiple distinct concepts from the document.

        OUTPUT ONLY valid JSON with 3-6 separate concepts:
        {
          "concepts": [
            {
              "id": "concept-001",
              "title": "Core Thesis",
              "parent_id": null,
              "order": 0,
              "one_line_summary": "The document's main argument in one sentence",
              "what_this_is": "2-3 sentences explaining what this concept/idea is about",
              "why_it_matters": "2-3 sentences on why this is significant",
              "key_points": [
                "First key point about this concept",
                "Second key point",
                "Third key point"
              ],
              "excerpts": []
            },
            {
              "id": "concept-002",
              "title": "Key Framework",
              "parent_id": null,
              "order": 1,
              "one_line_summary": "Brief description of the framework",
              "what_this_is": "What the framework is and how it works",
              "why_it_matters": "Why this framework matters",
              "key_points": [
                "Framework component 1",
                "Framework component 2",
                "Framework component 3"
              ],
              "excerpts": []
            },
            {
              "id": "concept-003",
              "title": "Core Challenge",
              "parent_id": null,
              "order": 2,
              "one_line_summary": "The main problem or challenge discussed",
              "what_this_is": "Description of the challenge",
              "why_it_matters": "Why this challenge is important",
              "key_points": [
                "Aspect 1 of the challenge",
                "Aspect 2 of the challenge"
              ],
              "excerpts": []
            }
          ],
          "mental_model": null
        }

        CRITICAL:
        - Create 3-6 SEPARATE concepts, not one big summary
        - Each concept should be a distinct idea, framework, challenge, or insight
        - Give each concept a specific, descriptive title (not "Summary" or "Analysis")
        - Make concepts progressively detailed: start broad, then go deeper
        - Use clear, engaging language
        """
    }

    private func buildUserPrompt(for document: ParsedDocument, chunkInfo: String? = nil) -> String {
        """
        Summarize this document:

        \(document.text)

        Output ONLY JSON, no other text.
        """
    }

    // MARK: - API Communication

    private func callClaudeAPI(system: String, userMessage: String) async throws -> String {
        print("🔧 [API] Preparing request to \(apiURL)")

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.timeoutInterval = 180 // 3 minutes for large documents

        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": 2400,
            "system": system,
            "messages": [
                ["role": "user", "content": userMessage]
            ]
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = bodyData

        print("🔧 [API] Request body size: \(bodyData.count) bytes")
        print("🔧 [API] Model: \(model)")
        print("🔧 [API] Max tokens: 1200")

        await updateProgress("Sending request to Claude API...")

        let requestStartTime = Date()
        print("⏱️ [API] Request sent at \(requestStartTime)")
        let (data, response) = try await URLSession.shared.data(for: request)
        let requestDuration = Date().timeIntervalSince(requestStartTime)
        print("⏱️ [API] Response received after \(String(format: "%.2f", requestDuration))s")

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ [API] Invalid HTTP response")
            throw AIAnalyzerError.networkError("Invalid response")
        }

        print("📡 [API] Status code: \(httpResponse.statusCode)")
        print("📡 [API] Response size: \(data.count) bytes")

        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ [API] Error response: \(errorMessage)")
            throw AIAnalyzerError.apiError("Status \(httpResponse.statusCode): \(errorMessage)")
        }

        // Parse Claude API response
        print("🔍 [API] Parsing Claude response JSON...")
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstContent = content.first,
              let text = firstContent["text"] as? String else {
            print("❌ [API] Failed to extract text from response")
            throw AIAnalyzerError.invalidResponse
        }

        print("✅ [API] Successfully extracted text content")
        return text
    }

    // MARK: - Response Parsing

    private func parseAnalysisResponse(_ jsonString: String) throws -> AnalysisResponse {
        print("🔍 [Parser] Starting JSON parsing...")
        print("🔍 [Parser] Raw response length: \(jsonString.count) characters")

        // Clean the response in case there's any extra text
        var cleanedJSON = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Remove markdown code blocks if present (```json ... ``` or ``` ... ```)
        if cleanedJSON.hasPrefix("```") {
            print("🔍 [Parser] Detected markdown code block, removing...")
            // Remove opening ```json or ```
            if let firstNewline = cleanedJSON.firstIndex(of: "\n") {
                cleanedJSON = String(cleanedJSON[cleanedJSON.index(after: firstNewline)...])
            }
            // Remove closing ```
            if cleanedJSON.hasSuffix("```") {
                cleanedJSON = String(cleanedJSON.dropLast(3))
            }
            cleanedJSON = cleanedJSON.trimmingCharacters(in: .whitespacesAndNewlines)
            print("🔍 [Parser] After removing markdown: \(cleanedJSON.count) characters")
        }

        // Find JSON boundaries
        if let startIndex = cleanedJSON.firstIndex(of: "{"),
           let endIndex = cleanedJSON.lastIndex(of: "}") {
            cleanedJSON = String(cleanedJSON[startIndex...endIndex])
            print("🔍 [Parser] Extracted JSON object: \(cleanedJSON.count) characters")
        }

        guard let jsonData = cleanedJSON.data(using: .utf8) else {
            print("❌ [Parser] Failed to convert to UTF-8 data")
            throw AIAnalyzerError.parsingError("Could not convert response to data. Response preview: \(String(jsonString.prefix(500)))")
        }

        do {
            let decoder = JSONDecoder()
            // Don't use convertFromSnakeCase - we have custom CodingKeys defined
            let result = try decoder.decode(AnalysisResponse.self, from: jsonData)
            print("✅ [Parser] Successfully decoded \(result.concepts.count) concepts")
            return result
        } catch let DecodingError.keyNotFound(key, context) {
            let preview = String(cleanedJSON.prefix(800))
            print("❌ [Parser] Missing key '\(key.stringValue)' at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            print("❌ [Parser] Context: \(context.debugDescription)")
            print("❌ [Parser] JSON preview:\n\(preview)")
            throw AIAnalyzerError.parsingError("Missing required field '\(key.stringValue)' in JSON response.\n\nJSON preview:\n\(preview)")
        } catch let DecodingError.typeMismatch(type, context) {
            let preview = String(cleanedJSON.prefix(800))
            print("❌ [Parser] Type mismatch for \(type) at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            print("❌ [Parser] Context: \(context.debugDescription)")
            print("❌ [Parser] JSON preview:\n\(preview)")
            throw AIAnalyzerError.parsingError("Type mismatch in JSON: expected \(type)\n\nJSON preview:\n\(preview)")
        } catch let DecodingError.valueNotFound(type, context) {
            let preview = String(cleanedJSON.prefix(800))
            print("❌ [Parser] Value not found for \(type) at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            print("❌ [Parser] Context: \(context.debugDescription)")
            print("❌ [Parser] JSON preview:\n\(preview)")
            throw AIAnalyzerError.parsingError("Missing value in JSON for type \(type)\n\nJSON preview:\n\(preview)")
        } catch let DecodingError.dataCorrupted(context) {
            let preview = String(cleanedJSON.prefix(800))
            print("❌ [Parser] Data corrupted at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            print("❌ [Parser] Context: \(context.debugDescription)")
            print("❌ [Parser] JSON preview:\n\(preview)")
            throw AIAnalyzerError.parsingError("Corrupted JSON data: \(context.debugDescription)\n\nJSON preview:\n\(preview)")
        } catch {
            // Generic error
            let preview = String(cleanedJSON.prefix(800))
            print("❌ [Parser] Unknown decode error: \(error)")
            print("❌ [Parser] JSON preview:\n\(preview)")
            throw AIAnalyzerError.parsingError("JSON decode failed: \(error.localizedDescription)\n\nResponse preview:\n\(preview)")
        }
    }

    // MARK: - Helpers

    private func updateProgress(_ message: String) async {
        await MainActor.run {
            self.progress = message
        }
    }
}

// MARK: - SwiftData Conversion

extension ConceptResponse {
    func toConcept() -> Concept {
        let concept = Concept(
            title: title,
            parentID: parentId != nil ? UUID(uuidString: parentId!) : nil,
            order: order,
            oneLineSummary: oneLineSummary,
            whatThisIs: whatThisIs,
            whyItMatters: whyItMatters,
            keyPoints: keyPoints
        )

        // Convert excerpts
        for excerptResponse in excerpts {
            let excerpt = Excerpt(
                text: excerptResponse.text,
                location: excerptResponse.location,
                context: excerptResponse.context
            )
            concept.excerpts.append(excerpt)
        }

        return concept
    }
}
