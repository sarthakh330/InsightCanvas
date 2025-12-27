# Insight Canvas – Design System

**Version:** 1.0
**Date:** December 26, 2024
**Status:** Extracted from HTML mockups, ready for SwiftUI translation

---

## Color Palette

### Typography Colors
```swift
// SwiftUI Semantic Colors
.primary        // txt-primary: #111317 (Dark charcoal)
.secondary      // txt-secondary: #5C6168 (Medium gray)
.tertiary       // txt-tertiary: #8f897e (Warm gray)
```

### Backgrounds
```swift
// Custom colors to define in Assets.xcassets
"bg-canvas"     // #fdfcf9 - Main reading surface (warm white/beige)
"bg-sidebar"    // #f2f0e9 - Sidebar (darker beige)
"bg-surface"    // #FFFFFF - Cards/elevated elements
"border-beige"  // #e2dfd6 - Subtle borders
```

### Accents
```swift
"accent"             // #2F8F6B - Primary green
"accent-highlight"   // #E4F2EC - Light green background (selected states)
"divider"            // #DADDE1 - Standard dividers
```

### Usage Guidelines
- **Never use pure black** (`#000000`) for text
- **Primary text** should be `#111317` (charcoal)
- **Background** should always be warm tones, never pure white in main canvas
- **Accent color** used sparingly: selection states, links, active elements
- **Green highlight** (`#E4F2EC`) for selected concept in sidebar

---

## Typography Scale

### Font Family
**SF Pro** (system font) for all text.
**SF Pro Display** for large titles.

### Type Scale
```swift
// SwiftUI Font Modifiers
.largeTitle      // 34pt, Bold     - Not used in Phase 1
.title           // 28pt, Semibold - Document title (unused in mockup)
.title2          // 24pt, Semibold - Concept title (main pane)
.title3          // 20pt, Semibold - Section headers
.headline        // 17pt, Semibold - Emphasized content
.body            // 15pt, Regular  - Main reading text
.callout         // 14pt, Regular  - Secondary content
.subheadline     // 13pt, Regular  - Breadcrumbs, metadata
.footnote        // 12pt, Regular  - Footer, labels
.caption         // 11pt, Regular  - Tiny labels (Graph v2.4)
.caption2        // 10pt, Medium   - Badges, tags (e.g., "2 excerpts")
```

### Specific Mappings from Mockup
| Element | Size | Weight | Color | SwiftUI |
|---------|------|--------|-------|---------|
| Concept Title | 24pt | Semibold | txt-primary | `.title2` |
| One-line Summary | 16pt | Regular, Italic | txt-secondary | `.body.italic` |
| Body Text | 15pt | Regular | txt-primary | `.body` |
| Section Headers (WHAT THIS IS) | 10-11pt | Bold, Uppercase | txt-secondary | `.caption.uppercased().bold()` |
| Breadcrumbs | 12pt | Regular | txt-secondary | `.footnote` |
| Sidebar Concepts | 14pt | Regular/Medium | txt-secondary | `.callout` |
| Search Placeholder | 14pt | Regular | txt-secondary | `.callout` |

### Line Height
- **Body text:** 1.4-1.5x (22-24pt for 15pt font)
- **Headings:** 1.2x
- **Compact UI (sidebar):** 1.3x

---

## Spacing System

### Base Unit: 8pt
All spacing should be multiples of 4pt or 8pt.

```swift
// SwiftUI Spacing
.padding(.horizontal, 4)   // 4pt  - Minimal
.padding(.horizontal, 8)   // 8pt  - Tight
.padding(.horizontal, 12)  // 12pt - Default inline
.padding(.horizontal, 16)  // 16pt - Standard
.padding(.horizontal, 20)  // 20pt - Card padding
.padding(.horizontal, 24)  // 24pt - Section spacing
.padding(.horizontal, 32)  // 32pt - Large gaps
```

### Specific Spacing from Mockup

#### Sidebar
- **Top padding:** 16pt
- **Search field:** 12pt horizontal padding inside input
- **Concept items:** 6pt vertical padding, 8pt horizontal
- **Nested indent:** 16pt per level (with border-left)

