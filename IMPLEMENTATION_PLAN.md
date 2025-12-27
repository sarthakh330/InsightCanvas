# Insight Canvas – Implementation Plan

**Version:** 1.0
**Date:** December 26, 2024
**Status:** Ready to Start

---

## Overview

This document outlines the phased implementation approach for **Insight Canvas**, a macOS document comprehension tool. The plan is optimized for learning SwiftUI while building a production-quality app.

---

## Reference Documents

1. **[INSIGHT_CANVAS_SPEC.md](./INSIGHT_CANVAS_SPEC.md)** - Complete product specification
2. **[DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)** - Design system extracted from mockups
3. **Mockups:**
   - `code.html` - Home screen (Drop to Understand)
   - Concept Canvas mockup (Memory Systems example)

---

## Phase 0: Project Setup (Day 1)

**Goal:** Set up Xcode project with proper architecture and data models.

### Tasks

#### 0.1 Create Xcode Project
- [ ] Create new macOS App project in Xcode
- [ ] Target: macOS 14.0+
- [ ] Interface: SwiftUI
- [ ] Life Cycle: SwiftUI App
- [ ] Include SwiftData

#### 0.2 Configure Assets
- [ ] Add custom colors to `Assets.xcassets`:
  - `BG-Canvas` (#fdfcf9)
  - `BG-Sidebar` (#f2f0e9)
  - `BG-Surface` (#FFFFFF)
  - `BorderBeige` (#e2dfd6)
  - `Accent` (#2F8F6B)
  - `AccentHighlight` (#E4F2EC)
- [ ] Verify light/dark mode support (light mode primary)

#### 0.3 Define SwiftData Models
Create `Models/` directory with:

**Analysis.swift**
```swift
import SwiftData
import Foundation

@Model
final class Analysis {
    var id: UUID
    var documentName: String
    var documentType: DocumentType
    var analyzedAt: Date
    var modelUsed: String
    var wordCount: Int?
    var duration: Int? // For videos (seconds)

    @Relationship(deleteRule: .cascade, inverse: \Concept.analysis)
    var concepts: [Concept] = []

    init(documentName: String, documentType: DocumentType, modelUsed: String) {
        self.id = UUID()
        self.documentName = documentName
        self.documentType = documentType
        self.analyzedAt = Date()
        self.modelUsed = modelUsed
    }
}

enum DocumentType: String, Codable {
    case txt
    case md
    case html
    case docx
    case youtube
}
```

**Concept.swift**
```swift
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

    @Relationship(deleteRule: .cascade, inverse: \Excerpt.concept)
    var excerpts: [Excerpt] = []

    var analysis: Analysis?

    init(title: String, parentID: UUID? = nil, order: Int,
         oneLineSummary: String, whatThisIs: String,
         whyItMatters: String, keyPoints: [String]) {
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
```

**Excerpt.swift**
```swift
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
```

#### 0.4 Set Up Project Structure
```
InsightCanvas/
├── App/
│   └── InsightCanvasApp.swift
├── Models/
│   ├── Analysis.swift
│   ├── Concept.swift
│   └── Excerpt.swift
├── Views/
│   ├── Home/
│   │   └── HomeView.swift
│   ├── ConceptCanvas/
│   │   ├── ConceptCanvasView.swift
│   │   ├── ConceptMapView.swift (Sidebar)
│   │   └── ConceptDetailView.swift (Main pane)
│   └── Components/
│       ├── SearchField.swift
│       ├── MentalModelCard.swift
│       └── ExcerptCollapsible.swift
├── Services/
│   ├── DocumentParser.swift
│   ├── AIAnalyzer.swift
│   └── YouTubeTranscriptService.swift
└── Utilities/
    └── Extensions.swift
```

#### 0.5 Initialize SwiftData Container
In `InsightCanvasApp.swift`:
```swift
import SwiftUI
import SwiftData

@main
struct InsightCanvasApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Analysis.self,
            Concept.self,
            Excerpt.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
```

**Success Criteria:**
- [ ] Xcode project compiles without errors
- [ ] Custom colors visible in preview
- [ ] SwiftData models defined
- [ ] Project structure in place

---

## Phase 1: Home Screen (Days 2-3)

**Goal:** Build the "Drop to Understand" landing screen with file picker and YouTube input.

### Tasks

#### 1.1 Build HomeView Shell
- [ ] Create `Views/Home/HomeView.swift`
- [ ] Implement layout from mockup:
  - Centered container (max 640pt width)
  - Drop zone card
  - File format labels
  - YouTube input field
  - Footer trust message

#### 1.2 Implement File Picker
- [ ] Add "Import Document..." button action
- [ ] Use `NSOpenPanel` to select files
- [ ] Filter by supported types: `.txt`, `.md`, `.html`, `.docx`
- [ ] Display selected file name (temporary state)

#### 1.3 Implement Drag & Drop
- [ ] Add `.onDrop` modifier to drop zone
- [ ] Handle file drop events
- [ ] Validate file type
- [ ] Show error for unsupported types

#### 1.4 YouTube Input Field
- [ ] Create input field with link icon
- [ ] Add "Analyze" button
- [ ] Validate YouTube URL format
- [ ] Show error for invalid URLs

#### 1.5 Navigation to Concept Canvas
- [ ] Add navigation state management
- [ ] On file/URL selection → navigate to loading screen
- [ ] Pass document info to next view

**Reference:** `code.html` mockup for exact layout

**Success Criteria:**
- [ ] Home screen matches mockup design
- [ ] File picker works for all supported formats
- [ ] Drag & drop accepts valid files
- [ ] YouTube URL validation works
- [ ] Navigation to next screen triggers

---

## Phase 2: Document Parsing (Day 3-4)

**Goal:** Extract text content from supported document formats.

### Tasks

#### 2.1 Create DocumentParser Service
- [ ] Create `Services/DocumentParser.swift`
- [ ] Define protocol:
```swift
protocol DocumentParser {
    func parseDocument(at url: URL) throws -> String
}
```

#### 2.2 Implement Parsers
- [ ] **TextParser** (`.txt`, `.md`): Direct read
- [ ] **HTMLParser** (`.html`): Strip tags, extract text
- [ ] **DOCXParser** (`.docx`):
  - Research library options (e.g., `ZIPFoundation` + XML parsing)
  - Or use AppleScript to convert via TextEdit
  - Or defer to Phase 2 (start with .txt/.md only)

#### 2.3 Error Handling
- [ ] Handle file read errors
- [ ] Handle malformed documents
- [ ] Return clear error messages

**Success Criteria:**
- [ ] Can parse `.txt` and `.md` files reliably
- [ ] Extracted text is clean (no markup artifacts)
- [ ] Errors are handled gracefully

---

## Phase 3: AI Integration (Days 4-6)

**Goal:** Connect to Claude API and generate structured concept analysis.

### Tasks

#### 3.1 Set Up Claude API Client
- [ ] Add API key configuration (stored securely in Keychain)
- [ ] Create `Services/AIAnalyzer.swift`
- [ ] Implement async API call to Claude

#### 3.2 Design AI Prompt
Create structured prompt that returns JSON matching the schema:

**Prompt Structure:**
```
You are analyzing a technical document to create a structured concept map.

[DOCUMENT]
{document_text}

[TASK]
Extract the main concepts and organize them hierarchically.

[OUTPUT FORMAT]
Return a JSON object with this exact structure:
{
  "concepts": [
    {
      "id": "uuid",
      "title": "Short concept name",
      "parent_id": "uuid or null",
      "order": 0,
      "one_line_summary": "Max 120 chars",
      "what_this_is": "2-3 sentences",
      "why_it_matters": "1-2 sentences",
      "key_points": ["Point 1", "Point 2"],
      "excerpts": [
        {
          "text": "Direct quote",
          "location": "Page 5 or Section 2",
          "context": "Optional context"
        }
      ]
    }
  ]
}

[CONSTRAINTS]
- Use short, noun-based concept titles
- Create 5-15 top-level concepts
- Nest related sub-concepts (max 3 levels deep)
- Each concept must have 3-5 key points
- Include 2-3 excerpts per concept
```

#### 3.3 Parse AI Response
- [ ] Decode JSON response
- [ ] Validate structure
- [ ] Handle API errors (rate limits, timeouts)
- [ ] Store results in SwiftData

#### 3.4 Create Loading State
- [ ] Show progress indicator during analysis
- [ ] Display estimated time (1-2 minutes)
- [ ] Allow cancellation

**Success Criteria:**
- [ ] Claude API integration works
- [ ] Returns valid JSON matching schema
- [ ] Concepts are stored in SwiftData
- [ ] Loading state is clear and accurate

---

## Phase 4: Concept Canvas UI (Days 7-10)

**Goal:** Build the two-pane Concept Canvas interface.

### Tasks

#### 4.1 Create ConceptCanvasView Shell
- [ ] Create `Views/ConceptCanvas/ConceptCanvasView.swift`
- [ ] Implement HSplitView with:
  - Left: ConceptMapView (280-320pt)
  - Right: ConceptDetailView (flexible, max 720pt)

#### 4.2 Build ConceptMapView (Sidebar)
**Components:**
- [ ] Sticky search header
- [ ] Scrollable concept tree
- [ ] Footer with status

**Features:**
- [ ] Render hierarchical concepts (recursive outline)
- [ ] Expand/collapse with chevron animation
- [ ] Selection state (highlight selected concept)
- [ ] Keyboard navigation (arrow keys, Enter)

**Reference:** Concept Canvas mockup sidebar

#### 4.3 Build ConceptDetailView (Main Pane)
**Sections:**
- [ ] Breadcrumb navigation
- [ ] Concept title + one-line summary
- [ ] Mental Model card (if applicable)
- [ ] "What This Is" section
- [ ] "Why It Matters" section
- [ ] Key Points (bullet list with custom styling)
- [ ] Related Concepts (tag pills)
- [ ] "From the Document" collapsible

**Features:**
- [ ] Scroll to top when concept changes
- [ ] Smooth transitions
- [ ] Keyboard accessibility

**Reference:** Concept Canvas mockup main pane (Memory Systems)

#### 4.4 Create Reusable Components

**SearchField.swift:**
- [ ] Input field with icon and keyboard shortcut hint
- [ ] Focus ring on active state

**MentalModelCard.swift:**
- [ ] Green-tinted card with icon
- [ ] Only show if concept has mental model text

**ExcerptCollapsible.swift:**
- [ ] Collapsible details element
- [ ] Excerpts with border-left accent
- [ ] "View Page" link on hover

#### 4.5 Connect to Data
- [ ] Fetch Analysis from SwiftData
- [ ] Build concept tree from flat list (using `parentID`)
- [ ] Handle selection state
- [ ] Update detail pane on selection

**Success Criteria:**
- [ ] Sidebar renders concept hierarchy correctly
- [ ] Expand/collapse animations are smooth
- [ ] Selection highlights active concept
- [ ] Detail pane shows all required sections
- [ ] Layout matches mockup design
- [ ] Keyboard navigation works

---

## Phase 5: YouTube Support (Days 11-12)

**Goal:** Add YouTube transcript extraction and analysis.

### Tasks

#### 5.1 Research Transcript Extraction
Options:
- **Option A:** Use `youtube-transcript-api` (Python) via Process
- **Option B:** Use YouTube Data API v3 (requires API key)
- **Option C:** Use `yt-dlp` command-line tool

**Recommendation:** Start with `yt-dlp` (widely used, reliable)

#### 5.2 Implement YouTubeTranscriptService
- [ ] Create `Services/YouTubeTranscriptService.swift`
- [ ] Install `yt-dlp` as dependency or bundle it
- [ ] Extract transcript via command-line call
- [ ] Parse output into plain text
- [ ] Handle errors (no captions, private video)

#### 5.3 Integrate into Analysis Pipeline
- [ ] Detect YouTube URL in HomeView
- [ ] Call YouTubeTranscriptService
- [ ] Show progress (downloading transcript)
- [ ] Pass transcript to AIAnalyzer
- [ ] Store video metadata (title, duration)

#### 5.4 Update UI for Video Context
- [ ] Show video title in breadcrumb
- [ ] Display "Transcript from YouTube" label
- [ ] Use timestamp format in excerpts (e.g., "12:34")

**Success Criteria:**
- [ ] Can extract transcripts from YouTube videos
- [ ] Handles errors gracefully (no captions, etc.)
- [ ] Concept Canvas works identically for video content
- [ ] Excerpts show timestamps instead of page numbers

---

## Phase 6: Polish & Testing (Days 13-14)

**Goal:** Refine UX, fix bugs, and test with real documents.

### Tasks

#### 6.1 Visual Polish
- [ ] Review all spacing against design system
- [ ] Verify colors match mockups
- [ ] Add subtle shadows where needed
- [ ] Ensure smooth animations (0.3s ease)

#### 6.2 Error Handling
- [ ] Graceful failures for API errors
- [ ] Clear error messages (not technical jargon)
- [ ] Retry mechanism for network issues

#### 6.3 Performance Optimization
- [ ] Lazy loading for large concept trees
- [ ] Debounce search input
- [ ] Optimize SwiftData queries

#### 6.4 Testing with Real Documents
Test with:
- [ ] Short document (1-2 pages)
- [ ] Medium document (10-15 pages)
- [ ] Long document (30+ pages)
- [ ] YouTube video (10-30 min)
- [ ] Edge cases (empty file, malformed DOCX)

#### 6.5 Keyboard Shortcuts
- [ ] Cmd+K: Focus search
- [ ] Arrow keys: Navigate concepts
- [ ] Enter: Select/expand concept
- [ ] Esc: Clear search
- [ ] Cmd+N: New analysis (return to home)

#### 6.6 Accessibility
- [ ] VoiceOver labels for all interactive elements
- [ ] Keyboard navigation for all features
- [ ] Focus indicators visible
- [ ] Sufficient color contrast

**Success Criteria:**
- [ ] App feels polished and professional
- [ ] No crashes or major bugs
- [ ] Performance is smooth with real documents
- [ ] Keyboard shortcuts work
- [ ] Accessibility is functional

---

## Phase 7: Finalization (Day 15)

**Goal:** Prepare for first release/demo.

### Tasks

#### 7.1 Documentation
- [ ] Update README with:
  - Setup instructions
  - Supported file formats
  - How to get Claude API key
  - Known limitations

#### 7.2 App Icon & Branding
- [ ] Design app icon (macOS style)
- [ ] Update app name and bundle ID
- [ ] Add version number (1.0)

#### 7.3 Settings/Preferences (Optional)
- [ ] API key input (if not hardcoded)
- [ ] Model selection (Sonnet, Haiku)

#### 7.4 Final Testing
- [ ] Clean install test
- [ ] Test on different macOS version (if possible)
- [ ] Check memory usage with large files

**Success Criteria:**
- [ ] App is ready for demo
- [ ] Documentation is clear
- [ ] No known critical bugs

---

## Open Questions & Decisions Needed

### 1. DOCX Parsing Library
**Options:**
- **ZIPFoundation + XML parsing** (complex, manual)
- **AppleScript + TextEdit** (hacky but works)
- **Defer to Phase 2** (start with .txt/.md only)

**Recommendation:** Start with .txt/.md, add DOCX in Phase 2

### 2. Claude API Key Storage
**Options:**
- Hardcode for MVP (insecure but fast)
- Store in Keychain (secure but more setup)
- Prompt user on first launch

**Recommendation:** Prompt user on first launch, store in Keychain

### 3. YouTube Transcript Extraction
**Options:**
- `yt-dlp` (reliable, requires bundling)
- YouTube Data API (requires API key)
- Third-party service (adds dependency)

**Recommendation:** Use `yt-dlp` via command-line call

### 4. Mental Model Detection
**Question:** How does AI determine if a concept has a "Mental Model"?

**Recommendation:** Include in AI prompt:
```
If a concept benefits from an analogy or mental model,
include a "mental_model" field with a short analogy.
```

### 5. Related Concepts Linking
**Question:** How are "Related Concepts" determined?

**Recommendation:** AI analyzes cross-references in document and suggests related concept IDs.

---

## Success Metrics (Revisited)

### Functional Success
- [ ] Analyze .txt/.md files without errors
- [ ] Extract YouTube transcripts reliably (>90% success rate)
- [ ] Concept hierarchy is logically structured
- [ ] AI analysis completes in <2 minutes for typical doc (5000 words)

### User Experience Success
- [ ] User can understand complex doc in <5 minutes
- [ ] UI feels calm and professional (matches mockups)
- [ ] Keyboard navigation works seamlessly
- [ ] No confusion during primary workflows

### Learning Goals Success
- [ ] Working macOS app with production-quality UX
- [ ] Deep understanding of SwiftUI (views, state, navigation)
- [ ] Experience with SwiftData (models, relationships, queries)
- [ ] Structured AI output integration (not just chat)
- [ ] Spec-driven development workflow demonstrated

---

## Timeline Summary

| Phase | Duration | Focus |
|-------|----------|-------|
| Phase 0 | 1 day | Project setup, data models |
| Phase 1 | 2 days | Home screen, file picker |
| Phase 2 | 1 day | Document parsing |
| Phase 3 | 2 days | AI integration (Claude API) |
| Phase 4 | 4 days | Concept Canvas UI |
| Phase 5 | 2 days | YouTube support |
| Phase 6 | 2 days | Polish & testing |
| Phase 7 | 1 day | Finalization |
| **Total** | **15 days** | **~3 weeks at steady pace** |

---

## Next Immediate Steps

1. **Answer Open Questions** (above)
2. **Create Xcode Project** (Phase 0.1)
3. **Set up SwiftData Models** (Phase 0.3)
4. **Build Home Screen** (Phase 1)

---

**Status:** ✅ Ready to Begin Implementation
**Last Updated:** December 26, 2024
