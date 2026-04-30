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
                
                if !viewModel.isEnd {
                    Section("Pilihan") {
                        ForEach($viewModel.options) { $choice in
                            ChoiceEditorRow(choice: $choice,
                                            availableNodes: viewModel.availableNodes)
                        }
                        .onDelete { offsets in
                            viewModel.removeChoice(at: offsets)
                        }
                        
                        Button {
                            viewModel.addChoice()
                        } label: {
                            Label("Tambah Pilihan", systemImage: "plus.circle")
                        }
                    }
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

struct ChoiceEditorRow: View {
    @Binding var choice: StoryChoice
    let availableNodes: [StoryNode]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Label pilihan", text: $choice.optionText)
                .font(.system(size: 14))
            
            Picker("Tujuan", selection: $choice.followingNodeId) {
                Text("Pilih node tujuan").tag("")
                ForEach(availableNodes) { node in
                    Text(node.storyText.prefix(40) + (node.storyText.count > 40 ? "..." : ""))
                        .tag(node.id ?? "")
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.vertical, 4)
    }
}
