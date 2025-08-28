//
//  FloatingTabBar.swift
//  Luna
//
//  Created by Claude on 2025-08-28.
//

import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    @State private var tabButtonPressed: Int? = nil
    
    let tabs = [
        TabItem(icon: "camera.viewfinder", selectedIcon: "camera.viewfinder", title: "Scan"),
        TabItem(icon: "chart.xyaxis.line", selectedIcon: "chart.line.uptrend.xyaxis", title: "History"),
        TabItem(icon: "book", selectedIcon: "book.fill", title: "Learn")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    isPressed: tabButtonPressed == index,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = index
                        }
                    }
                )
                .onTapGesture {
                    tabButtonPressed = index
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        tabButtonPressed = nil
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .lunaStrongShadow()
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let isPressed: Bool
    let action: () -> Void
    
    @State private var animationAmount: CGFloat = 1.0
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient.lunaBrandGradient)
                            .frame(width: 48, height: 48)
                            .lunaColoredShadow(.lunaPrimary, radius: 8, y: 4)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.clear)
                            .frame(width: 48, height: 48)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : .lunaSecondaryText)
                        .scaleEffect(animationAmount)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
                }
                
                Text(tab.title)
                    .font(.system(.caption2, design: .rounded, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .lunaPrimary : .lunaSecondaryText)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: isSelected) { selected in
            if selected {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    animationAmount = 1.2
                }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.1)) {
                    animationAmount = 1.0
                }
            }
        }
    }
}

struct TabItem {
    let icon: String
    let selectedIcon: String
    let title: String
}

#Preview {
    VStack {
        Spacer()
        FloatingTabBar(selectedTab: .constant(0))
    }
    .background(Color.lunaBackground.ignoresSafeArea())
}