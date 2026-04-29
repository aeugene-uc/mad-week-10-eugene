//
//  SeedDataRowView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct SeedDataRowView: View {
    let seed: SeedCategory
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Text(seed.catTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(seed.catDesc)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                if isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
        }
        .disabled(isLoading)
    }
}
