//
//  ChoiceEditorView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct ChoiceEditorView: View {
    let node: StoryNode
    let storyId: String
    let availableNodes: [StoryNode]
    @ObservedObject var adminViewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var options: [StoryChoice]

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
                Section("Narasi Saat Ini") {
                    Text(node.storyText)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                }

                Section("Pilihan Cabang") {
                    ForEach($options) { $choice in
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Teks Pilihan (Misal: 'Lari')", text: $choice.optionText)
                                .font(.system(size: 14))

                            Picker("Pilih Tujuan", selection: $choice.followingNodeId) {
                                Text("Pilih node tujuan").tag("")
                                ForEach(availableNodes.filter { $0.id != node.id }) { target in
                                    Text(String(target.storyText.prefix(50)) + (target.storyText.count > 50 ? "..." : ""))
                                        .tag(target.id ?? "")
                                }
                            }
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

                Section {
                    Button("Simpan Cabang") {
                        Task {
                            var updatedNode = node
                            updatedNode.options = options
                            await adminViewModel.saveNode(parentStoryId: storyId, node: updatedNode)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Keputusan")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
