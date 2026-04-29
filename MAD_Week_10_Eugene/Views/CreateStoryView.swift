//
//  CreateStoryView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct CreateStoryView: View {
    @ObservedObject var viewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var storyTitle: String = ""
    @State private var storyDesc: String = ""
    @State private var storyCategory: String = "general"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AppTextFieldView(placeholder: "Judul Cerita", text: $storyTitle, autocapitalization: .words)
                AppTextFieldView(placeholder: "Deskripsi", text: $storyDesc, autocapitalization: .sentences)
                AppTextFieldView(placeholder: "Kategori (opsional)", text: $storyCategory)
                
                PrimaryButtonView(text: "Simpan Cerita",
                              isEnabled: !storyTitle.isEmpty && !storyDesc.isEmpty) {
                    Task {
                        _ = await viewModel.createStory(storyTitle: storyTitle,
                                                        storyDesc: storyDesc,
                                                        storyCategory: storyCategory)
                        dismiss()
                    }
                }
                
                Spacer()
            }
            .padding(22)
            .navigationTitle("Cerita Baru")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Batal") { dismiss() }
                }
            }
        }
    }
}
