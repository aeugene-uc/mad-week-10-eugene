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
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detail") {
                    TextField("Judul", text: $storyTitle)
                    TextField("Ringkasan", text: $storyDesc)
                }
            }
            .navigationTitle("Draft Cerita")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Simpan") {
                        Task {
                            _ = await viewModel.createStory(storyTitle: storyTitle,
                                                            storyDesc: storyDesc)
                            dismiss()
                        }
                    }
                    .disabled(storyTitle.isEmpty || storyDesc.isEmpty)
                }
            }
        }
    }
}