#### Main Content
- **Container max-width:** 720pt
- **Horizontal padding:** 48-64pt on desktop, 32pt on mobile
- **Top padding:** 40pt
- **Bottom padding:** 80pt (allows scroll past last element)
- **Section gaps:** 32-40pt between major sections
- **Paragraph spacing:** 16pt

#### Mental Model Card
- **Padding:** 20pt all sides
- **Icon margin:** 16pt from text
- **Border radius:** 8pt

---

## Layout Structure

### Two-Pane Split View

```
┌──────────────────────────────────────────────────┐
│  [Sidebar: 280-320pt]  │  [Main: Flexible]      │
│                        │                         │
│  Concept Map           │  Concept Detail         │
│  (Collapsible tree)    │  (Reading pane)         │
│                        │                         │
└──────────────────────────────────────────────────┘
```

**Sidebar Width:**
- Desktop: 320pt
- Tablet: 280pt
- Mobile: Full screen (toggle)

**Main Pane:**
- Max-width: 720pt (centered)
- Padding: 48-64pt horizontal on desktop

---

## Component Specifications

### 1. Concept Map (Sidebar)

**Structure:**
```
┌─────────────────────────┐
│ [Search: ⌘K]            │ ← Sticky header
├─────────────────────────┤
│ ▶ System Architecture   │ ← Collapsed section
│ ▼ Agent Core            │ ← Expanded section
│   ├─ Orchestration      │ ← Child concept
│   ├─ Memory Systems ✓   │ ← Selected (highlighted)
│   │   ├─ Vector Store   │ ← Nested child
│   │   ├─ Short-term...  │
│   └─ Tool Use           │
│ ▶ Evaluation Metrics    │
├─────────────────────────┤
│ Graph v2.4    ● Online  │ ← Footer
└─────────────────────────┘
```

**Visual States:**
- **Default:** Gray text (`txt-secondary`), no background
- **Hover:** Subtle background (`black/5`), darker text
- **Selected:** Green background (`accent-highlight`), bold text, accent color, shadow
- **Expanded:** Rotate arrow 90°, show children with left border

**Hierarchy Indicators:**
- **Arrow icon:** SF Symbol `chevron.right` (rotates 90° when expanded)
- **Indent:** 16pt per level
- **Border-left:** 1pt solid `border-beige` for child groups

### 2. Search Field (Sidebar Header)

```
┌──────────────────────────────┐
│ 🔍  Search concepts      ⌘K  │
└──────────────────────────────┘
```

**Specifications:**
- **Height:** 36pt
- **Padding:** 10pt vertical, 36pt left (icon), 40pt right (kbd)
- **Border:** 1pt solid `border-beige`
- **Focus state:** Ring 2pt `accent`, border color changes to accent
- **Icon:** SF Symbol `magnifyingglass` (18pt)
- **Keyboard hint:** Only show on desktop (hidden on mobile)

### 3. Breadcrumb Navigation

```
Agent Core  ›  Memory Systems
```

**Specifications:**
- **Font:** `.footnote` (12pt)
- **Color:** `txt-secondary` (inactive), `txt-primary` (current)
- **Separator:** SF Symbol `chevron.right` (12pt, `divider` color)
- **Hover:** Links become `accent` color
- **Margin bottom:** 32pt

### 4. Concept Title

```
Memory Systems
─────────────────────────────────────
The architectural component responsible for...
```

**Specifications:**
- **Title font:** `.title2` (24pt, Semibold)
- **Title color:** `txt-primary`
- **Margin bottom:** 12pt
- **One-line summary font:** `.body` (15pt, Regular, Italic)
- **One-line summary color:** `txt-secondary`
- **One-line summary margin bottom:** 40pt

### 5. Mental Model Card

```
┌──────────────────────────────────────────┐
│ 🧠  MENTAL MODEL                         │
│                                          │
│  Think of the Memory System as a        │
│  librarian with a short-term notepad...  │
└──────────────────────────────────────────┘
```

