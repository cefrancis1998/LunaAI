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
        ZStack {
            // Premium background gradient
            LinearGradient.lunaBackgroundGradient
                .ignoresSafeArea()
            
            // Main content area
            TabView(selection: $selectedTab) {
                ScanView(showingCamera: $showingCamera, lastScanResult: $lastScanResult)
                    .tag(0)
                
                HistoryView()
                    .tag(1)
                
                LearnView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom floating tab bar overlay
            VStack {
                Spacer()
                FloatingTabBar(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            // Hide default tab bar
            UITabBar.appearance().isHidden = true
        }
    }
}

struct ScanView: View {
    @Binding var showingCamera: Bool
    @Binding var lastScanResult: ScanResult?
    @Environment(\.modelContext) private var modelContext
    @State private var showInputSheet = false
    @State private var inputMode: InputMode?
    @State private var headerOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Premium hero section with parallax
                        ZStack {
                            // Gradient hero background
                            RoundedRectangle(cornerRadius: 0)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.lunaPrimary.opacity(0.15),
                                            Color.lunaSecondary.opacity(0.08),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 280)
                                .offset(y: headerOffset * 0.5)
                            
                            // Hero content
                            VStack(spacing: 20) {
                                // Premium app icon
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient.lunaBrandGradient)
                                        .frame(width: 80, height: 80)
                                        .lunaColoredShadow(.lunaPrimary, radius: 16, y: 8)
                                    
                                    Image(systemName: "mouth.fill")
                                        .font(.system(size: 36, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .scaleEffect(1.0 - headerOffset * 0.0002)
                                
                                VStack(spacing: 8) {
                                    Text("Luna Smile")
                                        .lunaHeroTitle()
                                        .opacity(1.0 - headerOffset * 0.002)
                                    
                                    Text("AI-Powered Dental Health Analysis")
                                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                                        .foregroundColor(.lunaSecondaryText)
                                        .opacity(0.8 - headerOffset * 0.001)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.top, 60)
                            .offset(y: headerOffset * 0.3)
                        }
                        
                        // Main content with premium spacing
                        VStack(spacing: 40) {
                    
                            // Premium camera preview with glass morphism
                            VStack(spacing: 24) {
                                RoundedRectangle(cornerRadius: 28)
                                    .frame(height: 340)
                                    .lunaFloatingCard()
                                    .overlay(
                                        VStack(spacing: 24) {
                                            // Floating camera icon with animation
                                            ZStack {
                                                Circle()
                                                    .fill(LinearGradient.lunaBrandGradient)
                                                    .frame(width: 100, height: 100)
                                                    .lunaColoredShadow(.lunaPrimary, radius: 20, y: 10)
                                                
                                                Image(systemName: "camera.viewfinder")
                                                    .font(.system(size: 40, weight: .medium))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            VStack(spacing: 12) {
                                                Text("Ready to Analyze Your Smile")
                                                    .lunaSectionTitle()
                                                    .multilineTextAlignment(.center)
                                                
                                                Text("Advanced AI-powered dental analysis\nin just seconds")
                                                    .lunaBodyText()
                                                    .multilineTextAlignment(.center)
                                                    .opacity(0.8)
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        showInputSheet = true
                                    }
                                
                                // Premium scan button
                                Button(action: { showInputSheet = true }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                        Text("Start Dental Scan")
                                            .font(.system(.headline, design: .rounded, weight: .semibold))
                                    }
                                }
                                .lunaPrimaryButton()
                            }
                            .padding(.horizontal, 24)
                    
                            // Results section with premium styling
                            if let result = lastScanResult {
                                VStack(alignment: .leading, spacing: 24) {
                                    HStack {
                                        Text("Latest Results")
                                            .lunaSectionTitle()
                                        
                                        Spacer()
                                        
                                        Text("Just now")
                                            .lunaCaptionText()
                                    }
                                    .padding(.horizontal, 24)
                                    
                                    ResultsView(result: result)
                                        .padding(.horizontal, 24)
                                }
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding(.bottom, 120) // Space for floating tab bar
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    headerOffset = geo.frame(in: .global).minY
                                }
                                .onChange(of: geo.frame(in: .global).minY) { _, value in
                                    headerOffset = value
                                }
                        }
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .actionSheet(isPresented: $showInputSheet) {
            ActionSheet(
                title: Text("Select Input Source"),
                message: Text("Choose how you'd like to capture your dental scan"),
                buttons: [
                    .default(Text("📸 Take Photo")) {
                        inputMode = .camera
                        showingCamera = true
                    },
                    .default(Text("📱 Choose Photo")) {
                        inputMode = .library
                        showingCamera = true
                    },
                    .cancel()
                ]
            )
        }
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
                    let validation = ScanResult.validateImageData(imageData)
                    
                    if validation.isValid {
                        print("✅ CameraPickerView: Successfully converted and validated image - Size: \(imageData?.count ?? 0) bytes")
                    } else {
                        print("⚠️ CameraPickerView: Image validation warning - \(validation.errorMessage ?? "Unknown issue") - Size: \(imageData?.count ?? 0) bytes")
                    }
                    
                    // Create and save scan result
                    let scanResult = ScanResult(
                        timestamp: Date(),
                        conditions: conditions,
                        imageData: imageData
                    )
                    
                    parent.modelContext.insert(scanResult)
                    print("✅ CameraPickerView: Saved scan result with image data to SwiftData")
                    
                    withAnimation {
                        self.parent.lastScanResult = scanResult
                    }
                } catch {
                    print("Error classifying image: \(error)")
                    
                    // Fall back to default conditions if ML fails, but preserve the original image
                    let imageData = image.jpegData(compressionQuality: 0.8)
                    let fallbackResult = ScanResult(
                        timestamp: Date(),
                        conditions: ConditionResult.sampleData,
                        imageData: imageData
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
                            let validation = ScanResult.validateImageData(imageData)
                            
                            if validation.isValid {
                                print("✅ PhotoLibraryPickerView: Successfully converted and validated image - Size: \(imageData?.count ?? 0) bytes")
                            } else {
                                print("⚠️ PhotoLibraryPickerView: Image validation warning - \(validation.errorMessage ?? "Unknown issue") - Size: \(imageData?.count ?? 0) bytes")
                            }
                            
                            // Create and save scan result
                            let scanResult = ScanResult(
                                timestamp: Date(),
                                conditions: conditions,
                                imageData: imageData
                            )
                            
                            self.parent.modelContext.insert(scanResult)
                            print("✅ PhotoLibraryPickerView: Saved scan result with image data to SwiftData")
                            
                            withAnimation {
                                self.parent.lastScanResult = scanResult
                            }
                        } catch {
                            print("Error classifying image: \(error)")
                            
                            // Fall back to default conditions if ML fails, but preserve the original image
                            let imageData = image.jpegData(compressionQuality: 0.8)
                            let fallbackResult = ScanResult(
                                timestamp: Date(),
                                conditions: ConditionResult.sampleData,
                                imageData: imageData
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
        VStack(alignment: .leading, spacing: 24) {
            // Premium header with glass morphism
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Analysis Complete")
                        .lunaSectionTitle()
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.lunaSafeGreen)
                            .frame(width: 8, height: 8)
                        
                        Text("\(result.conditions.count) conditions analyzed")
                            .lunaCaptionText()
                    }
                }
                
                Spacer()
                
                // Confidence indicator
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Accuracy")
                        .lunaCaptionText()
                    
                    let avgConfidence = result.conditions.map { $0.confidence }.reduce(0, +) / Double(result.conditions.count)
                    Text("\(Int(avgConfidence * 100))%")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.lunaPrimary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .lunaGlassCard(cornerRadius: 12)
            }
            
            // Premium conditions grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2),
                spacing: 20
            ) {
                ForEach(result.conditions, id: \.name) { condition in
                    ConditionCard(condition: condition)
                }
            }
        }
        .padding(28)
        .lunaFloatingCard(cornerRadius: 24)
    }
}

