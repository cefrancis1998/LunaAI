//
//  ScanHistoryDetailView.swift
//  Luna
//
//  Created by Christian Francis on 2025-07-05.
//

import SwiftUI

struct ScanHistoryDetailView: View {
    let scanResult: ScanResult
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Scan Image
                Group {
                    if let imageData = scanResult.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .onAppear {
                                print("✅ ScanHistoryDetailView: Image data found - Size: \(imageData.count) bytes")
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 300)
                            .overlay(
                                VStack {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                    Text("Original image unavailable")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            )
                            .onAppear {
                                let validation = ScanResult.validateImageData(scanResult.imageData)
                                if !validation.isValid {
                                    print("❌ ScanHistoryDetailView: Invalid image - \(validation.errorMessage ?? "Unknown error")")
                                }
                            }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Scan Information
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scan Details")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(scanResult.timestamp, style: .date)
                                .font(.body)
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text(scanResult.timestamp, style: .time)
                                .font(.body)
                        }
                        
                        HStack {
                            Image(systemName: "list.clipboard")
                                .foregroundColor(.blue)
                            Text("\(scanResult.conditions.count) conditions analyzed")
                                .font(.body)
                        }
                    }
                    .padding()
.background(Color.lunaGroupedBackground)
                    .cornerRadius(12)
                    
                    // Conditions Results
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Detected Conditions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                            ForEach(scanResult.conditions.sorted(by: { $0.confidence > $1.confidence })) { condition in
                                NavigationLink(destination: DentalDetailView(condition: condition)) {
                                    ConditionDetailCard(condition: condition)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    // Overall Risk Assessment
                    overallRiskView
                }
                .padding(.top, 20)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Scan Results")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var overallRiskView: some View {
        let highRiskCount = scanResult.conditions.filter { $0.risk == .high }.count
        let mediumRiskCount = scanResult.conditions.filter { $0.risk == .medium }.count
        let lowRiskCount = scanResult.conditions.filter { $0.risk == .low }.count
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Overall Assessment")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                if highRiskCount > 0 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("High Priority: \(highRiskCount) condition\(highRiskCount > 1 ? "s" : "")")
                            .font(.body)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                
                if mediumRiskCount > 0 {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.orange)
                        Text("Monitor: \(mediumRiskCount) condition\(mediumRiskCount > 1 ? "s" : "")")
                            .font(.body)
                            .foregroundColor(.orange)
                        Spacer()
                    }
                }
                
                if lowRiskCount > 0 {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Low Risk: \(lowRiskCount) condition\(lowRiskCount > 1 ? "s" : "")")
                            .font(.body)
                            .foregroundColor(.green)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ConditionDetailCard: View {
    let condition: ConditionResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(condition.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Circle()
                        .fill(condition.risk.color)
                        .frame(width: 12, height: 12)
                    Text(condition.risk.rawValue)
                        .font(.subheadline)
                        .foregroundColor(condition.risk.color)
                }
                
                Text("Confidence: \(Int(condition.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        ScanHistoryDetailView(scanResult: ScanResult.sampleData[0])
    }
} 
