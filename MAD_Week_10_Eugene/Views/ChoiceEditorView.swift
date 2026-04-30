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

    @State private var optionText: String = ""
    @State private var followingNodeId: String = ""
    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Narasi Saat Ini") {
                    Text(node.storyText)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                }

                Section("Pilihan Cabang") {
                    TextField("Teks Pilihan (Misal: 'Lari')", text: $optionText)
                        .font(.system(size: 14))

                    Picker("Pilih Tujuan", selection: $followingNodeId) {
                        Text("Pilih node tujuan").tag("")
                        ForEach(availableNodes.filter { $0.id != node.id }) { target in
                            Text(String(target.storyText.prefix(50)) + (target.storyText.count > 50 ? "..." : ""))
                                .tag(target.id ?? "")
                        }
                    }
                }

                Section {
                    Button("Simpan Cabang") {
                        guard !optionText.trimmingCharacters(in: .whitespaces).isEmpty,
                              !followingNodeId.isEmpty else { return }
                        isSaving = true
                        Task {
                            let newChoice = StoryChoice(optionText: optionText, followingNodeId: followingNodeId)
                            var updatedNode = node
                            updatedNode.options.append(newChoice)
                            await adminViewModel.saveNode(parentStoryId: storyId, node: updatedNode)
                            isSaving = false
                            dismiss()
                        }
                    }
                    .disabled(optionText.trimmingCharacters(in: .whitespaces).isEmpty || followingNodeId.isEmpty || isSaving)
                    .foregroundColor(optionText.isEmpty || followingNodeId.isEmpty ? .secondary : .blue)
                }
            }
            .navigationTitle("Keputusan")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