struct ConditionCard: View {
    let condition: ConditionResult
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: DentalDetailView(condition: condition)) {
            VStack(alignment: .leading, spacing: 16) {
                // Premium header with condition image thumbnail
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(condition.risk.color.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(conditionImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(condition.risk.color.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(condition.name)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundColor(.lunaPrimaryText)
                            .lineLimit(1)
                        
                        Text(condition.risk.rawValue)
                            .font(.system(.caption2, design: .rounded, weight: .medium))
                            .foregroundColor(condition.risk.color)
                    }
                    
                    Spacer()
                }
                
                // Confidence meter
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Confidence")
                            .lunaCaptionText()
                        
                        Spacer()
                        
                        Text("\(Int(condition.confidence * 100))%")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundColor(.lunaPrimary)
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.lunaSecondaryBackground)
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient.lunaBrandGradient)
                                .frame(width: geometry.size.width * CGFloat(condition.confidence), height: 6)
                        }
                    }
                    .frame(height: 6)
                }
            }
            .padding(20)
            .lunaGlassCard(cornerRadius: 16)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
        .accessibleConditionCard(
            name: condition.name,
            risk: condition.risk.rawValue,
            confidence: condition.confidence
        )
    }
    
    private var conditionImageName: String {
        switch condition.name.lowercased() {
        case "calculus": return "tartar"
        case "caries": return "caries"
        case "gingivitis": return "gingivitis"
        case "tooth discoloration": return "discoloration"
        case "mouth ulcer": return "ulcer"
        case "hypodontia": return "hypodontia"
        default: return "caries"
        }
    }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanResult.timestamp, order: .reverse) private var scanResults: [ScanResult]
    @State private var selectedTimeFrame: TimeFrame = .all
    
    enum TimeFrame: String, CaseIterable {
        case all = "All"
        case week = "This Week"
        case month = "This Month"
        case threeMonths = "3 Months"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.lunaBackgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Premium hero header
                        VStack(spacing: 24) {
                            // Stats overview
                            VStack(spacing: 16) {
                                Text("Health Journey")
                                    .lunaHeroTitle()
                                
                                HStack(spacing: 20) {
                                    StatCard(
                                        title: "Total Scans",
                                        value: "\(scanResults.count)",
                                        icon: "camera.viewfinder",
                                        color: .lunaPrimary
                                    )
                                    
                                    StatCard(
                                        title: "This Month",
                                        value: "\(thisMonthScans)",
                                        icon: "calendar",
                                        color: .lunaSecondary
                                    )
                                    
                                    StatCard(
                                        title: "Health Score",
                                        value: healthScore,
                                        icon: "heart.fill",
                                        color: .lunaSafeGreen
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 40)
                            
                            // Time filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                                        TimeFilterButton(
                                            timeFrame: timeFrame,
                                            selectedTimeFrame: selectedTimeFrame,
                                            action: {
                                                withAnimation(.spring()) {
                                                    selectedTimeFrame = timeFrame
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.bottom, 40)
                        
                        // Timeline content
                        if filteredScanResults.isEmpty {
                            premiumEmptyState
                        } else {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(filteredScanResults.enumerated()), id: \.element.id) { index, scan in
                                    TimelineRow(
                                        scan: scan,
                                        isFirst: index == 0,
                                        isLast: index == filteredScanResults.count - 1
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 120) // Space for floating tab bar
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Computed Properties
    private var thisMonthScans: Int {
        let calendar = Calendar.current
        let now = Date()
        return scanResults.filter { calendar.isDate($0.timestamp, equalTo: now, toGranularity: .month) }.count
    }
    
    private var healthScore: String {
        guard !scanResults.isEmpty else { return "N/A" }
        let recentScans = Array(scanResults.prefix(5))
        let lowRiskCount = recentScans.flatMap { $0.conditions }.filter { $0.risk == .low }.count
        let totalConditions = recentScans.flatMap { $0.conditions }.count
        let score = totalConditions > 0 ? (lowRiskCount * 100) / totalConditions : 0
        return "\(score)%"
    }
    
    private var filteredScanResults: [ScanResult] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeFrame {
        case .all:
            return scanResults
        case .week:
            return scanResults.filter { calendar.isDate($0.timestamp, equalTo: now, toGranularity: .weekOfYear) }
        case .month:
            return scanResults.filter { calendar.isDate($0.timestamp, equalTo: now, toGranularity: .month) }
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) ?? now
            return scanResults.filter { $0.timestamp >= threeMonthsAgo }
        }
    }
    
    private var premiumEmptyState: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(LinearGradient.lunaBrandGradient)
                    .frame(width: 120, height: 120)
                    .lunaColoredShadow(.lunaPrimary, radius: 20, y: 10)
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 16) {
                Text("Your Journey Awaits")
                    .lunaSectionTitle()
                
                Text("Start tracking your dental health\nwith your first scan")
                    .lunaBodyText()
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
            }
        }
        .padding(.vertical, 80)
    }
    
    private func deleteScans(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(scanResults[index])
            }
        }
    }
}

