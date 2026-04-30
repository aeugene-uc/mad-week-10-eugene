//
//  NodeEditorView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct NodeEditorView: View {
    @StateObject private var viewModel: StoryNodeViewModel
    @ObservedObject var adminViewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let storyId: String
    
    init(storyId: String,
         existingNode: StoryNode?,
         availableNodes: [StoryNode],
         adminViewModel: AdminViewModel) {
        self.storyId = storyId
        self.adminViewModel = adminViewModel
        _viewModel = StateObject(wrappedValue: StoryNodeViewModel(
            storyId: storyId,
            existingNode: existingNode,
            availableNodes: availableNodes
        ))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Teks Narasi") {
                    TextEditor(text: $viewModel.storyText)
                        .frame(minHeight: 120)
                        .font(.system(size: 14))
                }
                
                Section {
                    Toggle("Titik Mulai Cerita", isOn: $viewModel.isStart)
                }
            }
            .navigationTitle(viewModel.existingNode == nil ? "Node Baru" : "Edit Node")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Simpan") {
                        Task {
                            await adminViewModel.saveNode(parentStoryId: storyId,
                                                          node: viewModel.buildNode())
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}
