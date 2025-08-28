//
//  Models.swift
//  Luna
//
//  Created by Christian Francis on 2025-07-05.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit

// MARK: - Risk Level Enum
enum RiskLevel: String, CaseIterable, Codable {
    case low = "Safe"
    case medium = "Monitor"
    case high = "See Dentist"
    
    var color: Color {
        switch self {
        case .low: return .vibrantGreen
        case .medium: return .vibrantOrange
        case .high: return .vibrantRed
        }
    }
}

// MARK: - Condition Result
struct ConditionResult: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let risk: RiskLevel
    let confidence: Double
    
    init(name: String, risk: RiskLevel, confidence: Double) {
        self.name = name
        self.risk = risk
        self.confidence = confidence
    }
}

// MARK: - Scan Result (SwiftData Model)
@Model
final class ScanResult {
    var timestamp: Date
    var conditions: [ConditionResult]
    var imageData: Data?
    
    init(timestamp: Date, conditions: [ConditionResult], imageData: Data? = nil) {
        self.timestamp = timestamp
        self.conditions = conditions
        self.imageData = imageData
    }
}

// MARK: - Education Topic
struct EducationTopic: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    
    init(title: String, description: String, icon: String) {
        self.title = title
        self.description = description
        self.icon = icon
    }
}

// MARK: - Image Validation
extension ScanResult {
    // Helper function to validate image data
    static func validateImageData(_ data: Data?) -> (isValid: Bool, errorMessage: String?) {
        guard let data = data else {
            return (false, "No image data provided")
        }
        
        // Check minimum size (empty data or very small files are likely corrupted)
        guard data.count > 100 else {
            return (false, "Image data too small (\(data.count) bytes)")
        }
        
        // Try to create UIImage to validate format
        guard UIImage(data: data) != nil else {
            return (false, "Invalid image format or corrupted data")
        }
        
        return (true, nil)
    }
    
    // Convenience method to check if scan result has valid image
    var hasValidImage: Bool {
        return ScanResult.validateImageData(imageData).isValid
    }
    
    // Get validation error message if image is invalid
    var imageValidationError: String? {
        return ScanResult.validateImageData(imageData).errorMessage
    }
}

// MARK: - Sample Data
extension ScanResult {
    // Helper function to create a placeholder image
    private static func createPlaceholderImageData(color: UIColor, text: String) -> Data? {
        let size = CGSize(width: 300, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            // Fill background
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Draw text
            let textColor = UIColor.white
            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
            let textRect = CGRect(x: 20, y: size.height/2 - 10, width: size.width - 40, height: 20)
            
            text.draw(in: textRect, withAttributes: [
                .font: font,
                .foregroundColor: textColor
            ])
        }
        
        return image.jpegData(compressionQuality: 0.8)
    }
    
    static let sampleData: [ScanResult] = [
        ScanResult(
            timestamp: Date().addingTimeInterval(-86400),
            conditions: [
                ConditionResult(name: "Calculus", risk: .low, confidence: 0.85),
                ConditionResult(name: "Caries", risk: .medium, confidence: 0.72),
                ConditionResult(name: "Gingivitis", risk: .low, confidence: 0.91)
            ],
            imageData: createPlaceholderImageData(color: .systemBlue, text: "Sample Dental Scan #1")
        ),
        ScanResult(
            timestamp: Date().addingTimeInterval(-172800),
            conditions: [
                ConditionResult(name: "Tooth Discoloration", risk: .medium, confidence: 0.68),
                ConditionResult(name: "Mouth Ulcer", risk: .low, confidence: 0.95)
            ],
            imageData: createPlaceholderImageData(color: .systemGreen, text: "Sample Dental Scan #2")
        ),
        ScanResult(
            timestamp: Date().addingTimeInterval(-259200),
            conditions: [
                ConditionResult(name: "Hypodontia", risk: .low, confidence: 0.88)
            ],
            imageData: createPlaceholderImageData(color: .systemOrange, text: "Sample Dental Scan #3")
        )
    ]
}

extension ConditionResult {
    static let sampleData: [ConditionResult] = [
        ConditionResult(name: "Calculus", risk: .low, confidence: 0.85),
        ConditionResult(name: "Caries", risk: .medium, confidence: 0.72),
        ConditionResult(name: "Gingivitis", risk: .low, confidence: 0.91),
        ConditionResult(name: "Tooth Discoloration", risk: .medium, confidence: 0.68),
        ConditionResult(name: "Mouth Ulcer", risk: .low, confidence: 0.95),
        ConditionResult(name: "Hypodontia", risk: .low, confidence: 0.88)
    ]
}

extension EducationTopic {
    static let sampleData: [EducationTopic] = [
        EducationTopic(title: "Calculus", description: "Learn about tartar buildup", icon: "drop.fill"),
        EducationTopic(title: "Caries", description: "Understanding cavities", icon: "exclamationmark.triangle.fill"),
        EducationTopic(title: "Gingivitis", description: "Gum health basics", icon: "heart.fill"),
        EducationTopic(title: "Discoloration", description: "Tooth whitening tips", icon: "sparkles"),
        EducationTopic(title: "Mouth Ulcers", description: "Healing and prevention", icon: "bandage.fill"),
        EducationTopic(title: "Hypodontia", description: "Missing teeth info", icon: "questionmark.circle.fill")
    ]
} 