**Specifications:**
- **Background:** `accent-highlight/30` (30% opacity green)
- **Border:** 1pt solid `accent/20` (20% opacity green)
- **Border radius:** 8pt
- **Padding:** 20pt
- **Icon:** SF Symbol `brain` or `lightbulb` (20pt, `accent` color)
- **Gap between icon and text:** 16pt
- **Label font:** `.caption2` (10pt, Bold, Uppercase, `accent` color)
- **Content font:** `.callout` (14pt, Medium)
- **Shadow:** Subtle `0 1px 2px rgba(47,143,107,0.05)`

### 6. Section Headers

```
WHAT THIS IS
────────────────────────────────
```

**Specifications:**
- **Font:** `.caption` (11pt, Bold, Uppercase)
- **Color:** `txt-secondary`
- **Border-bottom:** 1pt solid `divider`
- **Padding bottom:** 4pt
- **Margin bottom:** 12pt
- **Letter spacing:** 0.5pt (tracking)

### 7. Key Points / Bullet List

```
• Latency vs. Recall
  Full semantic search adds ~200ms overhead...
```

**Specifications:**
- **Bullet:** Custom (circle, 6pt diameter, `txt-tertiary`)
  - Hover: Changes to `accent`
- **Gap between bullet and text:** 12pt
- **Vertical spacing:** 16pt between items
- **Title font:** `.callout` (14pt, Semibold)
- **Body font:** `.callout` (14pt, Regular)
- **Title color:** `txt-primary`
- **Body color:** `txt-secondary`

### 8. Related Concepts (Tag Pills)

```
Related concepts:  [Vector Database]  [Embeddings]
```

**Specifications:**
- **Pill background:** `bg-surface`
- **Pill border:** 1pt solid `border-beige`
- **Pill padding:** 4pt vertical, 8pt horizontal
- **Pill font:** `.callout` (14pt, Regular)
- **Pill color:** `accent`
- **Pill border-radius:** 6pt
- **Hover state:** Border becomes `accent`, subtle shadow
- **Gap between pills:** 8pt

### 9. "From the Document" Collapsible

```
┌──────────────────────────────────────────┐
│ ›  Grounded in the source      2 excerpts│ ← Collapsed
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ ∨  Grounded in the source      2 excerpts│ ← Expanded
├──────────────────────────────────────────┤
│ │ "We observe that pure recurrent..."    │
│ │ Section 4.2: Results  [View Page ↗]   │
└──────────────────────────────────────────┘
```

**Specifications:**
- **Container background:** `bg-surface`
- **Container border:** 1pt solid `border-beige`
- **Container border-radius:** 8pt
- **Header padding:** 12pt vertical, 16pt horizontal
- **Header font:** `.callout` (14pt, Semibold)
- **Header color:** `txt-secondary`
- **Hover state:** Background becomes `gray-50`
- **Chevron:** SF Symbol `chevron.right` (rotates 90° when expanded)
- **Badge font:** `.caption2` (10pt, Medium, Uppercase)
- **Badge background:** `bg-canvas`
- **Badge border:** 1pt solid `border-beige`
- **Badge padding:** 2pt vertical, 8pt horizontal
- **Excerpt container:** Padding 20pt, background `bg-canvas/50`
- **Excerpt border-left:** 2pt solid `accent/40`
- **Excerpt font:** `.callout` (14pt, Regular, Italic, Serif)
- **Excerpt color:** `txt-secondary`
- **Location label font:** `.caption` (11pt, Medium, Uppercase)
- **Location color:** `txt-tertiary`

---

## SF Symbols Reference

| Element | Symbol Name | Size | Color |
|---------|-------------|------|-------|
| Search icon | `magnifyingglass` | 18pt | `txt-secondary` |
| Chevron (collapsed) | `chevron.right` | 18pt | `txt-tertiary` |
| Chevron (expanded) | `chevron.right` (rotated 90°) | 18pt | `txt-secondary` |
| Breadcrumb separator | `chevron.right` | 12pt | `divider` |
| Mental Model icon | `brain` or `lightbulb` | 20pt | `accent` |
| External link | `arrow.up.right.square` | 12pt | `accent` |
| Lock (footer) | `lock.fill` | 16pt | `txt-secondary` |
| Document upload | `doc.badge.arrow.up` | 36pt | `txt-secondary` |
| Link icon (YouTube) | `link` | 20pt | `txt-secondary` |

