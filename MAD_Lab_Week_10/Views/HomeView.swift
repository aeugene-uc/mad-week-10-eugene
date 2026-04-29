//
//  HomeView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = StoriesViewModel()
    @State private var selectedStory: Story?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    
                    if viewModel.isLoading && viewModel.stories.isEmpty {
                        loadingState
                    } else if viewModel.stories.isEmpty {
                        emptyState
                    } else {
                        storyList
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedStory) { story in
                GameplayView(story: story)
            }
            .onAppear {
                viewModel.startListening()
            }
            .onDisappear {
                viewModel.stopListening()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daftar Cerita")
                .font(.system(size: 28, weight: .bold))
            Text("Pilih jalan yang ingin kau telusuri")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }
    
    private var storyList: some View {
        LazyVStack(spacing: 18) {
            ForEach(viewModel.stories) { story in
                StoryCardView(story: story) {
                    selectedStory = story
                }
            }
        }
    }
    
    private var loadingState: some View {
        VStack {
            ProgressView()
                .padding(.top, 40)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("Belum ada cerita")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Text("Tambahkan dari Profil > Seed Data")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}
