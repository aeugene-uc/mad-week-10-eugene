//
//  LoginView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var userEmail: String = ""
    @State private var password: String = ""
    @State private var showRegister: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "circle.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.primary)
                    
                    Text("Login")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Catatan setiap kemungkinan hidup")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 16) {
                    AppTextFieldView(placeholder: "Email",
                                 text: $userEmail,
                                 keyboardType: .emailAddress)
                    
                    AppTextFieldView(placeholder: "Password",
                                 text: $password,
                                 isSecure: true)
                }
                .padding(.horizontal, 24)
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                }
                
                PrimaryButtonView(text: "Login",
                              isLoading: authViewModel.isLoading,
                              isEnabled: isFormValid) {
                    Task {
                        await authViewModel.login(userEmail: userEmail, password: password)
                    }
                }
                .padding(.horizontal, 80)
                
                Button {
                    showRegister = true
                } label: {
                    Text("Register New Account")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
    
    private var isFormValid: Bool {
        !userEmail.isEmpty && !password.isEmpty
    }
}
