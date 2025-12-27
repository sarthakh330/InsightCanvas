# Insight Canvas – Product Specification

**Version:** 1.0 (Foundational Spec)
**Date:** December 26, 2024
**Platform:** macOS (SwiftUI, macOS 14+)
**Primary User:** Individual knowledge worker (platform PM, engineer, researcher)
**Usage Mode:** Local, single-user, document-at-a-time
**Status:** Ready for Phase 1 implementation

---

## 1. Product Evolution & Core Insight

### Original Direction
Build a folder-level knowledge system that indexes, assesses, and synthesizes large document corpora with quality scoring, relationship graphs, and automated analysis.

### The Pivot
Through iteration, we recognized that folder management, diffing, and multi-document synthesis introduced complexity that obscured the core value and learning goals.

**Key Insight:**
The highest leverage problem is not *managing documents*, but helping a human *deeply understand one complex document* quickly and accurately.

### What Changed
- ❌ From: Document management → ✅ To: Document comprehension
- ❌ From: Summaries → ✅ To: Structured concepts and frameworks
- ❌ From: Scroll-based reading → ✅ To: Navigable understanding surface
- ❌ From: Generic AI chat → ✅ To: Native macOS experience

---

## 2. Product Vision

### One-Liner
**Insight Canvas turns a technical document into a structured, navigable understanding surface.**

### Core Promise
Drop in a document (or YouTube link) and receive:
- A clear conceptual map
- Well-structured explanations of key ideas
- A way to explore frameworks and relationships
- The ability to zoom in and out without cognitive overload

### What This Is NOT
- ❌ Not a chat app
- ❌ Not a summarizer
- ❌ Not a file manager
- ❌ Not an agent platform (Phase 1)

---

## 3. Core Product Principles

**These principles are non-negotiable and should guide all design and implementation decisions.**

### 3.1 Structured Understanding Over Text Generation
The output must be **structured**: concepts, hierarchies, and relationships.
Long prose summaries are explicitly discouraged.

### 3.2 Progressive Disclosure
The user should:
- See the whole structure at a glance
- Zoom into any concept without losing context
- Never be forced into long scrolls

### 3.3 Evidence-Linked, But Not Evidence-Heavy
Concepts must be grounded in the source document, but:
- Raw text is secondary
- Excerpts are collapsed by default
- The primary surface is **interpretation**, not citation

### 3.4 Native macOS Experience
- Keyboard-first navigation
- Calm, professional typography (SF Pro)
- SwiftUI idioms throughout
- Apple HIG compliance
- **No web-app-in-a-window feel**

### 3.5 Trust Through Restraint
- No over-claiming ("AI magic" language)
- Clear, deliberate interactions
- Honest about limitations
- The app should feel **serious and professional**

---

## 4. Scope Definition

### ✅ In Scope (Phase 1)

**Core Functionality:**
- Single document analysis (one at a time)
- Manual, user-triggered analysis

**Supported Inputs:**
- `.txt` files
- `.md` (Markdown) files
- `.html` files
- `.docx` (Word documents)
- YouTube links (transcript extraction)

**Core Features:**
- Concept extraction and hierarchy generation
- Concept-focused UI (Concept Canvas)
- Local persistence of recent analyses
- Transcript extraction for YouTube content

### ❌ Explicitly Out of Scope (Phase 1)

- Folder indexing or batch analysis
- Multi-document synthesis
- File watching / auto re-analysis
- Quality scoring across documents
- Timeline views
- Relationship graphs across documents
- Agent/MCP integration
- User accounts or cloud sync
- In-app document editing

---

## 5. User Experience

### Screen 1: Home – "Drop to Understand"

**Intent:** Remove friction and hesitation. One clear action.

**User Actions:**
1. Drag & drop a document file
2. Click "Import Document..." button
3. Paste a YouTube link

**On Action:** User is immediately transitioned to the Concept Canvas

**Design Constraints:**
- No lists of previous documents (Phase 1)
- No settings panel
- No chat interface
- Calm, centered layout
- Clear trust signal: "Your content stays on your Mac"

**Visual Hierarchy:**
```
┌─────────────────────────────────────┐
│                                     │
│         [App Icon]                  │
│                                     │
│      Insight Canvas                 │
│                                     │
│   Drop a document to understand it  │
│                                     │
│   ┌──────────────────────────┐     │
│   │  Drop document here      │     │
│   │                          │     │
│   │  or Import Document...   │     │
│   └──────────────────────────┘     │
│                                     │
│   Or paste YouTube link:            │
│   ┌──────────────────────────┐     │
│   │  https://youtube.com/... │     │
│   └──────────────────────────┘     │
│                                     │
│   Your content stays on your Mac    │
│                                     │
└─────────────────────────────────────┘
```

