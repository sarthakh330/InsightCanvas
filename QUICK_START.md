# Insight Canvas - Quick Start Checklist

**Updated for new direction:** Document comprehension tool (not folder management)

---

## Pre-Implementation Decisions (Answer These First)

Before writing any code, decide:

### 1. File Format Priority
**Question:** Which file formats to support in Phase 1?

- [ ] **Option A:** Start with `.txt` and `.md` only (fastest, recommended)
- [ ] **Option B:** Add `.html` support immediately
- [ ] **Option C:** Add `.docx` support (requires more research)

**Your choice:** _________

### 2. Claude API Key Management
**Question:** How should users provide their API key?

- [ ] **Option A:** Hardcode for MVP (you only, fast)
- [ ] **Option B:** Prompt on first launch, store in Keychain (recommended)
- [ ] **Option C:** Settings panel

**Your choice:** _________

### 3. YouTube Support Timeline
**Question:** When to add YouTube transcript extraction?

- [ ] **Phase 1:** Include from start (more complex)
- [ ] **Phase 2:** Add after core features work (recommended)

**Your choice:** _________

---

## Day 1: Foundation (4-6 hours)

### Morning: Xcode Setup

**Tasks:**
- [ ] Open Xcode
- [ ] Create new project:
  - macOS App
  - SwiftUI interface
  - SwiftData included
  - Project name: **"InsightCanvas"**
  - Bundle ID: `com.yourname.insightcanvas`
  - Location: `/Users/sarthakhanda/Documents/Cursor-Exp/insight-canvas/`
- [ ] Run empty project to verify setup (⌘+R)

### Afternoon: Data Models & Colors

**Tasks:**
- [ ] Create `Models/` folder in Xcode
- [ ] Add three model files:

**Analysis.swift:**
```swift
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

    @Relationship(deleteRule: .cascade)
    var concepts: [Concept] = []

    init(documentName: String, documentType: String, modelUsed: String) {
        self.id = UUID()
        self.documentName = documentName
        self.documentType = documentType
        self.analyzedAt = Date()
        self.modelUsed = modelUsed
    }
}
```

**Concept.swift:**
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

    @Relationship(deleteRule: .cascade)
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

**Excerpt.swift:**
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

