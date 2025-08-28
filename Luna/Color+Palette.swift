import SwiftUI

// MARK: - Luna Design System Colors
extension Color {
    // MARK: - Brand Colors
    
    /// Primary Luna brand color - professional medical blue
    /// Light mode: RGB(0, 122, 255) - Apple system blue
    /// Dark mode: RGB(10, 132, 255) - Slightly brighter for dark mode
    static let lunaPrimary = Color(
        light: Color(red: 0/255, green: 122/255, blue: 255/255),
        dark: Color(red: 10/255, green: 132/255, blue: 255/255)
    )
    
    /// Secondary Luna brand color - calming teal
    /// Light mode: RGB(48, 176, 199) - Professional teal
    /// Dark mode: RGB(58, 186, 209) - Brighter teal for dark mode
    static let lunaSecondary = Color(
        light: Color(red: 48/255, green: 176/255, blue: 199/255),
        dark: Color(red: 58/255, green: 186/255, blue: 209/255)
    )
    
    /// Accent color for highlights and CTAs
    /// Light mode: RGB(88, 86, 214) - Professional purple
    /// Dark mode: RGB(98, 96, 224) - Brighter purple for dark mode
    static let lunaAccent = Color(
        light: Color(red: 88/255, green: 86/255, blue: 214/255),
        dark: Color(red: 98/255, green: 96/255, blue: 224/255)
    )
    
    // MARK: - Background Colors
    
    /// Primary background color
    /// Light mode: Pure white for cleanliness
    /// Dark mode: System dark background
    static let lunaBackground = Color(
        light: Color.white,
        dark: Color(red: 0/255, green: 0/255, blue: 0/255)
    )
    
    /// Secondary background for sections and cards
    /// Light mode: Very light gray with warm undertones
    /// Dark mode: Dark gray with subtle warmth
    static let lunaSecondaryBackground = Color(
        light: Color(red: 249/255, green: 249/255, blue: 251/255),
        dark: Color(red: 28/255, green: 28/255, blue: 30/255)
    )
    
    /// Card background with elevated appearance
    /// Light mode: Pure white with subtle shadow
    /// Dark mode: Elevated dark gray
    static let lunaCardBackground = Color(
        light: Color.white,
        dark: Color(red: 44/255, green: 44/255, blue: 46/255)
    )
    
    /// Grouped background for sections
    /// Light mode: System grouped background
    /// Dark mode: System grouped dark background
    static let lunaGroupedBackground = Color(
        light: Color(red: 242/255, green: 242/255, blue: 247/255),
        dark: Color(red: 28/255, green: 28/255, blue: 30/255)
    )
    
    // MARK: - Risk Indicator Colors (WCAG AA Compliant)
    
    /// Safe/Low risk indicator - vibrant green
    /// Optimized for medical applications with high contrast
    static let lunaSafeGreen = Color(
        light: Color(red: 52/255, green: 199/255, blue: 89/255),
        dark: Color(red: 48/255, green: 209/255, blue: 88/255)
    )
    
    /// Warning/Medium risk indicator - professional amber
    /// Balanced visibility without being alarming
    static let lunaWarningOrange = Color(
        light: Color(red: 255/255, green: 149/255, blue: 0/255),
        dark: Color(red: 255/255, green: 159/255, blue: 10/255)
    )
    
    /// Danger/High risk indicator - clear red
    /// High contrast for critical alerts
    static let lunaDangerRed = Color(
        light: Color(red: 255/255, green: 59/255, blue: 48/255),
        dark: Color(red: 255/255, green: 69/255, blue: 58/255)
    )
    
    // MARK: - Text Colors
    
    /// Primary text color
    static let lunaPrimaryText = Color(
        light: Color.black,
        dark: Color.white
    )
    
    /// Secondary text color for supporting information
    static let lunaSecondaryText = Color(
        light: Color(red: 60/255, green: 60/255, blue: 67/255),
        dark: Color(red: 174/255, green: 174/255, blue: 178/255)
    )
    
    /// Tertiary text color for subtle information
    static let lunaTertiaryText = Color(
        light: Color(red: 118/255, green: 118/255, blue: 128/255),
        dark: Color(red: 142/255, green: 142/255, blue: 147/255)
    )
    
    // MARK: - Legacy Color Mappings (for backward compatibility)
    
    /// Maps to lunaSecondaryBackground
    static let darkGrayBG = lunaSecondaryBackground
    
    /// Maps to lunaCardBackground
    static let cardGray = lunaCardBackground
    
    /// Maps to lunaSafeGreen
    static let vibrantGreen = lunaSafeGreen
    
    /// Maps to lunaWarningOrange
    static let vibrantOrange = lunaWarningOrange
    
