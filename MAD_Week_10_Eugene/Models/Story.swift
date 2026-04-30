//
//  Story.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseFirestore

struct Story: Identifiable, Codable, Hashable {
    var id: String?
    var storyTitle: String
    var storyDesc: String
    var startNodeId: String?
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case storyTitle = "title"
        case storyDesc = "description"
        case startNodeId = "entryNodeId"
        case timestamp = "createdAt"
    }
    
    init(id: String? = nil,
         storyTitle: String,
         storyDesc: String,
         startNodeId: String? = nil,
         timestamp: Date = Date()) {
        self.id = id
        self.storyTitle = storyTitle
        self.storyDesc = storyDesc
        self.startNodeId = startNodeId
        self.timestamp = timestamp
    }
}
