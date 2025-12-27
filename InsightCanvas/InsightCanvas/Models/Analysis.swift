//
//  Analysis.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftData
import Foundation

@Model
final class Analysis {
    var id: UUID
    var documentName: String
    var documentType: String
    var analyzedAt: Date
    var modelUsed: String
    var wordCount: Int?
    var sourceURL: String?

    @Relationship(deleteRule: .cascade)
    var concepts: [Concept] = []

    init(documentName: String, documentType: String, modelUsed: String, wordCount: Int? = nil, sourceURL: String? = nil) {
        self.id = UUID()
        self.documentName = documentName
        self.documentType = documentType
        self.analyzedAt = Date()
        self.modelUsed = modelUsed
        self.wordCount = wordCount
        self.sourceURL = sourceURL
    }
}
