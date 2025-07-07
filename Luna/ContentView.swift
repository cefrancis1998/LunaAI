//
//  ContentView.swift
//  Luna
//
//  Created by Christian Francis on 2025-06-18.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingCamera = false
    @State private var lastScanResult: ScanResult? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScanView(showingCamera: $showingCamera, lastScanResult: $lastScanResult)
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                    Text("Scan")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("History")
                }
                .tag(1)
            
            LearnView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .edgesIgnoringSafeArea(.bottom) // Let TabView handle bottom safe area
    }
}

struct ScanView: View {
    @Binding var showingCamera: Bool
    @Binding var lastScanResult: ScanResult?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack {
                        Text("Luna Smile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        Text("Your Pocket Dental Check-up")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Camera Preview Placeholder
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                Text("Tap to scan your smile")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        )
                        .onTapGesture {
                            simulateScan()
                        }
                    
                    // Scan Button
                    Button(action: simulateScan) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Start Dental Scan")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Results Section
                    if let result = lastScanResult {
                        ResultsView(result: result)
                            .transition(.opacity)
                            .padding(.bottom, 100) // Extra padding to prevent tab bar overlap
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showingCamera) {
            CameraView(lastScanResult: $lastScanResult, modelContext: modelContext)
        }
    }
    
    private func simulateScan() {
        // Open camera for real scanning
        showingCamera = true
        
        // withAnimation {
        //     // Simulate a scan with mock data
        //     lastScanResult = ScanResult(
        //         timestamp: Date(),
        //         conditions: [
        //             ConditionResult(name: "Calculus", risk: .low, confidence: 0.85),
        //             ConditionResult(name: "Caries", risk: .medium, confidence: 0.72),
        //             ConditionResult(name: "Gingivitis", risk: .low, confidence: 0.91),
        //             ConditionResult(name: "Tooth Discoloration", risk: .medium, confidence: 0.68),
        //             ConditionResult(name: "Mouth Ulcer", risk: .low, confidence: 0.95),
        //             ConditionResult(name: "Hypodontia", risk: .low, confidence: 0.88)
        //         ]
        //     )
        // }
    }
}

struct CameraView: View {
    @Binding var lastScanResult: ScanResult?
    let modelContext: ModelContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ImagePickerView(
            lastScanResult: $lastScanResult,
            modelContext: modelContext,
            onDismiss: {
                presentationMode.wrappedValue.dismiss()
            }
        )
        .ignoresSafeArea(.all) // This makes the camera fill the entire screen
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var lastScanResult: ScanResult?
    let modelContext: ModelContext
    let onDismiss: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView
        private let classificationService = DentalClassificationService()
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Get the captured image
            guard let image = info[.originalImage] as? UIImage else {
                parent.onDismiss()
                return
            }
            
            // Process the image with the ML model
            Task { @MainActor in
                do {
                    let conditions = try await classificationService.classifyImage(image)
                    
                    // Convert UIImage to Data for storage
                    let imageData = image.jpegData(compressionQuality: 0.8)
                    
                    // Create and save scan result
                    let scanResult = ScanResult(
                        timestamp: Date(),
                        conditions: conditions,
                        imageData: imageData
                    )
                    
                    parent.modelContext.insert(scanResult)
                    
                    withAnimation {
                        self.parent.lastScanResult = scanResult
                    }
                } catch {
                    print("Error classifying image: \(error)")
                    
                    // Fall back to default conditions if ML fails
                    let fallbackResult = ScanResult(
                        timestamp: Date(),
                        conditions: ConditionResult.sampleData
                    )
                    
                    parent.modelContext.insert(fallbackResult)
                    
                    withAnimation {
                        self.parent.lastScanResult = fallbackResult
                    }
                }
                
                parent.onDismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onDismiss()
        }
    }
}

struct ResultsView: View {
    let result: ScanResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scan Results")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(result.conditions, id: \.name) { condition in
                    ConditionCard(condition: condition)
                }
            }
        }
        .padding()
.background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ConditionCard: View {
    let condition: ConditionResult
    
    var body: some View {
        NavigationLink(destination: DentalDetailView(condition: condition)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Circle()
                        .fill(condition.risk.color)
                        .frame(width: 8, height: 8)
                    Text(condition.name)
                        .font(.caption)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(condition.risk.rawValue)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("\(Int(condition.confidence * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanResult.timestamp, order: .reverse) private var scanResults: [ScanResult]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Scan History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if scanResults.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No scan history yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Take your first dental scan to see results here")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(scanResults) { scan in
                            NavigationLink(destination: ScanHistoryDetailView(scanResult: scan)) {
                                HistoryRow(scan: scan)
                            }
                        }
                        .onDelete(perform: deleteScans)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func deleteScans(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(scanResults[index])
            }
        }
    }
}

struct HistoryRow: View {
    let scan: ScanResult
    
    var body: some View {
        HStack {
            // Scan thumbnail or icon
            if let imageData = scan.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .foregroundColor(.blue)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scan.timestamp, style: .date)
                    .font(.headline)
                Text(scan.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Show highest risk condition
                if let highestRisk = scan.conditions.max(by: { $0.risk.rawValue < $1.risk.rawValue }) {
                    HStack {
                        Circle()
                            .fill(highestRisk.risk.color)
                            .frame(width: 8, height: 8)
                        Text(highestRisk.risk.rawValue)
                            .font(.caption2)
                            .foregroundColor(highestRisk.risk.color)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(scan.conditions.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("conditions")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

struct LearnView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Learn About Oral Health")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        ForEach(educationTopics, id: \.title) { topic in
                            EducationCard(topic: topic)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Extra padding to prevent tab bar overlap
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var educationTopics: [EducationTopic] {
        EducationTopic.sampleData
    }
}

struct EducationCard: View {
    let topic: EducationTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: topic.icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(topic.title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(topic.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ScanResult.self, inMemory: true)
}
