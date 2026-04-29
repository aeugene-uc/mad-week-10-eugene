//
//  StoryNodeViewModel.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class StoryNodeViewModel: ObservableObject {
    @Published var storyText: String = ""
    @Published var isStart: Bool = false
    @Published var isEnd: Bool = false
    @Published var options: [StoryChoice] = []
    @Published var availableNodes: [StoryNode] = []
    
    private let storyId: String
    private let existingNode: StoryNode?
    
    init(storyId: String, existingNode: StoryNode? = nil, availableNodes: [StoryNode] = []) {
        self.storyId = storyId
        self.existingNode = existingNode
        self.availableNodes = availableNodes
        if let node = existingNode {
            self.storyText = node.storyText
            self.isStart = node.isStart
            self.isEnd = node.isEnd
            self.options = node.options
        }
    }
    
    func addChoice() {
        options.append(StoryChoice(optionText: "", followingNodeId: ""))
    }
    
    func removeChoice(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
    }
    
    func updateChoice(id: String, optionText: String? = nil, followingNodeId: String? = nil) {
        guard let index = options.firstIndex(where: { $0.id == id }) else { return }
        if let optionText { options[index].optionText = optionText }
        if let followingNodeId { options[index].followingNodeId = followingNodeId }
    }
    
    func buildNode() -> StoryNode {
        var node = StoryNode(id: existingNode?.id,
                             parentStoryId: storyId,
                             storyText: storyText,
                             options: options.filter { !$0.optionText.isEmpty && !$0.followingNodeId.isEmpty },
                             isStart: isStart,
                             isEnd: isEnd,
                             timestamp: existingNode?.timestamp ?? Date())
        node.id = existingNode?.id
        return node
    }
    
    var isValid: Bool {
        !storyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