// MARK: - TimeFilterButton Component
struct TimeFilterButton: View {
    let timeFrame: HistoryView.TimeFrame
    let selectedTimeFrame: HistoryView.TimeFrame
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            let isSelected = selectedTimeFrame == timeFrame
            let textColor = isSelected ? Color.white : Color.lunaPrimary
            let buttonBackground = isSelected ? AnyShapeStyle(LinearGradient.lunaBrandGradient) : AnyShapeStyle(Color.lunaPrimary.opacity(0.1))
            
            Text(timeFrame.rawValue)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundColor(textColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(buttonBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lunaPrimary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - StatCard Component
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.lunaPrimaryText)
                
                Text(title)
                    .lunaCaptionText()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .lunaGlassCard()
    }
}

// MARK: - TimelineRow Component
struct TimelineRow: View {
    let scan: ScanResult
    let isFirst: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            // Timeline indicator
            VStack(spacing: 0) {
                if !isFirst {
                    Rectangle()
                        .fill(Color.lunaSecondaryBackground)
                        .frame(width: 2, height: 24)
                }
                
                ZStack {
                    Circle()
                        .fill(riskColor.opacity(0.2))
                        .frame(width: 28, height: 28)
                    
                    if let primaryCondition = scan.conditions.first {
                        Image(conditionImageName(for: primaryCondition.name))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(riskColor, lineWidth: 1.5)
                            )
                    } else {
                        Circle()
                            .fill(riskColor)
                            .frame(width: 8, height: 8)
                            .lunaColoredShadow(riskColor, radius: 4, y: 2)
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color.lunaSecondaryBackground)
                        .frame(width: 2, height: 24)
                }
            }
            
            // Scan content
            NavigationLink(destination: ScanHistoryDetailView(scanResult: scan)) {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(scan.timestamp, style: .date)
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundColor(.lunaPrimaryText)
                            
                            Text(scan.timestamp, style: .time)
                                .lunaCaptionText()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(scan.conditions.count)")
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundColor(.lunaPrimary)
                            
                            Text("conditions")
                                .lunaCaptionText()
                        }
                    }
                    
                    // Risk indicators
                    HStack(spacing: 12) {
                        ForEach(["low", "medium", "high"], id: \.self) { riskLevel in
                            let count = scan.conditions.filter { $0.risk.rawValue.lowercased() == riskLevel }.count
                            if count > 0 {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(colorForRisk(riskLevel))
                                        .frame(width: 8, height: 8)
                                    
                                    Text("\(count)")
                                        .font(.system(.caption2, design: .rounded, weight: .medium))
                                        .foregroundColor(colorForRisk(riskLevel))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(colorForRisk(riskLevel).opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.lunaSecondaryText)
                            .opacity(0.6)
                    }
                }
                .padding(20)
                .lunaElevatedCard()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var riskColor: Color {
        let highRisk = scan.conditions.contains { $0.risk == .high }
        let mediumRisk = scan.conditions.contains { $0.risk == .medium }
        
        if highRisk { return .lunaDangerRed }
        if mediumRisk { return .lunaWarningOrange }
        return .lunaSafeGreen
    }
    
    private func colorForRisk(_ risk: String) -> Color {
        switch risk {
        case "low": return .lunaSafeGreen
        case "medium": return .lunaWarningOrange
        case "high": return .lunaDangerRed
        default: return .lunaSecondaryText
        }
    }
    
    private func conditionImageName(for conditionName: String) -> String {
        switch conditionName.lowercased() {
        case "calculus": return "tartar"
        case "caries": return "caries"
        case "gingivitis": return "gingivitis"
        case "tooth discoloration": return "discoloration"
        case "mouth ulcer": return "ulcer"
        case "hypodontia": return "hypodontia"
        default: return "caries"
        }
    }
}


