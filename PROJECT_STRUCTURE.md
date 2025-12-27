# Insight Canvas - Project Structure

**Last Updated:** December 26, 2024

---

## Directory Structure

```
insight-canvas/
├── INSIGHT_CANVAS_SPEC.md      # Complete product specification
├── DESIGN_SYSTEM.md             # UI/UX specifications (colors, typography, components)
├── IMPLEMENTATION_PLAN.md       # 15-day phased implementation guide
├── QUICK_START.md               # Day-by-day checklist for implementation
├── README.md                    # Project overview and navigation
├── PROJECT_STRUCTURE.md         # This file
├── .gitignore                   # Git ignore patterns for Xcode/macOS
│
├── mockups/
│   ├── home-screen.html         # "Drop to Understand" landing page mockup
│   └── concept-canvas.html      # Main app UI mockup (Memory Systems example)
│
└── InsightCanvas/               # (To be created) Xcode project directory
    ├── InsightCanvas.xcodeproj
    ├── InsightCanvas/
    │   ├── InsightCanvasApp.swift
    │   ├── Models/
    │   │   ├── Analysis.swift
    │   │   ├── Concept.swift
    │   │   └── Excerpt.swift
    │   ├── Views/
    │   │   ├── Home/
    │   │   │   └── HomeView.swift
    │   │   ├── ConceptCanvas/
    │   │   │   ├── ConceptCanvasView.swift
    │   │   │   ├── ConceptMapView.swift
    │   │   │   └── ConceptDetailView.swift
    │   │   └── Components/
    │   │       ├── SearchField.swift
    │   │       ├── MentalModelCard.swift
    │   │       └── ExcerptCollapsible.swift
    │   ├── Services/
    │   │   ├── DocumentParser.swift
    │   │   ├── AIAnalyzer.swift
    │   │   └── YouTubeTranscriptService.swift (Phase 2)
    │   └── Assets.xcassets/
    │       └── Colors/
    │           ├── BG-Canvas
    │           ├── BG-Sidebar
    │           ├── BG-Surface
    │           ├── BorderBeige
    │           ├── Accent
    │           └── AccentHighlight
    └── InsightCanvasTests/
```

---

## File Purposes

### Specification Documents

#### INSIGHT_CANVAS_SPEC.md
**Purpose:** Authoritative product specification
**Contents:**
- Product evolution (from folder management to document comprehension)
- 5 core product principles (non-negotiable)
- Detailed UX for both screens (Home + Concept Canvas)
- AI output contract (critical section)
- Technical architecture
- Success criteria

**Read this first** to understand the product vision.

#### DESIGN_SYSTEM.md
**Purpose:** Complete UI/UX specification
**Contents:**
- Color palette with hex codes
- Typography scale (SF Pro)
- Spacing system (8pt base)
- Component specifications (every UI element)
- SF Symbols reference
- Animation timing
- Accessibility guidelines

**Use this during implementation** to match the mockup designs exactly.

#### IMPLEMENTATION_PLAN.md
**Purpose:** Detailed implementation roadmap
**Contents:**
- 15-day phased approach (Phase 0-7)
- Task breakdown for each phase
- Code snippets for SwiftData models
- Open questions and decisions
- Success metrics per phase
- Technical architecture details

**Consult this for the big picture** and long-term planning.

#### QUICK_START.md
**Purpose:** Actionable checklist
**Contents:**
- Pre-implementation decisions (3 questions)
- Day-by-day tasks (12 days compressed)
- Code snippets ready to paste
- Quick commands
- What to ask Claude Code

**Use this to start building immediately.**

#### README.md
**Purpose:** Project overview and navigation
**Contents:**
- High-level product description
- Links to all key documents
- Technology stack
- Core principles summary
- Next steps

**Share this with others** to explain the project.

---

## Mockups

### home-screen.html
**Description:** Landing page mockup
**Shows:**
- Beige warm background
- Drop zone for documents
- YouTube link input
- Trust message footer

**Implementation:** Day 2-3 (Home Screen phase)

### concept-canvas.html
**Description:** Main application UI
**Shows:**
- Two-pane split view (sidebar + detail)
- Hierarchical concept tree
- Concept detail sections
- Mental Model card
- "From the Document" collapsible

**Implementation:** Day 7-10 (Concept Canvas phase)

---

## Key Decisions Made

### Project Separation
- **Original project:** `knowledge-navigator` (folder-level document management)
- **New project:** `insight-canvas` (single-document comprehension)
- **Reason:** Clearer focus, simpler scope, better learning experience

