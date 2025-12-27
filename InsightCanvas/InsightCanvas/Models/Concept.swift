//
//  Concept.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftData
import Foundation

@Model
final class Concept {
    var id: UUID
    var title: String
    var parentID: UUID?
    var order: Int
    var oneLineSummary: String
    var whatThisIs: String
    var whyItMatters: String
    var keyPoints: [String]

    @Relationship(deleteRule: .cascade)
    var excerpts: [Excerpt] = []

    var analysis: Analysis?

    init(
        title: String,
        parentID: UUID? = nil,
        order: Int,
        oneLineSummary: String,
        whatThisIs: String,
        whyItMatters: String,
        keyPoints: [String]
    ) {
        self.id = UUID()
        self.title = title
        self.parentID = parentID
        self.order = order
        self.oneLineSummary = oneLineSummary
        self.whatThisIs = whatThisIs
        self.whyItMatters = whyItMatters
        self.keyPoints = keyPoints
    }
}