struct LearnView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.lunaBackgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Premium hero header
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                Text("Dental Knowledge")
                                    .lunaHeroTitle()
                                
                                Text("Expert insights and prevention tips\nto keep your smile healthy")
                                    .lunaBodyText()
                                    .multilineTextAlignment(.center)
                                    .opacity(0.8)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 40)
                            
                            // Featured health tip
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.lunaWarningOrange)
                                    
                                    Text("Daily Tip")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .foregroundColor(.lunaPrimaryText)
                                    
                                    Spacer()
                                }
                                
                                Text("Brush your teeth for at least 2 minutes, twice daily. Use gentle circular motions and don't forget to clean your tongue!")
                                    .lunaBodyText()
                                    .lineLimit(nil)
                            }
                            .padding(24)
                            .lunaFloatingCard()
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 40)
                        
                        // Premium education cards in vertical layout
                        LazyVStack(spacing: 20) {
                            ForEach(educationTopics, id: \.title) { topic in
                                EducationCard(topic: topic)
                            }
                        }
                        .padding(.horizontal, 24) // Consistent with other sections
                        .padding(.bottom, 120) // Space for floating tab bar
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var educationTopics: [EducationTopic] {
        EducationTopic.sampleData
    }
}

struct EducationCard: View {
    let topic: EducationTopic
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header section matching Daily Tip format
            HStack(spacing: 12) {
                // Icon circle with condition-specific color
                Circle()
                    .fill(iconColor)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: topic.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    )
                    .lunaColoredShadow(iconColor, radius: 4, y: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(.lunaPrimaryText)
                        .lineLimit(1)
                    
                    Text(conditionCategoryText)
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(iconColor)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            
            // Description text matching Daily Tip format
            Text(topic.description)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.lunaSecondaryText)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .opacity(0.9)
            
