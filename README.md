# Luna - AI-Powered Dental Health Analysis

<div align="center">
  <img src="https://via.placeholder.com/150x150/4C9EEB/FFFFFF?text=🦷" alt="Luna Logo" width="150"/>
  
  [![iOS](https://img.shields.io/badge/iOS-15.0+-007AFF?style=flat&logo=iOS&logoColor=white)](https://developer.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?style=flat&logo=swift&logoColor=white)](https://swift.org/)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-007AFF?style=flat&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
  [![Xcode](https://img.shields.io/badge/Xcode-15.0+-007AFF?style=flat&logo=Xcode&logoColor=white)](https://developer.apple.com/xcode/)
</div>

## 🦷 Overview

Luna is an innovative iOS application that leverages artificial intelligence to analyze dental health conditions from photos. Built with SwiftUI and Core ML, the app provides users with instant dental health assessments, educational content, and comprehensive scan history tracking.

### ✨ Key Features

- **🤖 AI-Powered Analysis**: Advanced Core ML model that identifies 6 dental conditions
- **📱 Modern SwiftUI Interface**: Premium glass morphism design with custom floating tab bar
- **📊 Smart Risk Assessment**: Three-tier risk system (Safe, Monitor, See Dentist)
- **📈 Health Journey Tracking**: Comprehensive scan history with timeline visualization
- **🎓 Educational Content**: Expert dental health insights and prevention tips
- **♿ Accessibility First**: WCAG AA compliant with full VoiceOver support
- **🌙 Adaptive Design**: Beautiful light/dark mode with Dynamic Type support
- **☁️ iCloud Sync**: Automatic data synchronization across devices

## 🎯 Dental Conditions Analyzed

Luna's AI model can detect and assess the following conditions:

| Condition | Description | Risk Assessment |
|-----------|-------------|-----------------|
| **Calculus** | Tartar buildup on teeth | Low to Medium |
| **Caries** | Tooth decay and cavities | Medium to High |
| **Gingivitis** | Gum inflammation | Low to High |
| **Tooth Discoloration** | Staining or color changes | Low to Medium |
| **Mouth Ulcer** | Oral sores and lesions | Low to Medium |
| **Hypodontia** | Missing teeth conditions | Low to High |

## 🏗️ Architecture

### Core Components

```
Luna/
├── 🚀 LunaApp.swift           # App entry point with SwiftData container
├── 🎨 ContentView.swift       # Main tab-based navigation
├── 🤖 DentalClassificationService.swift  # ML inference engine
├── 📊 Models.swift            # Data models and sample data
├── 🎨 Color+Palette.swift     # Design system and accessibility
├── 🦷 DentalDetailView.swift  # Condition detail screens
├── 📱 FloatingTabBar.swift    # Custom tab navigation
├── 🔐 LoginView.swift         # Authentication interface
└── 📋 ScanHistoryDetailView.swift  # Detailed scan results
```

### Technology Stack

- **🎨 SwiftUI**: Modern declarative UI framework
- **🤖 Core ML + Vision**: On-device machine learning
- **💾 SwiftData**: Local data persistence with iCloud sync
- **📷 UIKit Integration**: Camera and photo library access
- **♿ Accessibility**: VoiceOver, Dynamic Type, contrast compliance

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+**
- **iOS 15.0+**
- **macOS 13.0+** (for development)
- **Apple Developer Account** (for device testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Luna.git
   cd Luna
   ```

2. **Open in Xcode**
   ```bash
   open Luna.xcodeproj
   ```

3. **Configure signing**
   - Select your development team in project settings
   - Ensure proper bundle identifier is set

4. **Build and run**
   - **Build**: `⌘ + B`
   - **Run**: `⌘ + R`
   - **Test**: `⌘ + U`

### Command Line Build

```bash
# Build for iOS Simulator
xcodebuild -project Luna.xcodeproj -scheme Luna -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests
xcodebuild test -project Luna.xcodeproj -scheme Luna -destination 'platform=iOS Simulator,name=iPhone 15'

# Clean build folder
xcodebuild clean -project Luna.xcodeproj -scheme Luna
```

## 📱 App Flow

### Main Navigation
```
📱 Luna App
├── 🔍 Scan Tab
│   ├── Camera capture
│   ├── Photo library selection
│   ├── AI analysis
│   └── Results display
├── 📊 History Tab
│   ├── Timeline view
│   ├── Health statistics
│   ├── Filtering options
│   └── Detailed scan results
└── 🎓 Learn Tab
    ├── Educational topics
    ├── Prevention tips
    └── Dental health insights
```

### Scanning Workflow
1. **Input Selection**: Camera or photo library
2. **Image Processing**: Vision framework preprocessing
3. **ML Inference**: Core ML model prediction
4. **Risk Assessment**: Algorithm-based risk calculation
5. **Data Storage**: SwiftData persistence
6. **Results Display**: Interactive condition cards

## 🎨 Design System

### Color Palette
- **Primary**: Medical blue tones
- **Risk Colors**: Green (Safe), Orange (Monitor), Red (See Dentist)
- **Backgrounds**: Adaptive gradients with glass morphism
- **Accessibility**: WCAG AA compliant (4.5:1+ contrast ratios)

### Typography
- **Headlines**: SF Rounded, dynamic sizing
- **Body**: System font with accessibility support
- **Captions**: Medium weight, secondary colors

### Components
- **Floating Cards**: Glass morphism with shadows
- **Premium Buttons**: Gradient backgrounds with haptics
- **Timeline**: Custom visual history representation
- **Tab Bar**: Floating design with smooth animations

## 🧪 Testing

### Unit Tests
```bash
# Run all tests
xcodebuild test -project Luna.xcodeproj -scheme Luna

# Test coverage
xcodebuild test -project Luna.xcodeproj -scheme Luna -enableCodeCoverage YES
```

### UI Tests
- **Camera functionality**: Device testing required
- **ML model accuracy**: Batch image testing
- **Navigation flows**: Automated UI testing
- **Accessibility**: VoiceOver compatibility

### Manual Testing Checklist

#### 🎯 Core Functionality
- [ ] Camera capture works on physical device
- [ ] Photo library selection functions correctly  
- [ ] ML model produces consistent results
- [ ] Risk assessment logic is accurate
- [ ] Data persistence works reliably

#### ♿ Accessibility Testing
- [ ] VoiceOver navigation is smooth
- [ ] Dynamic Type scales properly (Small to XXXL)
- [ ] Contrast ratios meet WCAG AA standards
- [ ] Color-blind friendly risk indicators

#### 🎨 Visual Testing
- [ ] Light/dark mode transitions
- [ ] Glass morphism effects render correctly
- [ ] Animations are smooth and purposeful
- [ ] Layout adapts to different screen sizes

## 📊 Data Models

### ScanResult
```swift
@Model
final class ScanResult {
    var timestamp: Date
    var conditions: [ConditionResult]
    var imageData: Data?
}
```

### ConditionResult
```swift
struct ConditionResult {
    let name: String
    let risk: RiskLevel
    let confidence: Double
}
```

### Risk Assessment
- **Low (Safe)**: Green indicator, minimal concern
- **Medium (Monitor)**: Orange indicator, watch carefully
- **High (See Dentist)**: Red indicator, professional consultation recommended

## 🔒 Privacy & Security

- **On-Device Processing**: All ML inference happens locally
- **Data Encryption**: SwiftData with CloudKit encryption
- **No External APIs**: Zero third-party data sharing
- **User Control**: Complete data ownership and deletion
- **HIPAA Awareness**: Designed with health data privacy in mind

## 🚧 Development Notes

### Performance Considerations
- **ML Model Size**: Optimized for on-device inference
- **Image Processing**: Efficient Vision framework usage
- **Memory Management**: Proper image data handling
- **Battery Usage**: Minimized background processing

### Known Limitations
- **Camera Required**: Physical device needed for full testing
- **Model Accuracy**: Continuous improvement based on feedback
- **iOS Version**: Requires iOS 15.0+ for SwiftData support

## 🤝 Contributing

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Maintain accessibility standards
- Document public APIs

### Pull Request Process
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, issues, or feature requests:

- **Issues**: [GitHub Issues](https://github.com/yourusername/Luna/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/Luna/discussions)
- **Email**: support@lunadentalapp.com

## 🏆 Acknowledgments

- **Core ML Team**: For excellent on-device ML frameworks
- **SwiftUI Team**: For modern iOS development tools
- **Dental Professionals**: For domain expertise and validation
- **Accessibility Community**: For inclusive design guidance

---

<div align="center">
  <b>Made with ❤️ and SwiftUI</b><br>
  <i>Empowering dental health through AI</i>
</div>
