//
//  DentalClassificationService.swift
//  Luna
//
//  Created by Christian Francis on 2025-07-05.
//

import Foundation
import CoreML
import Vision
import UIKit
import SwiftUI

@MainActor
class DentalClassificationService: ObservableObject {
    private var model: VNCoreMLModel?
    
    init() {
        loadModel()
    }
    
    private func loadModel() {
        guard let modelURL = Bundle.main.url(forResource: "DentalClassifier", withExtension: "mlmodelc") else {
            print("Failed to find DentalClassifier.mlmodelc in bundle")
            return
        }
        
        do {
            let mlModel = try MLModel(contentsOf: modelURL)
            model = try VNCoreMLModel(for: mlModel)
            print("Successfully loaded DentalClassifier model")
        } catch {
            print("Failed to load DentalClassifier model: \(error)")
        }
    }
    
    func classifyImage(_ image: UIImage) async throws -> [ConditionResult] {
        guard let model = model else {
            throw ClassificationError.modelNotLoaded
        }
        
        guard let pixelBuffer = image.pixelBuffer() else {
            throw ClassificationError.imageProcessingFailed
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation] else {
                    continuation.resume(throwing: ClassificationError.invalidResults)
                    return
                }
                
                let conditions = self.processResults(results)
                continuation.resume(returning: conditions)
            }
            
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func processResults(_ results: [VNClassificationObservation]) -> [ConditionResult] {
        let conditionMap: [String: String] = [
            "calculus": "Calculus",
            "caries": "Caries", 
            "gingivitis": "Gingivitis",
            "discoloration": "Tooth Discoloration",
            "ulcer": "Mouth Ulcer",
            "hypodontia": "Hypodontia"
        ]
        
        var conditions: [ConditionResult] = []
        
        for result in results {
            let identifier = result.identifier.lowercased()
            let confidence = Double(result.confidence)
            
            // Find matching condition
            for (key, displayName) in conditionMap {
                if identifier.contains(key) {
                    let risk = determineRiskLevel(for: displayName, confidence: confidence)
                    let condition = ConditionResult(
                        name: displayName,
                        risk: risk,
                        confidence: confidence
                    )
                    conditions.append(condition)
                    break
                }
            }
        }
        
        // If no conditions found, return default set with low confidence
        if conditions.isEmpty {
            conditions = createDefaultConditions()
        }
        
        return conditions
    }
    
    private func determineRiskLevel(for condition: String, confidence: Double) -> RiskLevel {
        // Risk determination based on condition type and confidence
        switch condition {
        case "Caries":
            return confidence > 0.7 ? .high : (confidence > 0.5 ? .medium : .low)
        case "Gingivitis":
            return confidence > 0.8 ? .high : (confidence > 0.6 ? .medium : .low)
        case "Calculus":
            return confidence > 0.6 ? .medium : .low
        case "Mouth Ulcer":
            return confidence > 0.7 ? .medium : .low
        case "Hypodontia":
            return confidence > 0.8 ? .high : (confidence > 0.6 ? .medium : .low)
        case "Tooth Discoloration":
            return confidence > 0.7 ? .medium : .low
        default:
            return .low
        }
    }
    
    private func createDefaultConditions() -> [ConditionResult] {
        return [
            ConditionResult(name: "Calculus", risk: .low, confidence: 0.3),
            ConditionResult(name: "Caries", risk: .low, confidence: 0.2),
            ConditionResult(name: "Gingivitis", risk: .low, confidence: 0.25),
            ConditionResult(name: "Tooth Discoloration", risk: .low, confidence: 0.35),
            ConditionResult(name: "Mouth Ulcer", risk: .low, confidence: 0.1),
            ConditionResult(name: "Hypodontia", risk: .low, confidence: 0.15)
        ]
    }
}

// MARK: - Error Types
enum ClassificationError: Error, LocalizedError {
    case modelNotLoaded
    case imageProcessingFailed
    case invalidResults
    
    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "The dental classification model could not be loaded"
        case .imageProcessingFailed:
            return "Failed to process the image for classification"
        case .invalidResults:
            return "Invalid results returned from the model"
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attributes,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        defer { CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0)) }
        
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        return pixelBuffer
    }
} 