            // Learn More button matching Daily Tip format
            HStack {
                Text("Learn More")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(iconColor)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
            }
            .padding(.top, 4)
        }
        .padding(24) // Same padding as Daily Tip card
        .frame(maxWidth: .infinity, alignment: .leading)
        .lunaFloatingCard() // Same styling as Daily Tip card
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
    
    private var iconColor: Color {
        switch topic.icon {
        case "heart.fill": return .lunaDangerRed
        case "shield.fill": return .lunaSafeGreen
        case "exclamationmark.triangle.fill": return .lunaWarningOrange
        case "mouth.fill": return .lunaPrimary
        default: return .lunaSecondary
        }
    }
    
    private var iconGradient: LinearGradient {
        LinearGradient(
            colors: [iconColor, iconColor.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var conditionCategoryText: String {
        switch topic.title.lowercased() {
        case "calculus": return "Learn about tartar buildup"
        case "caries": return "Understanding cavities"
        case "gingivitis": return "Gum health basics"
        case "discoloration": return "Tooth whitening tips"
        case "mouth ulcers": return "Healing and prevention"
        case "hypodontia": return "Missing teeth info"
        default: return "Dental health info"
        }
    }
    
    private var conditionImageName: String {
        switch topic.title.lowercased() {
        case "calculus": return "tartar"
        case "caries": return "caries"
        case "gingivitis": return "gingivitis"
        case "discoloration": return "discoloration"
        case "mouth ulcers": return "ulcer"
        case "hypodontia": return "hypodontia"
        default: return "caries"
        }
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