---

## Animation & Transitions

### Timing
- **Default transition:** 0.3s ease-in-out
- **Quick transitions (hover):** 0.2s ease-out
- **Slow transitions (expand/collapse):** 0.4s ease-in-out

### Specific Animations

**Sidebar Concept Selection:**
```swift
.animation(.easeOut(duration: 0.2), value: selectedConcept)
```

**Expand/Collapse:**
```swift
.rotationEffect(.degrees(isExpanded ? 90 : 0))
.animation(.easeInOut(duration: 0.3), value: isExpanded)
```

**Hover States:**
```swift
.scaleEffect(isHovered ? 1.005 : 1.0)
.animation(.easeOut(duration: 0.2), value: isHovered)
```

---

## Accessibility

### Focus Indicators
- **Focus ring:** 2pt solid `accent`
- **Focus ring offset:** 2pt
- **Focus ring border-radius:** 4pt

### Keyboard Navigation
- **Tab:** Navigate between interactive elements
- **Arrow keys:** Navigate concept tree (up/down)
- **Enter/Space:** Expand/collapse or select
- **Cmd+K:** Focus search field
- **Esc:** Clear search or deselect

### VoiceOver
- All interactive elements must have accessibility labels
- Concept hierarchy should announce level depth
- Selected state should be announced
- Expandable elements should indicate "collapsed" or "expanded"

---

## Responsive Breakpoints

### Desktop (≥1024pt)
- Sidebar: 320pt fixed
- Main pane: Max 720pt centered with 64pt horizontal padding
- Show keyboard shortcuts (⌘K)

### Tablet (768-1023pt)
- Sidebar: 280pt fixed
- Main pane: Max 640pt with 48pt horizontal padding
- Show keyboard shortcuts (⌘K)

### Mobile (<768pt)
- Sidebar: Full screen overlay (toggle button)
- Main pane: Full width with 32pt horizontal padding
- Hide keyboard shortcuts
- Larger touch targets (44pt minimum)

---

## Implementation Notes for SwiftUI

### Custom Colors
Define in `Assets.xcassets` → Colors:
- `BG-Canvas` → `#fdfcf9`
- `BG-Sidebar` → `#f2f0e9`
- `BG-Surface` → `#FFFFFF`
- `BorderBeige` → `#e2dfd6`
- `Accent` → `#2F8F6B`
- `AccentHighlight` → `#E4F2EC`

### Usage Example
```swift
Color("BG-Canvas")           // Custom color
Color.primary                // System label color (txt-primary)
Color.secondary              // System secondary label
```

### Typography Example
```swift
Text("Memory Systems")
    .font(.title2)
    .fontWeight(.semibold)
    .foregroundColor(.primary)
```

### Spacing Example
```swift
VStack(spacing: 32) {
    // Sections
}
.padding(.horizontal, 64)
.padding(.top, 40)
.padding(.bottom, 80)
```

---

## Design Principles (Reminders)

1. **Calm Over Flashy**
   - Subtle transitions, not jarring animations
   - Muted colors, not bright neons

2. **Information Hierarchy**
   - Use size, weight, and color to guide attention
   - Most important: Concept title
   - Secondary: One-line summary, section headers
   - Tertiary: Metadata, breadcrumbs

3. **Whitespace is Content**
   - Generous margins prevent claustrophobia
   - Section spacing helps chunking

4. **Consistency**
   - Same padding for similar elements
   - Same colors for same states
   - Same typography scale throughout

5. **Progressive Disclosure**
   - Collapsed by default (excerpts, nested concepts)
   - Expand only what's needed
   - Breadcrumbs provide context without clutter

---

**Status:** ✅ Ready for SwiftUI Implementation
**Last Updated:** December 26, 2024