### Technology Choices
- **Framework:** SwiftUI (native macOS experience)
- **Data:** SwiftData (SQLite-backed, zero boilerplate)
- **AI:** Claude API (structured output, not chat)
- **Target:** macOS 14+

### Design Philosophy
- **Calm over flashy** (beige backgrounds, subtle animations)
- **Structure over prose** (concepts, not summaries)
- **Native over web-like** (SF Pro, SF Symbols, Apple HIG)
- **Keyboard-first** (arrow keys, Cmd+K, no mouse required)

---

## Implementation Workflow

### Phase 0: Setup (Day 1)
1. Create Xcode project "InsightCanvas"
2. Add SwiftData models (Analysis, Concept, Excerpt)
3. Add custom colors to Assets.xcassets
4. Verify green build

### Phase 1: Home Screen (Days 2-3)
1. Create HomeView.swift
2. Implement file picker + drag & drop
3. Add YouTube input field
4. Test with sample files

### Phase 2: Document Parsing (Day 4)
1. Create DocumentParser.swift
2. Parse .txt and .md files
3. Handle errors gracefully

### Phase 3: AI Integration (Days 5-6)
1. Create AIAnalyzer.swift
2. Implement Claude API call with structured prompt
3. Parse JSON response into Concept objects
4. Store in SwiftData

### Phase 4: Concept Canvas (Days 7-10)
1. Build sidebar (ConceptMapView)
2. Build detail pane (ConceptDetailView)
3. Create reusable components
4. Connect to SwiftData

### Phase 5: Polish (Days 11-12)
1. Match design system exactly
2. Add animations
3. Implement keyboard shortcuts
4. Test with real documents

---

## Next Steps

### If Starting Fresh:
1. Read [README.md](./README.md) (5 min)
2. Read [INSIGHT_CANVAS_SPEC.md](./INSIGHT_CANVAS_SPEC.md) (20 min)
3. Skim [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md) (10 min)
4. Follow [QUICK_START.md](./QUICK_START.md) (start Day 1)

### If Resuming Work:
1. Check [QUICK_START.md](./QUICK_START.md) for current phase
2. Reference [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md) for UI specs
3. Consult [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md) for details

### If Asking for Help:
Provide context:
```
I'm building Insight Canvas, a macOS document comprehension tool.

Current phase: [Phase X]
Current task: [specific task]

Reference docs:
- INSIGHT_CANVAS_SPEC.md (product requirements)
- DESIGN_SYSTEM.md (UI specifications)
- mockups/[relevant-mockup].html

Question: [your question]
```

---

## Related Projects

### knowledge-navigator/ (Original Project)
- **Status:** Archived/paused
- **Scope:** Folder-level document management system
- **Why paused:** Too complex for initial implementation, learning goals better served by simpler scope

**Key differences:**
| Feature | Knowledge Navigator | Insight Canvas |
|---------|---------------------|----------------|
| Scope | Folder management | Single document |
| UI | File table + Knowledge Space | Home + Concept Canvas |
| Data | 5 entities (FileEntity, QualityAssessment, etc.) | 3 entities (Analysis, Concept, Excerpt) |
| Analysis | Quality scoring, relationships, recommendations | Concept hierarchy, explanations |
| Complexity | High (multi-doc synthesis) | Medium (structured analysis) |

---

## Git Workflow (Recommended)

```bash
# Navigate to project
cd /Users/sarthakhanda/Documents/Cursor-Exp/insight-canvas

# Initialize git (if not already)
git init

# Add all specification files
git add *.md mockups/ .gitignore

# First commit
git commit -m "Initial commit: Insight Canvas specifications and mockups

- Complete product spec (INSIGHT_CANVAS_SPEC.md)
- Design system extracted from mockups (DESIGN_SYSTEM.md)
- 15-day implementation plan (IMPLEMENTATION_PLAN.md)
- Day-by-day quick start guide (QUICK_START.md)
- HTML mockups (home screen + concept canvas)

Ready for Phase 0 implementation."

# When Xcode project is created:
git add InsightCanvas/
git commit -m "Phase 0: Xcode project setup with SwiftData models"
```

---

## Status

**Version:** 1.0 (Specification Complete)
**Implementation Status:** Not Started (Ready for Day 1)
**Last Updated:** December 26, 2024

---

**Everything you need to start building is in this directory.** 🚀
