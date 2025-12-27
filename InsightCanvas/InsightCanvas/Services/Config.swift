//
//  Config.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import Foundation

struct Config {
    // Get your API key from: https://console.anthropic.com/settings/keys
    // Add it to Xcode: Product > Scheme > Edit Scheme > Run > Environment Variables
    // Add: ANTHROPIC_API_KEY = your-key-here
    static let anthropicAPIKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"] ?? "YOUR_API_KEY_HERE"

    // Models: claude-3-opus-20240229, claude-3-sonnet-20240229, claude-3-haiku-20240307
    static let defaultModel = "claude-3-opus-20240229"
    static let apiEndpoint = "https://api.anthropic.com/v1/messages"
}
