//
//  AnimatedNarrativeTextView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct AnimatedNarrativeTextView: View {
    let fullText: String
    @State private var displayedText: String = ""
    @State private var currentTask: Task<Void, Never>?
    
    var body: some View {
        Text(displayedText)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                animateText()
            }
            .onChange(of: fullText) { _, _ in
                animateText()
            }
    }
    
    private func animateText() {
        currentTask?.cancel()
        displayedText = ""
        currentTask = Task {
            for character in fullText {
                if Task.isCancelled { return }
                try? await Task.sleep(nanoseconds: 25_000_000)
                await MainActor.run {
                    displayedText.append(character)
                }
            }
        }
    }
}
