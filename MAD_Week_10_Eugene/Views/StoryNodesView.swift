//
//  StoryNodesView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct StoryNodesView: View {
    let story: Story
    @StateObject private var viewModel = AdminViewModel()
    @State private var showAddNode: Bool = false
    @State private var editingNode: StoryNode?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Struktur Cerita")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.secondary)
                
                if viewModel.nodes.isEmpty {
                    Text("Gunakan tombol + di bawah.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                } else {
                    ForEach(viewModel.nodes) { node in
                        NodeRow(node: node, onEdit: {
                            editingNode = node
                        }, onDelete: {
                            if let storyId = story.id, let nodeId = node.id {
                                Task {
                                    await viewModel.deleteNode(storyId: storyId, nodeId: nodeId)
                                }
                            }
                        })
                    }
                }
                
                Button {
                    showAddNode = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 20))
                        Text("Tambah Pilihan")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.primary)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle(story.storyTitle)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAddNode) {
            if let storyId = story.id {
                NodeEditorView(storyId: storyId,
                                existingNode: nil,
                                availableNodes: viewModel.nodes,
                                adminViewModel: viewModel)
            }
        }
        .sheet(item: $editingNode) { node in
            if let storyId = story.id {
                NodeEditorView(storyId: storyId,
                                existingNode: node,
                                availableNodes: viewModel.nodes,
                                adminViewModel: viewModel)
            }
        }
        .onAppear {
            if let storyId = story.id {
                viewModel.startListeningNodes(parentStoryId: storyId)
            }
        }
        .onDisappear {
            viewModel.stopListeningNodes()
        }
    }
}

struct NodeRow: View {
    let node: StoryNode
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(node.storyText)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if node.isStart {
                    Text("MULAI")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black)
                        .cornerRadius(4)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(.pink)
                }
            }
            
            Button(action: onEdit) {
                HStack {
                    Text("Edit Cabang")
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}
