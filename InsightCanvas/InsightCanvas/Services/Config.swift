//
//  Config.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import Foundation

struct Config {
    // MARK: - API Key Loading

    /// Loads API key from multiple sources (priority order):
    /// 1. Environment variable (Xcode scheme)
    /// 2. .env file in project root
    /// 3. Fallback to placeholder
    static let anthropicAPIKey: String = {
        // 1. Try environment variable first
        if let envKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"],
           !envKey.isEmpty,
           envKey != "YOUR_API_KEY_HERE" {
            print("✅ [Config] Using API key from environment variable")
            return envKey
        }

        // 2. Try loading from .env file
        if let projectRoot = findProjectRoot(),
           let envKey = loadFromEnvFile(at: projectRoot),
           !envKey.isEmpty,
           envKey != "YOUR_API_KEY_HERE" {
            print("✅ [Config] Using API key from .env file")
            return envKey
        }

        print("⚠️ [Config] No API key found - using placeholder")
        return "YOUR_API_KEY_HERE"
    }()

    // Models: claude-3-opus-20240229, claude-3-sonnet-20240229, claude-3-haiku-20240307
    static let defaultModel = "claude-3-opus-20240229"
    static let apiEndpoint = "https://api.anthropic.com/v1/messages"

    // MARK: - Validation

    /// Check if API key is properly configured
    static func isAPIKeyConfigured() -> Bool {
        return anthropicAPIKey != "YOUR_API_KEY_HERE" && !anthropicAPIKey.isEmpty
    }

    /// Get user-friendly setup message
    static func getSetupMessage() -> String {
        """
        API Key Not Configured

        To use InsightCanvas, you need an Anthropic API key.

        📝 Setup Steps:

        1. Get your API key from:
           https://console.anthropic.com/settings/keys

        2. Create a .env file in the project root:
           ANTHROPIC_API_KEY=your-key-here

        Or set it in Xcode:
           Product > Scheme > Edit Scheme > Run >
           Environment Variables > Add ANTHROPIC_API_KEY

        Then rebuild and relaunch the app.
        """
    }

    // MARK: - Private Helpers

    /// Find the project root directory by looking for .git or InsightCanvas.xcodeproj
    private static func findProjectRoot() -> URL? {
        var currentPath = URL(fileURLWithPath: #file)

        // Go up directories until we find project markers
        for _ in 0..<10 {
            currentPath = currentPath.deletingLastPathComponent()

            let gitPath = currentPath.appendingPathComponent(".git")
            let projectPath = currentPath.appendingPathComponent("InsightCanvas.xcodeproj")

            if FileManager.default.fileExists(atPath: gitPath.path) ||
               FileManager.default.fileExists(atPath: projectPath.path) {
                return currentPath
            }
        }

        return nil
    }

    /// Load ANTHROPIC_API_KEY from .env file
    private static func loadFromEnvFile(at projectRoot: URL) -> String? {
        let envPath = projectRoot.appendingPathComponent(".env")

        guard FileManager.default.fileExists(atPath: envPath.path),
              let contents = try? String(contentsOf: envPath, encoding: .utf8) else {
            return nil
        }

        // Parse .env file line by line
        for line in contents.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Skip comments and empty lines
            if trimmed.isEmpty || trimmed.hasPrefix("#") {
                continue
            }

            // Look for ANTHROPIC_API_KEY=value
            if trimmed.hasPrefix("ANTHROPIC_API_KEY=") {
                let key = trimmed
                    .replacingOccurrences(of: "ANTHROPIC_API_KEY=", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                return key
            }
        }

        return nil
    }
}