---

### Screen 2: Concept Canvas (Main Experience)

**This is the product.**

#### Layout: Two-Pane Split View
```
┌────────────────────────────────────────────┐
│ [← Back]  Document Title           [⋯]    │
├──────────────┬─────────────────────────────┤
│              │                             │
│  Concept     │    Concept Detail           │
│  Map         │                             │
│  (Left)      │    (Right)                  │
│              │                             │
│              │                             │
└──────────────┴─────────────────────────────┘
```

**No third pane in Phase 1.**

---

#### Left Pane: Concept Map

**Purpose:** Provide a high-level mental model of the document.

**Characteristics:**
- Hierarchical, collapsible outline
- Short, noun-based concept labels (e.g., "Policy Engine", not "Understanding the Policy Engine")
- Clear parent-child relationships
- Keyboard navigable (arrow keys, Enter to expand/collapse)
- Selected concept highlighted

**What it answers:**
"What are the main ideas here, and how are they organized?"

**Example Structure:**
```
▼ Agent Infrastructure
  ▼ Core Primitives
    → Policy Engine
    → Memory Management
    → Identity System
  ▼ Products
    → AgentCore
    → Kiro IDE
▼ Evaluation Framework
  → Metrics
  → Benchmarking
```

**Interaction:**
- Click/select concept → show detail in right pane
- Expand/collapse to navigate hierarchy
- Visual indicator of current selection

---

#### Right Pane: Concept Detail

**Purpose:** Explain one concept clearly, thoughtfully, and concisely.

**Structure for Selected Concept:**

1. **Breadcrumb** (subtle, contextual)
   - `Agent Infrastructure > Core Primitives > Policy Engine`

2. **Concept Title** (large, clear)
   - "Policy Engine"

3. **One-Line Summary** (italic, secondary color)
   - "Authorization system that evaluates agent actions against policies"

4. **"What This Is"** (2-3 lines)
   - Clear, direct explanation of the concept

5. **"Why It Matters"** (1-2 lines)
   - Context and significance

6. **Key Points** (3-5 bullets max)
   - Most important details
   - Each bullet is one clear idea

7. **"From the Document"** (collapsed by default)
   - Expandable section
   - 2-3 relevant excerpts with page/timestamp references
   - Provides evidence without overwhelming

**Design Intent:**
- Feels like a briefing, not documentation
- Calm, readable, opinionated
- Each concept stands on its own
- No scrolling required for core content

**Example:**
```
Agent Infrastructure > Core Primitives

Policy Engine

Authorization system that evaluates agent actions against policies

What This Is
The Policy Engine is a centralized authorization service that
evaluates whether proposed agent actions comply with organizational
policies. It uses Cedar policy language to express rules and integrates
with guardrails for safety.

Why It Matters
Critical for enterprise adoption as it provides auditability and
control over agent behavior without requiring code changes.

Key Points
• Uses Cedar policy language (same as AWS IAM)
• Evaluates actions before execution
• Integrates with Bedrock Guardrails
• Supports both allow-list and deny-list patterns
• Sub-100ms evaluation latency

▶ From the Document (3 excerpts)
```

---

## 6. YouTube Link Support

**Intent:** Enable the same understanding workflow for talks, lectures, and technical explainers.

**Behavior:**
1. User pastes YouTube URL on Home screen
2. App attempts to extract captions/transcript
3. Clearly labels transcript source:
   - "Using provided captions" or
   - "Using auto-generated captions"
4. Treats transcript as document input
5. Concept Canvas experience is identical to document analysis

**Product Constraints:**
- If transcript extraction fails → show clear error with explanation
- If transcription is slow → show progress indicator with cancel option
- Include video metadata (title, author, duration) in context

**Technical Notes:**
- Consider using YouTube API or transcript libraries
- Handle rate limits gracefully
- Store transcript locally with analysis

---

## 7. Conceptual Output Contract

**This is the most critical technical specification.**

The AI analysis must produce **structure**, not prose.

### 7.1 Concept Hierarchy

A tree of concepts and sub-concepts.

**Schema:**
```typescript
ConceptNode {
  id: UUID
  title: String          // Short, noun-based
  parent_id: UUID?       // null for top-level
  order: Int             // Display order among siblings
}
```

### 7.2 Concept Detail Payload

For each concept:

