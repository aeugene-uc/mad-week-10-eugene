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
                AppTextFieldView(placeholder: "Judul Cerita", text: $title, autocapitalization: .words)
                AppTextFieldView(placeholder: "Deskripsi", text: $description, autocapitalization: .sentences)
                AppTextFieldView(placeholder: "Kategori (opsional)", text: $category)
                
                PrimaryButtonView(text: "Simpan Cerita",
                              isEnabled: !title.isEmpty && !description.isEmpty) {
                    Task {
                        _ = await viewModel.createStory(storyTitle: title,
                                                        storyDesc: description,
                                                        storyCategory: category)
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
