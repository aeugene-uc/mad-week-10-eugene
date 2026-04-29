//
//  Achievement.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation

struct Achievement: Identifiable, Hashable, Codable {
    var id: String
    var achievementTitle: String
    var achievementDesc: String
    var badgeIcon: String
    var hasUnlocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case achievementTitle = "title"
        case achievementDesc = "description"
        case badgeIcon = "iconName"
        case hasUnlocked = "isUnlocked"
    }
}

struct SeedCategory: Identifiable, Hashable, Codable {
    var id: String
    var catTitle: String
    var catDesc: String
    var catType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case catTitle = "title"
        case catDesc = "description"
        case catType = "category"
    }
}
