//
//  DocumentParser.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import Foundation
import UniformTypeIdentifiers

enum DocumentParserError: Error, LocalizedError {
    case fileNotFound
    case unsupportedFormat
    case encodingError
    case readError(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "The document file could not be found."
        case .unsupportedFormat:
            return "This document format is not supported."
        case .encodingError:
            return "Could not decode the document text."
        case .readError(let message):
            return "Error reading document: \(message)"
        }
    }
}

struct ParsedDocument {
    let text: String
    let wordCount: Int
    let documentType: String
    let fileName: String

    init(text: String, documentType: String, fileName: String) {
        self.text = text
        self.documentType = documentType
        self.fileName = fileName
        self.wordCount = text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
}

class DocumentParser: ObservableObject {

    /// Parse a document from a URL
    func parseDocument(at url: URL) async throws -> ParsedDocument {
        let startTime = Date()
        print("📄 [Parser] Starting document parsing")
        print("📄 [Parser] File: \(url.lastPathComponent)")

        // Ensure we have file access
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("❌ [Parser] File not found at: \(url.path)")
            throw DocumentParserError.fileNotFound
        }

        let fileName = url.lastPathComponent
        let fileExtension = url.pathExtension.lowercased()
        print("📄 [Parser] File extension: .\(fileExtension)")

        // Determine document type and parse accordingly
        let parsedDoc: ParsedDocument
        switch fileExtension {
        case "txt":
            print("📄 [Parser] Parsing as plain text...")
            let text = try await parsePlainText(at: url)
            parsedDoc = ParsedDocument(text: text, documentType: "text", fileName: fileName)

        case "md", "markdown":
            print("📄 [Parser] Parsing as markdown...")
            let text = try await parsePlainText(at: url)
            parsedDoc = ParsedDocument(text: text, documentType: "markdown", fileName: fileName)

        case "html", "htm":
            print("📄 [Parser] Parsing as HTML...")
            let text = try await parseHTML(at: url)
            parsedDoc = ParsedDocument(text: text, documentType: "html", fileName: fileName)

        case "docx":
            print("📄 [Parser] Parsing as DOCX...")
            let text = try await parseDOCX(at: url)
            parsedDoc = ParsedDocument(text: text, documentType: "docx", fileName: fileName)

        default:
            print("❌ [Parser] Unsupported format: .\(fileExtension)")
            throw DocumentParserError.unsupportedFormat
        }

        let duration = Date().timeIntervalSince(startTime)
        print("✅ [Parser] Parsing completed in \(String(format: "%.2f", duration))s")
        print("✅ [Parser] Word count: \(parsedDoc.wordCount)")
        print("✅ [Parser] Text length: \(parsedDoc.text.count) chars")

        return parsedDoc
    }

    /// Parse plain text files
    private func parsePlainText(at url: URL) async throws -> String {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw DocumentParserError.readError(error.localizedDescription)
        }
    }

    /// Parse HTML files (strip tags, keep text)
    private func parseHTML(at url: URL) async throws -> String {
        do {
            let htmlContent = try String(contentsOf: url, encoding: .utf8)

            // Simple HTML tag removal (basic implementation)
            // For production, consider using NSAttributedString or a proper HTML parser
            var text = htmlContent

            // Remove script and style tags with their content
            text = text.replacingOccurrences(
                of: "<script[^>]*>[\\s\\S]*?</script>",
                with: "",
                options: .regularExpression
            )
            text = text.replacingOccurrences(
                of: "<style[^>]*>[\\s\\S]*?</style>",
                with: "",
                options: .regularExpression
            )

            // Remove all HTML tags
            text = text.replacingOccurrences(
                of: "<[^>]+>",
                with: " ",
                options: .regularExpression
            )

            // Decode HTML entities
            text = text.replacingOccurrences(of: "&nbsp;", with: " ")
            text = text.replacingOccurrences(of: "&amp;", with: "&")
            text = text.replacingOccurrences(of: "&lt;", with: "<")
            text = text.replacingOccurrences(of: "&gt;", with: ">")
            text = text.replacingOccurrences(of: "&quot;", with: "\"")

            // Clean up whitespace
            text = text.replacingOccurrences(
                of: "[ \\t]+",
                with: " ",
                options: .regularExpression
            )
            text = text.replacingOccurrences(
                of: "\\n\\s*\\n\\s*\\n+",
                with: "\\n\\n",
                options: .regularExpression
            )

            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw DocumentParserError.readError(error.localizedDescription)
        }
    }

    /// Parse DOCX files
    /// Note: This is a placeholder. For full DOCX support, consider using a library like:
    /// - swift-docx (if available)
    /// - Or using unzip + XML parsing manually
    private func parseDOCX(at url: URL) async throws -> String {
        // For Phase 1, we'll defer full DOCX support
        // This is a simplified version that attempts basic extraction

        // DOCX files are ZIP archives containing XML
        // The main content is in word/document.xml

        // TODO: Implement full DOCX parsing or integrate a library
        throw DocumentParserError.unsupportedFormat
    }

    /// Validate if a URL points to a supported document
    func isSupported(url: URL) -> Bool {
        let supportedExtensions = ["txt", "md", "markdown", "html", "htm", "docx"]
        let fileExtension = url.pathExtension.lowercased()
        return supportedExtensions.contains(fileExtension)
    }
}
