# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Luna is an iOS/macOS dental health application that uses Core ML to analyze dental conditions from photos. It's built with SwiftUI and SwiftData, targeting both iOS and macOS platforms.

## Build and Development Commands

This is an Xcode project (`.xcodeproj`). Common commands:

```bash
# Build the project
xcodebuild -project Luna.xcodeproj -scheme Luna -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests
xcodebuild test -project Luna.xcodeproj -scheme Luna -destination 'platform=iOS Simulator,name=iPhone 15'

# Clean build folder
xcodebuild clean -project Luna.xcodeproj -scheme Luna
```

For development, use Xcode IDE:
- Build: Cmd+B
- Run: Cmd+R
- Test: Cmd+U

## Architecture and Key Components

### Core Structure
- **App Entry**: `LunaApp.swift` - SwiftUI App with SwiftData container setup
- **Main Navigation**: `ContentView.swift` - Tab-based UI (Scan, History, Learn)
- **ML Service**: `DentalClassificationService.swift` - Handles Core ML predictions
- **Data Models**: `Models.swift` - ScanResult, ConditionResult, EducationTopic

### ML Integration
- **Model**: `DentalClassifier.mlmodel` - Classifies 6 dental conditions
- **Vision Framework**: Used for image preprocessing
- **Risk Levels**: Safe (green), Monitor (yellow), See Dentist (red)

### Data Persistence
- Uses SwiftData for storing scan history
- `@Model` macro on ScanResult class
- Automatic CloudKit sync support

### Design System
- **Colors**: `Color+Palette.swift` - Medical-themed palette with semantic naming
- **Accessibility**: Full VoiceOver support, WCAG AA compliant
- **Adaptive**: Light/dark mode support

## Key Features to Understand

1. **Dental Scanning Flow**:
   - Camera/photo selection → ML classification → Risk assessment → Save to history
   - Handles 6 conditions: Calculus, Caries, Gingivitis, Tooth Discoloration, Mouth Ulcer, Hypodontia

2. **Authentication**: 
   - New `LoginView.swift` (uncommitted) being added
   - Will likely integrate with existing navigation

3. **Educational Content**:
   - Static content in Learn tab
   - Expandable disclosure groups for each topic

## Development Notes

- Always test camera functionality on physical devices
- Ensure Info.plist has proper camera usage descriptions
- ML model expects 299x299 pixel images (handled by Vision framework)
- SwiftData models use `@Model` macro - changes require migration consideration
- Follow existing SwiftUI patterns - avoid UIKit unless necessary