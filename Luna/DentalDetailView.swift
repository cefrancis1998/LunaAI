//
//  DentalDetailView.swift
//  Luna
//
//  Created by Christian Francis on 2025-07-05.
//

import SwiftUI

struct DentalDetailView: View {
    let condition: ConditionResult
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                Image(conditionImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
                    .overlay(
                        // Subtle gradient overlay for better text readability
                        LinearGradient(
                            colors: [Color.black.opacity(0.0), Color.black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        // Condition name overlay at bottom
                        VStack {
                            Spacer()
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(condition.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                                    
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(condition.risk.color)
                                            .frame(width: 8, height: 8)
                                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 0.5)
                                        
                                        Text(condition.risk.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                        }
                    )
                
                VStack(alignment: .leading, spacing: 24) {
                    // Enhanced Title and Status Section
                    VStack(alignment: .leading, spacing: 20) {
                        // Main title
                        Text(condition.name)
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundColor(.lunaPrimaryText)
                        
                        // Risk and confidence row
                        HStack(spacing: 20) {
                            // Risk indicator
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(condition.risk.color)
                                    .frame(width: 14, height: 14)
                                    .shadow(color: condition.risk.color.opacity(0.4), radius: 2, x: 0, y: 1)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Risk Level")
                                        .font(.caption)
                                        .foregroundColor(.lunaSecondaryText)
                                    
                                    Text(condition.risk.rawValue)
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .foregroundColor(condition.risk.color)
                                }
                            }
                            
                            Spacer()
                            
                            // Enhanced confidence display
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Confidence")
                                    .font(.caption)
                                    .foregroundColor(.lunaSecondaryText)
                                
                                Text("\(Int(condition.confidence * 100))%")
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .foregroundColor(.lunaPrimaryText)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.lunaSecondaryBackground)
                                    .shadow(
                                        color: Color.black.opacity(0.04),
                                        radius: 4,
                                        x: 0,
                                        y: 2
                                    )
                            )
                        }
                    }
                    
                    // Enhanced Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About This Condition")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundColor(.lunaPrimaryText)
                        
                        Text(conditionDescription)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.lunaSecondaryText)
                            .lineSpacing(2)
                            .lineLimit(nil)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.lunaCardBackground)
                            .shadow(
                                color: Color.black.opacity(0.04),
                                radius: 6,
                                x: 0,
                                y: 3
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.lunaSecondaryBackground.opacity(0.5), lineWidth: 1)
                    )
                    
                    // Enhanced Severity Alert
                    severityAlert
                    
                    // Enhanced Recommendations
                    recommendationsSection
                    
                    // Enhanced Prevention Tips
                    preventionSection
                }
                .padding(.top, 20)
                .padding(.horizontal)
                .padding(.bottom, 100) // Extra padding for tab bar
            }
        }
        .navigationTitle(condition.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    
    private var conditionImageName: String {
        // Using local assets from Assets.xcassets
        switch condition.name {
        case "Calculus": return "tartar"  // Maps to existing tartar asset
        case "Caries": return "caries"   // Maps to existing caries asset  
        case "Gingivitis": return "gingivitis" // Maps to existing gingivitis asset
        case "Tooth Discoloration": return "discoloration" // Maps to existing discoloration asset
        case "Mouth Ulcer": return "ulcer" // Maps to existing ulcer asset
        case "Hypodontia": return "hypodontia" // Maps to existing hypodontia asset
        default: return "caries" // Fallback to caries image
        }
    }
    
    private var conditionIcon: String {
        switch condition.name {
        case "Calculus": return "drop.fill"
        case "Caries": return "exclamationmark.triangle.fill"
        case "Gingivitis": return "heart.fill"
        case "Tooth Discoloration": return "sparkles"
        case "Mouth Ulcer": return "bandage.fill"
        case "Hypodontia": return "questionmark.circle.fill"
        default: return "teeth.fill"
        }
    }
    
    private var conditionDescription: String {
        switch condition.name {
        case "Calculus":
            return "Calculus, also known as tartar, is hardened plaque that forms on your teeth. It can only be removed by a dental professional during a cleaning."
        case "Caries":
            return "Caries, commonly known as cavities, are permanently damaged areas in the hard surface of your teeth that develop into tiny holes."
        case "Gingivitis":
            return "Gingivitis is a mild form of gum disease that causes irritation, redness, and swelling of your gums around the base of your teeth."
        case "Tooth Discoloration":
            return "Tooth discoloration refers to the staining or darkening of your teeth, which can be caused by foods, drinks, smoking, or aging."
        case "Mouth Ulcer":
            return "Mouth ulcers are small, painful sores that develop in your mouth or at the base of your gums. They're usually harmless but can be uncomfortable."
        case "Hypodontia":
            return "Hypodontia is a condition where one or more teeth fail to develop. It's one of the most common dental developmental abnormalities."
        default:
            return "A dental condition that requires attention and proper care."
        }
    }
    
    private var severityAlert: some View {
        Group {
            switch condition.risk {
            case .high:
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Urgent Attention Required")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    Text("This condition requires immediate professional attention. Please schedule an appointment with your dentist as soon as possible.")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
                
            case .medium:
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.orange)
                        Text("Monitor Closely")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    Text("This condition should be monitored and addressed. Consider scheduling a dental appointment within the next few weeks.")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
                
            case .low:
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Generally Safe")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    Text("This condition is at a manageable level. Continue with good oral hygiene and regular dental check-ups.")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommended Actions")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundColor(.lunaPrimaryText)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.lunaPrimary)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.top, 2)
                        
                        Text(recommendation)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.lunaPrimaryText)
                            .lineSpacing(1)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lunaCardBackground)
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: 6,
                    x: 0,
                    y: 3
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.lunaSecondaryBackground.opacity(0.5), lineWidth: 1)
        )
    }
    
    private var recommendations: [String] {
        switch condition.name {
        case "Calculus":
            return condition.risk == .low ? [
                "Schedule regular dental cleanings every 6 months",
                "Use tartar-control toothpaste",
                "Brush twice daily with fluoride toothpaste",
                "Floss daily to remove plaque between teeth"
            ] : [
                "Schedule immediate dental cleaning",
                "Use antimicrobial mouthwash daily",
                "Consider electric toothbrush for better plaque removal",
                "Increase brushing frequency to after every meal"
            ]
            
        case "Caries":
            return condition.risk == .low ? [
                "Use fluoride toothpaste and mouthwash",
                "Limit sugary and acidic foods",
                "Chew sugar-free gum after meals",
                "Schedule regular dental check-ups"
            ] : [
                "See dentist immediately for treatment",
                "Avoid hot and cold foods that cause pain",
                "Use fluoride supplements if recommended",
                "Consider dental sealants for protection"
            ]
            
        case "Gingivitis":
            return condition.risk == .low ? [
                "Brush gently with soft-bristled toothbrush",
                "Use antibacterial mouthwash",
                "Floss daily to remove plaque",
                "Massage gums gently during brushing"
            ] : [
                "Schedule professional dental cleaning",
                "Use prescribed antibacterial mouthwash",
                "Consider deep cleaning (scaling and root planing)",
                "Quit smoking if applicable"
            ]
            
        case "Tooth Discoloration":
            return condition.risk == .low ? [
                "Use whitening toothpaste (with ADA approval)",
                "Limit coffee, tea, and red wine consumption",
                "Rinse mouth after consuming staining foods",
                "Consider professional whitening consultation"
            ] : [
                "Consult dentist for professional whitening",
                "Avoid over-the-counter whitening products",
                "Rule out underlying dental issues",
                "Consider porcelain veneers for severe cases"
            ]
            
        case "Mouth Ulcer":
            return condition.risk == .low ? [
                "Rinse with warm salt water",
                "Use over-the-counter pain relievers",
                "Apply topical anesthetics (benzocaine gels)",
                "Avoid spicy, acidic, or rough foods"
            ] : [
                "See dentist if ulcers persist over 2 weeks",
                "Use prescription topical corticosteroids",
                "Consider systemic causes (nutritional deficiencies)",
                "Avoid irritating foods completely"
            ]
            
        case "Hypodontia":
            return condition.risk == .low ? [
                "Maintain excellent oral hygiene",
                "Use fluoride treatments to strengthen existing teeth",
                "Consider space maintainers if needed",
                "Regular orthodontic evaluations"
            ] : [
                "Consult orthodontist for treatment planning",
                "Consider dental implants or bridges",
                "Evaluate for prosthetic replacements",
                "Genetic counseling if family history present"
            ]
            
        default:
            return ["Consult with your dentist for personalized advice"]
        }
    }
    
    private var preventionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "shield.fill")
                    .foregroundColor(.lunaSafeGreen)
                    .font(.system(size: 20, weight: .medium))
                
                Text("Prevention Tips")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.lunaPrimaryText)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(preventionTips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(.lunaSafeGreen)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.top, 2)
                        
                        Text(tip)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.lunaPrimaryText)
                            .lineSpacing(1)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.lunaSafeGreen.opacity(0.08),
                            Color.lunaSafeGreen.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: 6,
                    x: 0,
                    y: 3
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.lunaSafeGreen.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var preventionTips: [String] {
        [
            "Brush teeth twice daily with fluoride toothpaste",
            "Floss daily to remove plaque between teeth",
            "Use mouthwash to kill bacteria and freshen breath",
            "Limit sugary and acidic foods and drinks",
            "Don't use tobacco products",
            "Schedule regular dental check-ups and cleanings",
            "Eat a balanced diet rich in calcium and vitamins",
            "Drink plenty of water throughout the day"
        ]
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        DentalDetailView(condition: ConditionResult(
            name: "Tooth Discoloration",
            risk: .medium,
            confidence: 0.85
        ))
    }
}