- [ ] Add custom colors to `Assets.xcassets`:
  - Right-click Assets → New Color Set
  - Add: `BG-Canvas` (#fdfcf9), `BG-Sidebar` (#f2f0e9), `BG-Surface` (#FFFFFF)
  - Add: `BorderBeige` (#e2dfd6), `Accent` (#2F8F6B), `AccentHighlight` (#E4F2EC)

- [ ] Update `InsightCanvasApp.swift`:
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
        let modelConfiguration = ModelConfiguration(schema: schema)

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

- [ ] Build project (⌘+B) - should compile without errors

**End of Day 1:** ✅ Green build, data models in place, colors defined

---

## Day 2-3: Home Screen (6-8 hours)

### Reference
See `mockups/home-screen.html` in the directory

### Tasks
- [ ] Create `Views/Home/HomeView.swift`
- [ ] Implement layout:
  - Beige background (`Color("BG-Canvas")`)
  - Centered container (max 640pt width)
  - White card with dashed border (drop zone)
  - File format labels: `.txt · .md · .html · .docx`
  - YouTube input field with link icon
  - Footer: "No accounts. Your content stays on your Mac."

- [ ] Add file picker:
```swift
Button("Import document...") {
    let panel = NSOpenPanel()
    panel.allowedContentTypes = [.plainText, .text]
    panel.allowsMultipleSelection = false

    if panel.runModal() == .OK, let url = panel.url {
        handleFileSelection(url: url)
    }
}
```

- [ ] Add drag & drop:
```swift
.onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
    // Handle file drop
}
```

- [ ] Navigate to loading view on file selection

**End of Day 3:** ✅ Working home screen that accepts files

---

## Day 4: Document Parsing (3-4 hours)

### Tasks
- [ ] Create `Services/DocumentParser.swift`:
```swift
class DocumentParser {
    func parseDocument(at url: URL) throws -> String {
        return try String(contentsOf: url, encoding: .utf8)
    }
}
```

- [ ] Test with sample `.txt` file
- [ ] Handle errors (file not found, encoding issues)
- [ ] Display parsed text length

**End of Day 4:** ✅ Can extract text from documents

---

## Day 5-6: AI Integration (8-10 hours)

### Tasks
- [ ] Get Claude API key from anthropic.com/api
- [ ] Create `Services/AIAnalyzer.swift`
- [ ] Implement Claude API call (see IMPLEMENTATION_PLAN.md Phase 3.2 for prompt)
- [ ] Parse JSON response into `Concept` objects
- [ ] Store in SwiftData
- [ ] Show loading indicator during analysis

**End of Day 6:** ✅ Can analyze a document and store concepts

---

## Day 7-10: Concept Canvas UI (12-16 hours)

### Reference
See `mockups/concept-canvas.html` (Memory Systems example)

### Day 7: Sidebar
- [ ] Create `Views/ConceptCanvas/ConceptMapView.swift`
- [ ] Render hierarchical list (OutlineGroup or recursive VStack)
- [ ] Add expand/collapse chevron (SF Symbol: `chevron.right`)
- [ ] Selection state (green highlight)
- [ ] Style: 320pt width, beige background

### Day 8: Main Pane
- [ ] Create `Views/ConceptCanvas/ConceptDetailView.swift`
- [ ] Layout sections (see mockup):
  - Breadcrumb
  - Title (24pt, semibold)
  - One-line summary (16pt, italic, gray)
  - "What This Is" section
  - "Why It Matters" section
  - Key Points (custom bullets)

### Day 9: Components
- [ ] Create `Components/MentalModelCard.swift` (green card)
- [ ] Create `Components/ExcerptCollapsible.swift`
- [ ] Add search field (sticky at top of sidebar)

### Day 10: Integration
- [ ] Connect sidebar to SwiftData
- [ ] Update detail pane on selection
- [ ] Add keyboard navigation (arrow keys)
- [ ] Test with real analysis

**End of Day 10:** ✅ Fully functional Concept Canvas

---

## Day 11-12: Polish & Testing (6-8 hours)

### Tasks
- [ ] Review spacing against DESIGN_SYSTEM.md
- [ ] Verify colors match mockup
- [ ] Add smooth animations (0.3s ease)
- [ ] Implement keyboard shortcuts (Cmd+K for search)
- [ ] Test with real documents:
  - Short (2 pages)
  - Medium (10 pages)
  - Long (30+ pages)
- [ ] Fix bugs

**End of Day 12:** ✅ Polished, demo-ready app

---

## Documentation Reference

- **[INSIGHT_CANVAS_SPEC.md](./INSIGHT_CANVAS_SPEC.md)** - Product vision & requirements
- **[DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)** - Typography, colors, components
- **[IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md)** - Detailed 15-day plan

---

## What to Ask Claude Code

When ready to start:

```
I have a product spec for "Insight Canvas" - a macOS document comprehension tool.

Reference files:
- INSIGHT_CANVAS_SPEC.md (product requirements)
- DESIGN_SYSTEM.md (UI specifications)
- IMPLEMENTATION_PLAN.md (phased approach)
- Two HTML mockups (Home screen + Concept Canvas)

I want to start with Phase 0 (project setup) and Phase 1 (Home screen).

Please:
1. Review the specs and ask clarifying questions
2. Help create the Xcode project structure
3. Set up SwiftData models
4. Build the Home screen matching the mockup

Ask any questions before starting.
```

---

## Quick Commands

```bash
# Navigate to project
cd /Users/sarthakhanda/Documents/Cursor-Exp/insight-canvas

# Open Xcode
open -a Xcode

# View mockups (open in browser)
open mockups/home-screen.html
open mockups/concept-canvas.html

# Check if API key is set (if using .env)
grep "ANTHROPIC_API_KEY" .env
```

---

## Success Checklist

Before calling it "done":

- [ ] Home screen matches mockup (90%+ similarity)
- [ ] Can select files and parse text
- [ ] Claude API returns structured concepts
- [ ] Concepts render in sidebar hierarchy
- [ ] Detail pane shows all sections
- [ ] Keyboard shortcuts work (Cmd+K, arrows)
- [ ] No crashes with real documents
- [ ] App feels calm and professional

---

**Ready to start?** Answer the pre-implementation questions above, then jump into Day 1! 🚀
