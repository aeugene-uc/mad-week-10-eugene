//
//  ProfileView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var seedingId: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileHeader
                achievementsSection
                seedDataSection
                logoutButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.primary)
            
            Text(authViewModel.currentUser?.userEmail ?? "Loading...")
                .font(.system(size: 16, weight: .bold))
            
            Text(authViewModel.currentUser?.userStatus ?? "Pencatat takdir yang bijaksana")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(storyTitle: "Achievements")
            ForEach(viewModel.achievements(for: authViewModel.currentUser)) { achievement in
                AchievementRowView(achievement: achievement)
            }
        }
    }
    
    private var seedDataSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(storyTitle: "Seed Data")
            ForEach(viewModel.seedCategories) { seed in
                SeedDataRowView(seed: seed,
                            isLoading: seedingId == seed.id) {
                    Task {
                        seedingId = seed.id
                        await viewModel.seed(storyCategory: seed)
                        seedingId = nil
                    }
                }
            }
            
            if let message = viewModel.message {
                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
    }
    
    private var logoutButton: some View {
        Button {
            authViewModel.logout()
        } label: {
            Text("Keluar Akun")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red.opacity(0.08))
                )
        }
    }
}
