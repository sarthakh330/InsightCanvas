# InsightCanvas

A native macOS document comprehension tool that transforms knowledge documents into structured, navigable concept summaries.

## Learning Goals

This project was built as a learning exercise to explore:

1. **Native macOS Development with SwiftUI**
   - Building a production-quality macOS app from scratch
   - Modern SwiftUI patterns and best practices
   - Native macOS UI/UX design principles

2. **SwiftData & Core Data Alternatives**
   - Using SwiftData for local persistence
   - Model relationships and cascade deletion
   - Data modeling for knowledge management

3. **AI API Integration**
   - Integrating Claude (Anthropic) API in Swift
   - Structured output parsing and validation
   - Handling large documents with chunking strategies
   - Error handling and retry logic

4. **Document Processing**
   - Parsing multiple document formats (TXT, Markdown, HTML)
   - Text extraction and cleaning
   - Word count analysis

5. **Performance Optimization**
   - Async/await patterns in Swift
   - MainActor usage for UI updates
   - API call optimization and token management
   - Logging and performance monitoring

## What It Does

InsightCanvas takes any knowledge document and extracts a structured summary:
- **One-sentence summary** of the main point
- **Brief overview** (2-3 sentences)
- **Why it matters** explanation
- **Key takeaways** (3-4 bullet points)

It's NOT a chat interface or traditional summarizer—it's a structured understanding surface that helps you quickly grasp the essence of any document.

## Features

- ✅ Beautiful native macOS interface with warm beige design
- ✅ Drag & drop document support
- ✅ Real-time progress updates during analysis
- ✅ Local-first: Your content stays on your Mac
- ✅ Supports .txt, .md, .html files
- ✅ Detailed logging for debugging and performance tracking

## Current Status

**Phase 1 Complete** - Basic summary extraction with:
- Single summary mode (fast, 20-30 seconds)
- Simplified prompts for quick results
- Detailed console logging

**Future Enhancements** (Progressive):
- Phase 2: Hierarchical concept extraction
- Phase 3: Multiple concepts with relationships
- Phase 4: Excerpts and citations
- Phase 5: Mental model identification
- Phase 6: DOCX support
- Phase 7: YouTube URL support

## Setup

1. Clone the repository
2. Get an Anthropic API key from [console.anthropic.com](https://console.anthropic.com/settings/keys)
3. Set up the API key:
   - In Xcode: `Product > Scheme > Edit Scheme > Run > Environment Variables`
   - Add: `ANTHROPIC_API_KEY = your-key-here`
4. Build and run in Xcode (requires macOS 14.0+)

## Architecture

```
InsightCanvas/
├── Models/           # SwiftData models (Analysis, Concept, Excerpt)
├── Views/            # SwiftUI views
│   ├── Home/         # Welcome screen
│   ├── Components/   # Analyzing view with animations
│   └── ConceptCanvas/# Concept display and navigation
├── Services/         # Business logic
│   ├── AIAnalyzer    # Claude API integration
│   ├── DocumentParser# Document parsing
│   └── Config        # API configuration
└── Utilities/        # Color theme and helpers
```

## Design Philosophy

- **Progressive disclosure**: Start simple, add complexity only when needed
- **Native feel**: Follows macOS design guidelines
- **Performance first**: Optimized for speed and responsiveness
- **Local-first**: No cloud storage, no accounts
- **Developer-friendly**: Extensive logging and error messages

## Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Persistence**: SwiftData
- **API**: Anthropic Claude (currently Opus)
- **Build Tool**: xcodegen (project generation)
- **Platform**: macOS 14.0+

## Lessons Learned

1. **Claude Opus is slow but thorough** - 20-30s for simple summaries
2. **Prompt engineering matters** - Simpler prompts = faster results
3. **Token management is critical** - Balance between detail and speed
4. **SwiftData is delightful** - Much cleaner than Core Data
5. **Logging is essential** - Detailed logs help debug performance issues

## Contributing

This is a learning project, but feedback and suggestions are welcome! Feel free to open issues or submit PRs.

## License

MIT License - Feel free to use this for learning purposes.

---

**Built with curiosity** 🧠 **Generated with [Claude Code](https://claude.com/claude-code)**
