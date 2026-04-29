//
//  StoryCardView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct StoryCardView: View {
    let story: Story
    let onStart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(story.storyTitle)
                .font(.system(size: 17, weight: .bold))
            
            Text(story.storyDesc)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            Button(action: onStart) {
                HStack {
                    Text("Mulai cerita")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(Color.black)
                .cornerRadius(6)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}
