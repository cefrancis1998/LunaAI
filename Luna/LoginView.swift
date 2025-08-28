//
//  LoginView.swift
//  Luna
//
//  Created by Christian Francis on 2025-07-10.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSecureEntry: Bool = true
    @State private var isLoggedIn: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced Background
                LinearGradient(
                    colors: [
                        Color.lunaBackground,
                        Color.lunaSecondaryBackground.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Enhanced Logo and Header Section
                        VStack(spacing: 24) {
                            // Enhanced App Logo/Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.lunaPrimary.opacity(0.15),
                                                Color.lunaPrimary.opacity(0.05)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(
                                        color: Color.lunaPrimary.opacity(0.1),
                                        radius: 12,
                                        x: 0,
                                        y: 6
                                    )
                                
                                Image(systemName: "mouth.fill")
                                    .font(.system(size: 56, weight: .medium))
                                    .foregroundColor(.lunaPrimary)
                            }
                            .padding(.top, 80)
                            
                            // Enhanced Welcome Text
                            VStack(spacing: 12) {
                                Text("Welcome to Luna")
                                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                    .foregroundColor(.lunaPrimaryText)
                                
                                Text("Your Pocket Dental Check-up")
                                    .font(.system(.title3, design: .rounded, weight: .medium))
                                    .foregroundColor(.lunaSecondaryText)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.bottom, 64)
                        
                        // Enhanced Login Form
                        VStack(spacing: 28) {
                            // Enhanced Username Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Username")
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.lunaPrimaryText)
                                
                                TextField("Enter your username", text: $username)
                                    .textFieldStyle(EnhancedTextFieldStyle())
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textContentType(.username)
                            }
                            
                            // Enhanced Password Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Password")
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.lunaPrimaryText)
                                
                                ZStack(alignment: .trailing) {
                                    Group {
                                        if isSecureEntry {
                                            SecureField("Enter your password", text: $password)
                                        } else {
                                            TextField("Enter your password", text: $password)
                                        }
                                    }
                                    .textFieldStyle(EnhancedTextFieldStyle())
                                    .textContentType(.password)
                                    
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isSecureEntry.toggle()
                                        }
                                    }) {
                                        Image(systemName: isSecureEntry ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.lunaSecondaryText)
                                            .font(.system(size: 18, weight: .medium))
                                    }
                                    .padding(.trailing, 20)
                                }
                            }
                            
                            // Enhanced Login Button
                            Button(action: handleLogin) {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Sign In")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.lunaPrimary, Color.lunaPrimary.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: Color.lunaPrimary.opacity(0.3),
                                            radius: 8,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            }
                            .disabled(username.isEmpty || password.isEmpty)
                            .opacity(username.isEmpty || password.isEmpty ? 0.6 : 1.0)
                            .padding(.top, 12)
                            
                            // Enhanced Forgot Password Link
                            Button(action: {
                                alertMessage = "Forgot password functionality coming soon!"
                                showingAlert = true
                            }) {
                                Text("Forgot Password?")
                                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                                    .foregroundColor(.lunaPrimary)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 40)
                        
                        Spacer(minLength: 48)
                        
                        // Enhanced Footer
                        VStack(spacing: 20) {
                            Divider()
                                .background(Color.lunaSecondaryText.opacity(0.2))
                            
                            VStack(spacing: 12) {
                                Text("Don't have an account?")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.lunaSecondaryText)
                                
                                Button(action: {
                                    alertMessage = "Sign up functionality coming soon!"
                                    showingAlert = true
                                }) {
                                    Text("Create Account")
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundColor(.lunaPrimary)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.lunaPrimary.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Notice", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            ContentView()
        }
    }
    
    private func handleLogin() {
        // Simple validation for demo purposes
        if username.lowercased() == "demo" && password == "password" {
            withAnimation(.easeInOut(duration: 0.5)) {
                isLoggedIn = true
            }
        } else {
            alertMessage = "Invalid credentials. Try username: 'demo' and password: 'password'"
            showingAlert = true
        }
    }
}

// MARK: - Enhanced Text Field Style
struct EnhancedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(.body, design: .rounded))
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.lunaCardBackground)
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.lunaSecondaryBackground, lineWidth: 1.5)
            )
    }
}

// MARK: - Preview
#Preview("LoginView - Light Mode") {
    LoginView()
        .environment(\.colorScheme, .light)
}

#Preview("LoginView - Dark Mode") {
    LoginView()
        .environment(\.colorScheme, .dark)
}
