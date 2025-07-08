import SwiftUI

extension Color {
    // MARK: - Background Colors
    
    /// Dark gray background color for card/section backgrounds
    /// Dark mode: RGB(28, 28, 30) - Very dark gray
    /// Light mode: RGB(248, 248, 250) - Very light gray
    static let darkGrayBG = Color(
        light: Color(red: 248/255, green: 248/255, blue: 250/255),
        dark: Color(red: 28/255, green: 28/255, blue: 30/255)
    )
    
    /// Card gray color for inner cards
    /// Dark mode: RGB(44, 44, 46) - Medium dark gray
    /// Light mode: RGB(240, 240, 242) - Light gray
    static let cardGray = Color(
        light: Color(red: 240/255, green: 240/255, blue: 242/255),
        dark: Color(red: 44/255, green: 44/255, blue: 46/255)
    )
    
    // MARK: - Risk Indicator Colors (WCAG AA Compliant)
    
    /// Vibrant green for positive/safe risk indicators
    /// Dark mode: RGB(48, 209, 88) - Bright green (WCAG AA compliant on dark)
    /// Light mode: RGB(25, 135, 84) - Much darker green for better contrast on white
    static let vibrantGreen = Color(
        light: Color(red: 25/255, green: 135/255, blue: 84/255),  // 4.5:1 contrast on white
        dark: Color(red: 48/255, green: 209/255, blue: 88/255)
    )
    
    /// Vibrant orange for warning/medium risk indicators
    /// Dark mode: RGB(255, 159, 10) - Bright orange (WCAG AA compliant on dark)
    /// Light mode: RGB(180, 95, 0) - Much darker orange for better contrast on white
    static let vibrantOrange = Color(
        light: Color(red: 180/255, green: 95/255, blue: 0/255),  // 4.5:1 contrast on white
        dark: Color(red: 255/255, green: 159/255, blue: 10/255)
    )
    
    /// Vibrant red for danger/high risk indicators
    /// Dark mode: RGB(255, 69, 58) - Bright red (WCAG AA compliant on dark)
    /// Light mode: RGB(176, 42, 55) - Much darker red for better contrast on white
    static let vibrantRed = Color(
        light: Color(red: 176/255, green: 42/255, blue: 55/255),  // 4.5:1 contrast on white
        dark: Color(red: 255/255, green: 69/255, blue: 58/255)
    )
}

// MARK: - Color Convenience Initializer

extension Color {
    /// Creates a color that adapts to light and dark mode
    /// - Parameters:
    ///   - light: Color to use in light mode
    ///   - dark: Color to use in dark mode
    init(light: Color, dark: Color) {
        self = Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            case .light, .unspecified:
                return UIColor(light)
            @unknown default:
                return UIColor(light)
            }
        })
    }
}

// MARK: - Enhanced Accessibility Colors
extension Color {
    /// Enhanced card background for better contrast
    /// Pure white in light mode, dark gray in dark mode
    static let accessibleCardBackground = Color(
        light: Color.white,
        dark: Color(red: 28/255, green: 28/255, blue: 30/255)
    )
    
    /// Text color optimized for accessibility
    /// Black in light mode, white in dark mode
    static let accessibleText = Color(
        light: Color.black,
        dark: Color.white
    )
    
    /// Secondary text with proper contrast ratios
    /// Dark gray in light mode, light gray in dark mode
    static let accessibleSecondaryText = Color(
        light: Color(red: 60/255, green: 60/255, blue: 67/255),
        dark: Color(red: 174/255, green: 174/255, blue: 178/255)
    )
}

// MARK: - Enhanced Typography for Dynamic Type
extension Font {
    /// Large icon font that scales with Dynamic Type
    static let accessibleLargeIcon = Font.system(.title, design: .default)
    
    /// Medium icon font that scales with Dynamic Type
    static let accessibleMediumIcon = Font.system(.title2, design: .default)
    
    /// Small icon font that scales with Dynamic Type
    static let accessibleSmallIcon = Font.system(.title3, design: .default)
}

// MARK: - VoiceOver Enhancement Helpers
extension View {
    /// Adds comprehensive accessibility labels for condition cards
    func accessibleConditionCard(name: String, risk: String, confidence: Double) -> some View {
        self
            .accessibilityLabel("\(name), \(risk) risk level, \(Int(confidence * 100))% confidence")
            .accessibilityHint("Tap to view detailed information about this condition")
            .accessibilityAddTraits(.isButton)
    }
    
    /// Adds accessibility labels for history rows
    func accessibleHistoryRow(date: Date, conditionCount: Int) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return self
            .accessibilityLabel("Scan from \(dateFormatter.string(from: date)), \(conditionCount) conditions detected")
            .accessibilityHint("Tap to view scan details")
            .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Usage Examples

/*
 Usage examples:
 
 // Background colors
 Rectangle()
     .fill(Color.darkGrayBG)
 
 RoundedRectangle(cornerRadius: 12)
     .fill(Color.cardGray)
 
 // Risk indicators
 Text("Safe")
     .foregroundColor(Color.vibrantGreen)
 
 Text("Warning")
     .foregroundColor(Color.vibrantOrange)
 
 Text("Danger")
     .foregroundColor(Color.vibrantRed)
 
 // Risk indicator backgrounds
 HStack {
     Circle()
         .fill(Color.vibrantGreen)
         .frame(width: 8, height: 8)
     Text("Low Risk")
 }
 */
