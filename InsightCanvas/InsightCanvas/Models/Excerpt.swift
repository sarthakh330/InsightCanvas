//
//  Excerpt.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftData
import Foundation

@Model
final class Excerpt {
    var id: UUID
    var text: String
    var location: String
    var context: String?

    var concept: Concept?

    init(text: String, location: String, context: String? = nil) {
        self.id = UUID()
        self.text = text
        self.location = location
        self.context = context
    }
}
