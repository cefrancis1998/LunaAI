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
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                AsyncImage(url: URL(string: conditionImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .overlay(
                            VStack {
                                Image(systemName: conditionIcon)
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                Text(condition.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                            }
                        )
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Condition Title and Status
                    HStack {
                        VStack(alignment: .leading) {
                            Text(condition.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            HStack {
                                Circle()
                                    .fill(condition.risk.color)
                                    .frame(width: 12, height: 12)
                                
                                Text(condition.risk.rawValue)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(condition.risk.color)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Confidence")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(condition.confidence * 100))%")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Condition Description
                    Text(conditionDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                    
                    // Severity Alert
                    severityAlert
                    
                    // Recommendations
                    recommendationsSection
                    
                    // Prevention Tips
                    preventionSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Extra padding for tab bar
            }
        }
        .navigationTitle(condition.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    
    private var conditionImageURL: String {
        // In a real app, these would be actual URLs or local images
        switch condition.name {
        case "Calculus": return "https://example.com/calculus.jpg"
        case "Caries": return "https://example.com/caries.jpg"
        case "Gingivitis": return "https://example.com/gingivitis.jpg"
        case "Tooth Discoloration": return "https://example.com/discoloration.jpg"
        case "Mouth Ulcer": return "https://example.com/ulcer.jpg"
        case "Hypodontia": return "https://example.com/hypodontia.jpg"
        default: return ""
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended Actions")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(recommendation)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
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
        VStack(alignment: .leading, spacing: 12) {
            Text("Prevention Tips")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(preventionTips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "shield.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text(tip)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
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
