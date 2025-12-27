# Insight Canvas - Setup Instructions

## ✅ What's Already Done

All Swift source files and assets have been created:

### Source Files
- ✅ `InsightCanvasApp.swift` - Main app entry point with SwiftData container
- ✅ `Models/Analysis.swift` - Document analysis model
- ✅ `Models/Concept.swift` - Concept hierarchy model
- ✅ `Models/Excerpt.swift` - Source excerpt model
- ✅ `Views/Home/HomeView.swift` - Landing page with drag & drop
- ✅ `Services/Config.swift` - API configuration

### Assets
- ✅ Custom colors (BG-Canvas, BG-Sidebar, Accent, etc.)
- ✅ Color palette matching design system
- ✅ `.env` file with Anthropic API key

---

## 🚀 Next Step: Create Xcode Project

### Option 1: Create Project in Xcode (Recommended)

1. **Open Xcode** (should already be open)

2. **Create New Project:**
   - File → New → Project
   - Choose **macOS** → **App**
   - Click **Next**

3. **Project Settings:**
   - **Product Name:** `InsightCanvas`
   - **Team:** (Your Apple ID)
   - **Organization Identifier:** `com.sarthak`
   - **Interface:** **SwiftUI**
   - **Language:** **Swift**
   - **Storage:** **SwiftData** ✓ (IMPORTANT: Check this box!)
   - **Include Tests:** ✓

4. **Save Location:**
   - Navigate to: `/Users/sarthakhanda/Documents/Cursor-Exp/insight-canvas/`
   - **IMPORTANT:** When saving, make sure to:
     - Delete the auto-generated `InsightCanvas` folder that Xcode will create
     - Or save it elsewhere and we'll merge

5. **Replace/Import Files:**
   After project is created, we'll replace the auto-generated files with our comprehensive ones.

### Option 2: Use Provided Script

I can create a script that generates the project.pbxproj file directly.

---

## 📋 After Project Creation

Once the Xcode project is created, run:

```bash
cd /Users/sarthakhanda/Documents/Cursor-Exp/insight-canvas
open InsightCanvas.xcodeproj
```

Then:
1. Replace the default Swift files with our prepared ones
2. Add the Assets.xcassets colors
3. Build and run (⌘+R)

---

## ⚠️ Important Notes

- The API key is already configured in `Services/Config.swift`
- All colors match the design system specifications
- SwiftData models are ready to use
- Home screen UI matches the mockup

---

**Ready to proceed with Option 1?** Let me know and I'll help with the next steps!
