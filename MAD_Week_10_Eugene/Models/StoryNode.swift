//
//  StoryNode.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseFirestore
import SwiftUI

struct StoryChoice: Identifiable, Codable, Hashable {
    var id: String
    var optionText: String
    var followingNodeId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case optionText = "label"
        case followingNodeId = "nextNodeId"
    }
    
    init(id: String = UUID().uuidString, optionText: String, followingNodeId: String) {
        self.id = id
        self.optionText = optionText
        self.followingNodeId = followingNodeId
    }
}

struct StoryNode: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var parentStoryId: String
    var storyText: String
    var options: [StoryChoice]
    var isStart: Bool
    var isEnd: Bool
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case parentStoryId = "storyId"
        case storyText = "narrative"
        case options = "choices"
        case isStart = "isEntryPoint"
        case isEnd = "isEnding"
        case timestamp = "createdAt"
    }
    
    init(id: String? = nil,
         parentStoryId: String,
         storyText: String,
         options: [StoryChoice] = [],
         isStart: Bool = false,
         isEnd: Bool = false,
         timestamp: Date = Date()) {
        self.id = id
        self.parentStoryId = parentStoryId
        self.storyText = storyText
        self.options = options
        self.isStart = isStart
        self.isEnd = isEnd
        self.timestamp = timestamp
    }
}
