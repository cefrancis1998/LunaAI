//
//  Models.swift
//  Luna
//
//  Created by Christian Francis on 2025-07-05.
//

import Foundation
import SwiftData
import SwiftUI

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

// MARK: - Sample Data
extension ScanResult {
    static let sampleData: [ScanResult] = [
        ScanResult(
            timestamp: Date().addingTimeInterval(-86400),
            conditions: [
                ConditionResult(name: "Calculus", risk: .low, confidence: 0.85),
                ConditionResult(name: "Caries", risk: .medium, confidence: 0.72),
                ConditionResult(name: "Gingivitis", risk: .low, confidence: 0.91)
            ]
        ),
        ScanResult(
            timestamp: Date().addingTimeInterval(-172800),
            conditions: [
                ConditionResult(name: "Tooth Discoloration", risk: .medium, confidence: 0.68),
                ConditionResult(name: "Mouth Ulcer", risk: .low, confidence: 0.95)
            ]
        ),
        ScanResult(
            timestamp: Date().addingTimeInterval(-259200),
            conditions: [
                ConditionResult(name: "Hypodontia", risk: .low, confidence: 0.88)
            ]
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