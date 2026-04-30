//
//  ChoiceEditorView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct ChoiceEditorView: View {
    let node: StoryNode
    let availableNodes: [StoryNode]
    @ObservedObject var adminViewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var options: [StoryChoice]
    private let storyId: String
    
    init(node: StoryNode,
         storyId: String,
         availableNodes: [StoryNode],
         adminViewModel: AdminViewModel) {
        self.node = node
        self.storyId = storyId
        self.availableNodes = availableNodes
        self.adminViewModel = adminViewModel
        _options = State(initialValue: node.options)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Pilihan Cabang") {
                    ForEach($options) { $choice in
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Label pilihan", text: $choice.optionText)
                                .font(.system(size: 14))
                            
                            Picker("Tujuan", selection: $choice.followingNodeId) {
                                Text("Pilih node tujuan").tag("")
                                ForEach(availableNodes.filter { $0.id != node.id }) { target in
                                    Text(String(target.storyText.prefix(40)) + (target.storyText.count > 40 ? "..." : ""))
                                        .tag(target.id ?? "")
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { offsets in
                        options.remove(atOffsets: offsets)
                    }
                    
                    Button {
                        options.append(StoryChoice(optionText: "", followingNodeId: ""))
                    } label: {
                        Label("Tambah Cabang", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Edit Cabang")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Simpan") {
                        Task {
                            let validOptions = options.filter { !$0.optionText.isEmpty }
                            var updatedNode = node
                            updatedNode.options = validOptions
                            await adminViewModel.saveNode(parentStoryId: storyId, node: updatedNode)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
