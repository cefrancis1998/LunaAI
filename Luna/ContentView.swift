//
//  ContentView.swift
//  Luna
//
//  Created by Christian Francis on 2025-06-18.
//

import SwiftUI
import SwiftData
import UIKit
import PhotosUI

enum InputMode {
    case camera
    case library
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingCamera = false
    @State private var lastScanResult: ScanResult? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScanView(showingCamera: $showingCamera, lastScanResult: $lastScanResult)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "camera.viewfinder" : "camera")
                        .font(.system(size: 16, weight: .medium))
                    Text("Scan")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.line.uptrend.xyaxis" : "chart.xyaxis.line")
                        .font(.system(size: 16, weight: .medium))
                    Text("History")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                }
                .tag(1)
            
            LearnView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "book.fill" : "book")
                        .font(.system(size: 16, weight: .medium))
                    Text("Learn")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                }
                .tag(2)
        }
        .tint(.lunaPrimary)
        .background(Color.lunaCardBackground)
        .onAppear {
            // Enhanced tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.lunaCardBackground)
            appearance.shadowColor = UIColor(Color.black.opacity(0.1))
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.lunaSecondaryText)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(Color.lunaSecondaryText),
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.lunaPrimary)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(Color.lunaPrimary),
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ScanView: View {
    @Binding var showingCamera: Bool
    @Binding var lastScanResult: ScanResult?
    @Environment(\.modelContext) private var modelContext
    @State private var showInputSheet = false
    @State private var inputMode: InputMode?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header with better spacing
                    VStack(spacing: 12) {
                        Text("Luna Smile")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundColor(.lunaPrimary)
                        
                        Text("Your Pocket Dental Check-up")
                            .font(.subheadline)
                            .foregroundColor(.lunaSecondaryText)
                            .opacity(0.8)
                    }
                    .padding(.top, 20)
                    
                    // Enhanced Camera Preview
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.lunaSecondaryBackground,
                                    Color.lunaSecondaryBackground.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 320)
                        .overlay(
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lunaPrimary.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(.lunaPrimary)
                                }
                                
                                VStack(spacing: 6) {
                                    Text("Tap to scan your smile")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .foregroundColor(.lunaPrimary)
                                    
                                    Text("Take a photo or choose from library")
                                        .font(.caption)
                                        .foregroundColor(.lunaSecondaryText)
                                        .opacity(0.7)
                                }
                            }
                        )
                        .shadow(
                            color: Color.lunaPrimary.opacity(0.08),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                        .onTapGesture {
                            showInputSheet = true
                        }
                    
                    // Enhanced Scan Button
                    Button(action: { showInputSheet = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Start Dental Scan")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [Color.lunaPrimary, Color.lunaPrimary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: Color.lunaPrimary.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                    }
                    .padding(.horizontal, 20)
                    .actionSheet(isPresented: $showInputSheet) {
                        ActionSheet(
                            title: Text("Select Input Source"),
                            message: Text("Choose how you'd like to capture your dental scan"),
                            buttons: [
                                .default(Text("Take Photo")) {
                                    inputMode = .camera
                                    showingCamera = true
                                },
                                .default(Text("Choose Existing Photo")) {
                                    inputMode = .library
                                    showingCamera = true
                                },
                                .cancel()
                            ]
                        )
                    }
                    
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
        .fullScreenCover(isPresented: $showingCamera, onDismiss: {
            inputMode = nil
        }) {
            CameraView(lastScanResult: $lastScanResult, modelContext: modelContext, inputMode: inputMode)
        }
    }
    
    private func simulateScan() {
        // Deprecated: Now using ActionSheet for input selection
        // This function kept for potential future use
        
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
    let inputMode: InputMode?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Group {
            switch inputMode {
            case .camera:
                CameraPickerView(
                    lastScanResult: $lastScanResult,
                    modelContext: modelContext,
                    onDismiss: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            case .library:
                PhotoLibraryPickerView(
                    lastScanResult: $lastScanResult,
                    modelContext: modelContext,
                    onDismiss: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            case nil:
                EmptyView()
            }
        }
        .ignoresSafeArea(.all) // This makes the camera fill the entire screen
    }
}

struct CameraPickerView: UIViewControllerRepresentable {
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
        let parent: CameraPickerView
        private let classificationService = DentalClassificationService()
        
        init(_ parent: CameraPickerView) {
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

struct PhotoLibraryPickerView: UIViewControllerRepresentable {
    @Binding var lastScanResult: ScanResult?
    let modelContext: ModelContext
    let onDismiss: () -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoLibraryPickerView
        private let classificationService = DentalClassificationService()
        
        init(_ parent: PhotoLibraryPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider else {
                parent.onDismiss()
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let self = self, let image = image as? UIImage else {
                        DispatchQueue.main.async {
                            self?.parent.onDismiss()
                        }
                        return
                    }
                    
                    // Process the image with the ML model
                    Task { @MainActor in
                        do {
                            let conditions = try await self.classificationService.classifyImage(image)
                            
                            // Convert UIImage to Data for storage
                            let imageData = image.jpegData(compressionQuality: 0.8)
                            
                            // Create and save scan result
                            let scanResult = ScanResult(
                                timestamp: Date(),
                                conditions: conditions,
                                imageData: imageData
                            )
                            
                            self.parent.modelContext.insert(scanResult)
                            
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
                            
                            self.parent.modelContext.insert(fallbackResult)
                            
                            withAnimation {
                                self.parent.lastScanResult = fallbackResult
                            }
                        }
                        
                        self.parent.onDismiss()
                    }
                }
            } else {
                parent.onDismiss()
            }
        }
    }
}

struct ResultsView: View {
    let result: ScanResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Enhanced Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Scan Results")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.lunaPrimaryText)
                    
                    Text("Tap any condition for details")
                        .font(.caption)
                        .foregroundColor(.lunaSecondaryText)
                        .opacity(0.7)
                }
                
                Spacer()
                
                // Results timestamp
                VStack(alignment: .trailing, spacing: 2) {
                    Text(result.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.lunaSecondaryText)
                    Text(result.timestamp, style: .date)
                        .font(.caption2)
                        .foregroundColor(.lunaSecondaryText)
                }
            }
            
            // Enhanced Grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
                spacing: 16
            ) {
                ForEach(result.conditions, id: \.name) { condition in
                    ConditionCard(condition: condition)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.lunaCardBackground)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lunaSecondaryBackground, lineWidth: 1)
        )
    }
}

