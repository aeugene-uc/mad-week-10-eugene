//
//  GameViewModel.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class GameViewModel: ObservableObject {
    @Published var currentNode: StoryNode?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isFinished: Bool = false
    
    private let db = Firestore.firestore()
    private let story: Story
    
    init(story: Story) {
        self.story = story
    }
    
    func startStory() async {
        isLoading = true
        errorMessage = nil
        guard let storyId = story.id else {
            errorMessage = "Story id is missing"
            isLoading = false
            return
        }
        
        do {
            if let entryId = story.startNodeId, !entryId.isEmpty {
                let snapshot = try await db.collection("stories")
                    .document(storyId)
                    .collection("nodes")
                    .document(entryId)
                    .getDocument()
                if snapshot.exists {
                    var node = try snapshot.data(as: StoryNode.self)
                    node.id = snapshot.documentID
                    currentNode = node
                    isLoading = false
                    return
                }
            }
            
            let snapshot = try await db.collection("stories")
                .document(storyId)
                .collection("nodes")
                .whereField("isEntryPoint", isEqualTo: true)
                .limit(to: 1)
                .getDocuments()
            
            if let doc = snapshot.documents.first {
                var node = try doc.data(as: StoryNode.self)
                node.id = doc.documentID
                currentNode = node
            } else {
                errorMessage = "No entry point set for this story"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func selectChoice(_ choice: StoryChoice) async {
        guard let storyId = story.id else { return }
        isLoading = true
        do {
            let snapshot = try await db.collection("stories")
                .document(storyId)
                .collection("nodes")
                .document(choice.followingNodeId)
                .getDocument()
            
            if snapshot.exists {
                var next = try snapshot.data(as: StoryNode.self)
                next.id = snapshot.documentID
                currentNode = next
                if next.options.isEmpty || next.isEnd {
                    isFinished = true
                }
            } else {
                errorMessage = "Linked node not found"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    var storyId: String? { story.id }
}