**Schema:**
```typescript
ConceptDetail {
  concept_id: UUID
  one_line_summary: String      // Max 120 characters
  what_this_is: String          // 2-3 sentences
  why_it_matters: String        // 1-2 sentences
  key_points: [String]          // 3-5 items, each one clear idea
  source_excerpts: [Excerpt]?   // Optional but preferred
}

Excerpt {
  text: String
  location: String              // "Page 5" or "12:34" for videos
  context: String?              // Optional surrounding context
}
```

### 7.3 Analysis Metadata

```typescript
AnalysisMetadata {
  id: UUID
  document_name: String
  document_type: Enum           // .txt, .md, .docx, .youtube
  analyzed_at: Date
  model_used: String
  word_count: Int?
  duration: Int?                // For videos (seconds)
}
```

**This contract is more important than model choice.**

The system must produce this structure regardless of whether it uses Claude, local LLM, or hybrid approach.

---

## 8. Technical Architecture

### Technology Stack
- **Frontend:** SwiftUI (macOS 14+)
- **Data Storage:** Local SQLite via SwiftData
- **AI Processing:**
  - Primary: Claude API (Sonnet 3.5 or latest)
  - Alternative consideration: Local LLM via Ollama (if latency acceptable)
- **File Processing:** Foundation FileManager + document parsing libraries
- **YouTube:** Transcript extraction library (e.g., youtube-transcript-api equivalent)

### Data Models (SwiftData)

```swift
@Model
class Analysis {
    var id: UUID
    var documentName: String
    var documentType: String
    var analyzedAt: Date
    var modelUsed: String
    var wordCount: Int?
    var duration: Int?

    @Relationship(deleteRule: .cascade)
    var concepts: [Concept]
}

@Model
class Concept {
    var id: UUID
    var title: String
    var parentID: UUID?
    var order: Int
    var oneLineSummary: String
    var whatThisIs: String
    var whyItMatters: String
    var keyPoints: [String]

    @Relationship(deleteRule: .cascade)
    var excerpts: [Excerpt]

    var analysis: Analysis?
}

@Model
class Excerpt {
    var id: UUID
    var text: String
    var location: String
    var context: String?

    var concept: Concept?
}
```

### Processing Pipeline

**Phase 1: Document Ingestion**
1. User provides document or YouTube link
2. Extract text content:
   - `.txt`, `.md`: Direct read
   - `.docx`: Parse with library
   - `.html`: Strip tags, extract content
   - YouTube: Extract transcript
3. Store original content locally

**Phase 2: AI Analysis**
1. Send document to AI with structured prompt
2. AI returns JSON matching output contract (Section 7)
3. Validate structure
4. Store in SwiftData

**Phase 3: Display**
1. Render Concept Map from hierarchy
2. On concept selection, display detail
3. Allow navigation through keyboard/mouse

---

## 9. Delight & Polish Expectations

**Delight is not visual gimmicks.** It comes from:

- ✅ Zero confusion about where you are
- ✅ Fast navigation between ideas (< 100ms transitions)
- ✅ No unnecessary scrolling
- ✅ Smooth, understated transitions (0.3s easing)
- ✅ Keyboard shortcuts (Cmd+F, arrow keys, Enter)
- ✅ Calm color palette (system grays, subtle accents)
- ✅ Generous whitespace
- ✅ SF Pro typography with clear hierarchy

**A user should feel:**

> "This helped me think more clearly."

---

## 10. Phase 1 Success Criteria

### Functional Success
- ✅ Can analyze supported document formats without errors
- ✅ Concept hierarchy is logically structured (user agrees with organization)
- ✅ Concept details are clear and accurate
- ✅ YouTube transcript extraction works reliably
- ✅ Navigation is smooth and intuitive

### User Experience Success
- ✅ User can understand a complex technical document in **< 5 minutes**
- ✅ The structure feels intuitive and accurate
- ✅ Concepts feel well-named and meaningful
- ✅ The UI feels calm, native, and professional
- ✅ **The experience does not resemble a chat app**

### Performance Targets
- ✅ Analysis completes in < 2 minutes for typical document (5000 words)
- ✅ Concept navigation feels instant (< 100ms)
- ✅ App launch to ready state: < 2 seconds

### Learning Goals Success
- ✅ Working macOS app with production-quality UX
- ✅ Deep understanding of SwiftUI and SwiftData
- ✅ Experience with structured AI output (not just chat)
- ✅ Spec-driven development workflow

---

## 11. Design System Guidelines

### Typography
- **Title:** SF Pro Display, 28pt, Semibold
- **Concept Title:** SF Pro, 24pt, Semibold
- **One-line Summary:** SF Pro, 16pt, Regular, Italic, Secondary color
- **Body:** SF Pro, 15pt, Regular
- **Breadcrumb:** SF Pro, 13pt, Regular, Tertiary color
- **Key Points:** SF Pro, 15pt, Regular, with • bullets