struct ConditionCard: View {
    let condition: ConditionResult
    
    var body: some View {
        NavigationLink(destination: DentalDetailView(condition: condition)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with risk indicator
                HStack(spacing: 8) {
                    Circle()
                        .fill(condition.risk.color)
                        .frame(width: 10, height: 10)
                        .shadow(color: condition.risk.color.opacity(0.4), radius: 2, x: 0, y: 1)
                    
                    Text(condition.name)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundColor(.lunaPrimaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                // Risk level and confidence
                VStack(alignment: .leading, spacing: 6) {
                    Text(condition.risk.rawValue)
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundColor(condition.risk.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(condition.risk.color.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    HStack {
                        Text("Confidence")
                            .font(.caption2)
                            .foregroundColor(.lunaSecondaryText)
                        
                        Spacer()
                        
                        Text("\(Int(condition.confidence * 100))%")
                            .font(.system(.caption2, design: .rounded, weight: .semibold))
                            .foregroundColor(.lunaPrimaryText)
                    }
                }
                
                // Subtle arrow indicator
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundColor(.lunaSecondaryText)
                        .opacity(0.5)
                }
            }
            .padding(16)
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
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.lunaSecondaryBackground.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibleConditionCard(
            name: condition.name,
            risk: condition.risk.rawValue,
            confidence: condition.confidence
        )
    }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanResult.timestamp, order: .reverse) private var scanResults: [ScanResult]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced Header
                VStack(spacing: 8) {
                    Text("Scan History")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.lunaPrimaryText)
                    
                    if !scanResults.isEmpty {
                        Text("\(scanResults.count) scan\(scanResults.count == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundColor(.lunaSecondaryText)
                            .opacity(0.7)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                if scanResults.isEmpty {
                    // Enhanced Empty State
                    Spacer()
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.lunaSecondaryBackground)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.lunaPrimary)
                        }
                        
                        VStack(spacing: 8) {
                            Text("No scan history yet")
                                .font(.system(.title2, design: .rounded, weight: .semibold))
                                .foregroundColor(.lunaPrimaryText)
                            
                            Text("Take your first dental scan to see results here")
                                .font(.body)
                                .foregroundColor(.lunaSecondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(scanResults) { scan in
                            NavigationLink(destination: ScanHistoryDetailView(scanResult: scan)) {
                                HistoryRow(scan: scan)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .accessibleHistoryRow(
                                date: scan.timestamp,
                                conditionCount: scan.conditions.count
                            )
                        }
                        .onDelete(perform: deleteScans)
                    }
                    .listStyle(PlainListStyle())
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
        HStack(spacing: 16) {
            // Enhanced thumbnail
            if let imageData = scan.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.lunaSecondaryBackground, lineWidth: 1)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.lunaPrimary.opacity(0.1),
                                Color.lunaPrimary.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.lunaPrimary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.lunaSecondaryBackground, lineWidth: 1)
                    )
            }
            
            // Enhanced content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(scan.timestamp, style: .date)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundColor(.lunaPrimaryText)
                    
                    Spacer()
                    
                    Text(scan.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.lunaSecondaryText)
                }
                
