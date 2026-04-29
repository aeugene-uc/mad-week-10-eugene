//
//  User.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String?
    var userName: String
    var userEmail: String
    var userStatus: String
    var finishedStories: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "name"
        case userEmail = "email"
        case userStatus = "status"
        case finishedStories = "completedStories"
    }
    
    init(id: String? = nil,
         userName: String,
         userEmail: String,
         userStatus: String = "Pencatat takdir yang bijaksana",
         finishedStories: [String] = []) {
        self.id = id
        self.userName = userName
        self.userEmail = userEmail
        self.userStatus = userStatus
        self.finishedStories = finishedStories
    }
}
