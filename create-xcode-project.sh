#!/bin/bash

# Create Xcode project for Insight Canvas
# macOS app with SwiftUI and SwiftData

PROJECT_DIR="/Users/sarthakhanda/Documents/Cursor-Exp/insight-canvas"
PROJECT_NAME="InsightCanvas"

cd "$PROJECT_DIR"

# Create the Xcode project directory structure
mkdir -p "$PROJECT_NAME/$PROJECT_NAME"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Models"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Views/Home"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Views/ConceptCanvas"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Views/Components"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Services"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Assets.xcassets"
mkdir -p "$PROJECT_NAME/$PROJECT_NAME/Preview Content"

echo "✅ Created project directory structure"

# We'll create the files manually since xcodebuild create doesn't exist
# The user will need to create a new Xcode project manually or we can create files directly

echo "📁 Project structure created at: $PROJECT_DIR/$PROJECT_NAME"
echo ""
echo "Next steps:"
echo "1. Open Xcode"
echo "2. Create New Project -> macOS -> App"
echo "3. Product Name: InsightCanvas"
echo "4. Interface: SwiftUI"
echo "5. Include SwiftData"
echo "6. Save to: $PROJECT_DIR"
echo ""
echo "Or we can create the files directly without using Xcode GUI."