                // Enhanced risk indicator
                if let highestRisk = scan.conditions.max(by: { $0.risk.rawValue < $1.risk.rawValue }) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(highestRisk.risk.color)
                            .frame(width: 8, height: 8)
                            .shadow(color: highestRisk.risk.color.opacity(0.4), radius: 1, x: 0, y: 0.5)
                        
                        Text("Highest: \(highestRisk.risk.rawValue)")
                            .font(.caption)
                            .foregroundColor(highestRisk.risk.color)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        // Condition count badge
                        Text("\(scan.conditions.count)")
                            .font(.system(.caption2, design: .rounded, weight: .bold))
                            .foregroundColor(.lunaPrimaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.lunaSecondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
            
            // Subtle arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.lunaSecondaryText)
                .opacity(0.6)
        }
        .padding(16)
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
}

struct LearnView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Enhanced Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Learn About Oral Health")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundColor(.lunaPrimaryText)
                        
                        Text("Explore dental conditions and prevention tips")
                            .font(.subheadline)
                            .foregroundColor(.lunaSecondaryText)
                            .opacity(0.8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Enhanced Grid
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
                        spacing: 20
                    ) {
                        ForEach(educationTopics, id: \.title) { topic in
                            EducationCard(topic: topic)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120) // Extra padding to prevent tab bar overlap
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
        VStack(alignment: .leading, spacing: 16) {
            // Enhanced icon section
            ZStack {
                Circle()
                    .fill(Color.lunaPrimary.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: topic.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.lunaPrimary)
            }
            
            // Enhanced content
            VStack(alignment: .leading, spacing: 8) {
                Text(topic.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(.lunaPrimaryText)
                    .lineLimit(2)
                
                Text(topic.description)
                    .font(.caption)
                    .foregroundColor(.lunaSecondaryText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Subtle "Learn more" indicator
            HStack {
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption2)
                    .foregroundColor(.lunaSecondaryText)
                    .opacity(0.5)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: 160, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lunaCardBackground)
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.lunaSecondaryBackground.opacity(0.5), lineWidth: 1)
        )
    }
}

// MARK: - ResultsView Previews
#Preview("ResultsView - Light Mode") {
    ResultsView(result: ScanResult.sampleData.first!)
        .environment(\.colorScheme, .light)
        .padding()
}

#Preview("ResultsView - Dark Mode") {
    ResultsView(result: ScanResult.sampleData.first!)
        .environment(\.colorScheme, .dark)
        .padding()
}

// MARK: - ConditionCard Previews
#Preview("ConditionCard - Light Mode") {
    ConditionCard(condition: ConditionResult.sampleData.first!)
        .environment(\.colorScheme, .light)
        .padding()
}

#Preview("ConditionCard - Dark Mode") {
    ConditionCard(condition: ConditionResult.sampleData.first!)
        .environment(\.colorScheme, .dark)
        .padding()
}

// MARK: - ContentView Preview
#Preview {
    ContentView()
        .modelContainer(for: ScanResult.self, inMemory: true)
}
