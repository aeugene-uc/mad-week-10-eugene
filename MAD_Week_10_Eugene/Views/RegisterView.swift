//
//  RegisterView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Register")
                    .font(.system(size: 28, weight: .bold))
                Text("Begin weaving your threads of fate")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                AppTextFieldView(placeholder: "Name", text: $name, autocapitalization: .words)
                AppTextFieldView(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                AppTextFieldView(placeholder: "Password", text: $password, isSecure: true)
            }
            .padding(.horizontal, 24)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal, 24)
            }
            
            PrimaryButtonView(storyTitle: "Register",
                          isLoading: authViewModel.isLoading,
                          isEnabled: isFormValid) {
                Task {
                    await authViewModel.register(userName: name, userEmail: email, password: password)
                }
            }
            .padding(.horizontal, 80)
            
            Button {
                dismiss()
            } label: {
                Text("Back to Login")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && password.count >= 6
    }
}
