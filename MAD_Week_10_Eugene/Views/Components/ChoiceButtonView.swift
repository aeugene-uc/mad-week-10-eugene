//
//  ChoiceButtonView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct ChoiceButtonView: View {
    let optionText: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "hand.point.up.left.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .background(Color.black.opacity(0.6))
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}