### Colors (Semantic)
- **Background:** System background
- **Surface:** Secondary system background
- **Text Primary:** Label color
- **Text Secondary:** Secondary label color
- **Text Tertiary:** Tertiary label color
- **Accent:** System accent color (blue)
- **Selection:** System selection color

### Spacing
- **Base unit:** 8pt
- **Section spacing:** 24pt
- **Paragraph spacing:** 16pt
- **Padding (cards):** 20pt

### Icons
- **Use SF Symbols exclusively**
- **Size:** 16pt for inline, 20pt for prominent actions

---

## 12. Open Questions (Explicitly Allowed)

**The implementation agent is encouraged to ask questions about:**

1. **AI Schema Details:**
   - Exact prompt structure for Claude API
   - Fallback behavior if analysis fails
   - How to handle very large documents (> 50,000 words)

2. **Document Parsing:**
   - Which library for `.docx` parsing?
   - How to handle malformed documents?
   - Should we support PDFs in Phase 1? (Recommend: No)

3. **SwiftUI Layout:**
   - Specific split view ratios (recommend: 30/70)
   - Collapse/expand animation specifics
   - Keyboard shortcut mapping

4. **YouTube Transcript:**
   - Preferred library or API approach
   - How to handle videos without captions
   - Should we cache transcripts? (Recommend: Yes)

5. **Persistence:**
   - Should we keep history of analyses? (Recommend: Phase 2)
   - Where to store documents locally
   - Privacy considerations

6. **Error Handling:**
   - What to show if analysis fails mid-way
   - Network error recovery
   - User-facing error messages

---

## 13. Implementation Approach

### Recommended Phase 1 Development Steps

**Week 1: Foundation**
1. Set up Xcode project with SwiftUI
2. Configure SwiftData models
3. Build Home screen with file picker
4. Test document ingestion (text files only)

**Week 2: AI Integration**
5. Implement Claude API integration
6. Design and test structured prompt
7. Parse and validate JSON response
8. Store results in SwiftData

**Week 3: Concept Canvas**
9. Build Concept Map (left pane) with outline view
10. Build Concept Detail (right pane) with layout
11. Implement selection and navigation
12. Add keyboard shortcuts

**Week 4: Polish & YouTube**
13. Add YouTube transcript extraction
14. Implement smooth transitions
15. Add error handling
16. Test with real documents
17. Visual polish and refinement

---

## 14. Next Step Instructions

**For the implementing agent (Claude Code or developer):**

You are given this spec as the **authoritative product direction**.

**Before implementing:**
- Ask clarifying questions if needed (see Section 12)
- Propose architectural decisions for review
- Flag any ambiguities or missing details

**During implementation:**
- Optimize for **clarity, structure, and native macOS UX** over feature breadth
- Do not introduce chat-first paradigms or unnecessary complexity
- Follow Apple HIG strictly
- Prioritize the conceptual output contract (Section 7) above all else

**Guiding principle:**
> "When in doubt, make it simpler and more focused."

---

## Appendix A: Example Analysis Output

**Document:** "Building Agentic Systems with AWS Bedrock" (hypothetical)

**Concept Hierarchy:**
```
▼ Agentic Systems Overview
  → What Are Agents
  → Key Capabilities
▼ AWS Bedrock Platform
  ▼ Core Services
    → Model Access
    → Knowledge Bases
    → Agents Runtime
  ▼ Agent Primitives
    → Policy Engine
    → Memory Management
    → Tool Integration
▼ Building Your First Agent
  → Setup Requirements
  → Implementation Steps
  → Best Practices
```

**Example Concept Detail (Policy Engine):**

```
AWS Bedrock Platform > Agent Primitives

Policy Engine

Authorization service that evaluates agent actions against Cedar policies

What This Is
The Policy Engine is a managed authorization service that validates
agent actions before execution. It uses the Cedar policy language
(same as AWS IAM) to express complex rules about what agents can
and cannot do.

Why It Matters
Essential for enterprise deployments where agents need guardrails.
Provides audit trails and compliance without hardcoding rules.

Key Points
• Based on Cedar policy language (AWS-native)
• Sub-100ms evaluation latency
• Integrates with Bedrock Guardrails
• Supports both allowlist and denylist patterns
• Policies can reference user context and resource metadata

▶ From the Document (2 excerpts)
  [Collapsed section with excerpts]
```

---

**Document Status:** ✅ Ready for Implementation

**Last Updated:** December 26, 2024

**Contact:** Sarthak (Product Owner)
