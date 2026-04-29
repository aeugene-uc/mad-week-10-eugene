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
        choices.append(StoryChoice(optionText: "", followingNodeId: ""))
    }
    
    func removeChoice(at offsets: IndexSet) {
        choices.remove(atOffsets: offsets)
    }
    
    func updateChoice(id: String, optionText: String? = nil, followingNodeId: String? = nil) {
        guard let index = choices.firstIndex(where: { $0.id == id }) else { return }
        if let label { choices[index].optionText = label }
        if let nextNodeId { choices[index].followingNodeId = nextNodeId }
    }
    
    func buildNode() -> StoryNode {
        var node = StoryNode(id: existingNode?.id,
                             storyId: storyId,
                             storyText: narrative,
                             options: choices.filter { !$0.optionText.isEmpty && !$0.followingNodeId.isEmpty },
                             isStart: isEntryPoint,
                             isEnd: isEnding,
                             timestamp: existingNode?.timestamp ?? Date())
        node.id = existingNode?.id
        return node
    }
    
    var isValid: Bool {
        !narrative.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
