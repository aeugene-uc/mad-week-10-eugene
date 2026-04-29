//
//  AdminView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()
    @State private var showCreateStory: Bool = false
    @State private var selectedStory: Story?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                
                if viewModel.stories.isEmpty {
                    emptyState
                } else {
                    storyList
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateStory = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showCreateStory) {
                CreateStoryView(viewModel: viewModel)
            }
            .navigationDestination(item: $selectedStory) { story in
                StoryNodesView(story: story)
            }
            .onAppear {
                viewModel.startListeningStories()
            }
            .onDisappear {
                viewModel.stopListeningStories()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Arsitek")
                .font(.system(size: 28, weight: .bold))
            Text("Rancangan Cerita")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }
    
    private var storyList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.stories) { story in
                    Button {
                        selectedStory = story
                    } label: {
                        AdminStoryRow(story: story)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("Belum ada cerita")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Text("Tap + untuk membuat baru")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

struct AdminStoryRow: View {
    let story: Story
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(story.storyTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                Text(story.storyDesc)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}