    /// Maps to lunaDangerRed
    static let vibrantRed = lunaDangerRed
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

// MARK: - Premium Gradient Colors
extension LinearGradient {
    /// Premium brand gradient - primary to secondary
    static var lunaBrandGradient: LinearGradient {
        LinearGradient(
            colors: [Color.lunaPrimary, Color.lunaSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Subtle background gradient for premium feel
    static var lunaBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.lunaBackground,
                Color.lunaSecondaryBackground.opacity(0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// Card elevation gradient with depth
    static var lunaCardGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.lunaCardBackground,
                Color.lunaCardBackground.opacity(0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Color {
    /// Glass morphism background
    static let lunaGlassBackground = Color(
        light: Color.white.opacity(0.7),
        dark: Color.black.opacity(0.3)
    )
    
    /// Floating element background with blur effect
    static let lunaFloatingBackground = Color(
        light: Color.white.opacity(0.85),
        dark: Color.black.opacity(0.6)
    )
}

// MARK: - Premium Shadow Definitions
extension View {
    /// Soft elevation shadow for cards
    func lunaSoftShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
    }
    
    /// Medium elevation shadow for floating elements
    func lunaMediumShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.12),
            radius: 16,
            x: 0,
            y: 8
        )
    }
    
    /// Strong shadow for prominent elements
    func lunaStrongShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.2),
            radius: 24,
            x: 0,
            y: 12
        )
    }
    
    /// Colored shadow for brand elements
    func lunaColoredShadow(_ color: Color, radius: CGFloat = 8, y: CGFloat = 4) -> some View {
        self.shadow(
            color: color.opacity(0.3),
            radius: radius,
            x: 0,
            y: y
        )
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

// MARK: - Premium Card Styles
extension View {
    /// Premium card with glass morphism effect
    func lunaGlassCard(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.lunaGlassBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .lunaSoftShadow()
    }
    
    /// Premium elevated card with gradient background
    func lunaElevatedCard(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient.lunaCardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.lunaSecondaryBackground.opacity(0.3), lineWidth: 1)
                    )
            )
            .lunaMediumShadow()
    }
    
    /// Premium floating card with blur effect
    func lunaFloatingCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.lunaFloatingBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.lunaPrimary.opacity(0.2),
                                        Color.lunaSecondary.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
            )
            .lunaStrongShadow()
    }
}

// MARK: - Premium Button Styles
extension View {
    /// Primary action button with gradient and animations
    func lunaPrimaryButton(disabled: Bool = false) -> some View {
        let buttonGradient = disabled ? 
            LinearGradient(colors: [Color.gray, Color.gray], startPoint: .leading, endPoint: .trailing) :
            LinearGradient.lunaBrandGradient
        
        let shadowColor = disabled ? Color.gray : Color.lunaPrimary
        
        return self
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(buttonGradient)
            )
            .lunaColoredShadow(shadowColor, radius: 12, y: 6)
            .opacity(disabled ? 0.6 : 1.0)
    }
    
    /// Secondary button with subtle styling
    func lunaSecondaryButton() -> some View {
        self
            .foregroundColor(.lunaPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.lunaPrimary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.lunaPrimary.opacity(0.3), lineWidth: 1.5)
                    )
            )
            .lunaSoftShadow()
    }
    
    /// Floating action button
    func lunaFloatingActionButton() -> some View {
        self
            .foregroundColor(.white)
            .frame(width: 56, height: 56)
            .background(
                Circle()
                    .fill(LinearGradient.lunaBrandGradient)
            )
            .lunaColoredShadow(.lunaPrimary, radius: 16, y: 8)
    }
}

// MARK: - Animation Helpers
extension View {
    /// Smooth spring animation for interactions
    func lunaSpringAnimation(duration: Double = 0.3) -> some View {
        let springAnimation = Animation.spring(response: duration, dampingFraction: 0.8, blendDuration: 0)
        return self.animation(springAnimation, value: 1)
    }
    
    /// Gentle fade transition
    func lunaFadeTransition() -> some View {
        let fadeAnimation = Animation.easeInOut(duration: 0.2)
        return self.animation(fadeAnimation, value: 1)
    }
    
    /// Smooth scale effect on tap
    func lunaScaleEffect(_ scale: CGFloat = 0.98) -> some View {
        self.scaleEffect(scale)
    }
}

// MARK: - Premium Text Styles
extension Text {
    /// Hero title with premium styling
    func lunaHeroTitle() -> some View {
        self
            .font(.system(.largeTitle, design: .rounded, weight: .bold))
            .foregroundColor(.lunaPrimaryText)
            .multilineTextAlignment(.center)
    }
    
    /// Section heading with premium styling
    func lunaSectionTitle() -> some View {
        self
            .font(.system(.title2, design: .rounded, weight: .bold))
            .foregroundColor(.lunaPrimaryText)
    }
    
    /// Body text with premium styling
    func lunaBodyText() -> some View {
        self
            .font(.system(.body, design: .rounded))
            .foregroundColor(.lunaSecondaryText)
            .lineSpacing(2)
    }
    
    /// Caption with premium styling
    func lunaCaptionText() -> some View {
        self
            .font(.system(.caption, design: .rounded, weight: .medium))
            .foregroundColor(.lunaSecondaryText)
    }
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
 Premium Usage Examples:
 
 // Premium cards
 VStack { ... }
     .padding()
     .lunaGlassCard()
 
 VStack { ... }
     .padding()
     .lunaElevatedCard()
 
 // Premium buttons
 Button("Action") { ... }
     .lunaPrimaryButton()
 
 Button("Secondary") { ... }
     .lunaSecondaryButton()
 
 // Premium text
 Text("Title")
     .lunaHeroTitle()
 
 Text("Content")
     .lunaBodyText()
 
 // Shadows and effects
 VStack { ... }
     .lunaSoftShadow()
     .lunaSpringAnimation()
 */
