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
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            
            if viewModel.nodes.isEmpty {
                emptyState
            } else {
                nodeList
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .navigationTitle(story.storyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddNode = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
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
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Node Cerita")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.secondary)
            Text(story.storyDesc)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
    
    private var nodeList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.nodes) { node in
                    Button {
                        editingNode = node
                    } label: {
                        NodeRow(node: node)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("Belum ada node")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Text("Tambah node pertama sebagai entry point")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

struct NodeRow: View {
    let node: StoryNode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                if node.isStart {
                    Label("Entry", systemImage: "flag.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green)
                        .cornerRadius(4)
                }
                if node.isEnd {
                    Text("Ending")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.purple)
                        .cornerRadius(4)
                }
                Spacer()
                Text("\(node.options.count) pilihan")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Text(node.storyText)
                .font(.system(size: 13))
                .foregroundColor(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}
