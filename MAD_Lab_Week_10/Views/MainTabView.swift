//
//  MainTabView.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, admin, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "book.fill")
                }
                .tag(Tab.home)
            
            AdminView()
                .tabItem {
                    Label("Admin", systemImage: "hammer.fill")
                }
                .tag(Tab.admin)
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(.primary)
    }
}
