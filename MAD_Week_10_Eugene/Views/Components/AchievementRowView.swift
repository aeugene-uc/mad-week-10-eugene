//
//  AchievementRowView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct AchievementRowView: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(achievement.hasUnlocked ? Color.black : Color.gray.opacity(0.3))
                    .frame(width: 38, height: 38)
                Image(systemName: achievement.badgeIcon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 7) {
                Text(achievement.storyTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(achievement.hasUnlocked ? .primary : .secondary)
                Text(achievement.storyDesc)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}
