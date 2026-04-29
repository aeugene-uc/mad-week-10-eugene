//
//  GameplayView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct GameplayView: View {
    let story: Story
    @StateObject private var viewModel: GameViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(story: Story) {
        self.story = story
        _viewModel = StateObject(wrappedValue: GameViewModel(story: story))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 4) {
                topBar
                
                Spacer()
                
                contentSection
            }
        }
        .task {
            await viewModel.startStory()
        }
        .onChange(of: viewModel.isFinished) { _, finished in
            if finished, let storyId = viewModel.storyId {
                Task {
                    await authViewModel.markStoryCompleted(storyId: storyId)
                }
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    private var contentSection: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(18)
            } else if let node = viewModel.currentNode {
                narrativeBlock(node: node)
                choicesBlock(node: node)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private func narrativeBlock(node: StoryNode) -> some View {
        AnimatedNarrativeTextView(fullText: node.storyText)
            .id(node.id)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
    }
    
    @ViewBuilder
    private func choicesBlock(node: StoryNode) -> some View {
        if node.options.isEmpty {
            VStack(spacing: 14) {
                Text("Cerita Selesai")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                PrimaryButtonView(text: "Kembali ke Home") {
                    dismiss()
                }
                .padding(.horizontal, 40)
            }
        } else {
            VStack(spacing: 14) {
                ForEach(node.options) { choice in
                    ChoiceButtonView(optionText: choice.optionText) {
                        Task {
                            await viewModel.selectChoice(choice)
                        }
                    }
                }
            }
        }
    }
}
