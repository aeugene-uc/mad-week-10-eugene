//
//  AdminViewModel.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class AdminViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var nodes: [StoryNode] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var storiesListener: ListenerRegistration?
    private var nodesListener: ListenerRegistration?
    
    func startListeningStories() {
        storiesListener = db.collection("stories")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor in
                    guard let self else { return }
                    if let error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    self.stories = documents.compactMap { try? $0.data(as: Story.self) }
                }
            }
    }
    
    func stopListeningStories() {
        storiesListener?.remove()
        storiesListener = nil
    }
    
    func startListeningNodes(parentStoryId: String) {
        nodesListener?.remove()
        nodesListener = db.collection("stories")
            .document(parentStoryId)
            .collection("nodes")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor in
                    guard let self else { return }
                    if let error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    self.nodes = documents.compactMap { try? $0.data(as: StoryNode.self) }
                }
            }
    }
    
    func stopListeningNodes() {
        nodesListener?.remove()
        nodesListener = nil
        nodes = []
    }
    
    func createStory(storyTitle: String, storyDesc: String) async -> Story? {
        do {
            let newStory = Story(storyTitle: storyTitle, storyDesc: storyDesc)
            let ref = try db.collection("stories").addDocument(from: newStory)
            var saved = newStory
            saved.id = ref.documentID
            return saved
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
    
    func saveNode(parentStoryId: String, node: StoryNode) async {
        isLoading = true
        do {
            if node.isStart {
                try await clearOtherEntryPoints(parentStoryId: parentStoryId, exceptNodeId: node.id)
            }
            
            if let nodeId = node.id, !nodeId.isEmpty {
                try db.collection("stories")
                    .document(parentStoryId)
                    .collection("nodes")
                    .document(nodeId)
                    .setData(from: node)
                
                if node.isStart {
                    try await db.collection("stories")
                        .document(parentStoryId)
                        .updateData(["entryNodeId": nodeId])
                }
            } else {
                let ref = try db.collection("stories")
                    .document(parentStoryId)
                    .collection("nodes")
                    .addDocument(from: node)
                
                if node.isStart {
                    try await db.collection("stories")
                        .document(parentStoryId)
                        .updateData(["entryNodeId": ref.documentID])
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func clearOtherEntryPoints(parentStoryId: String, exceptNodeId: String?) async throws {
        let snapshot = try await db.collection("stories")
            .document(parentStoryId)
            .collection("nodes")
            .whereField("isEntryPoint", isEqualTo: true)
            .getDocuments()
        
        for doc in snapshot.documents where doc.documentID != exceptNodeId {
            try await doc.reference.updateData(["isEntryPoint": false])
        }
    }
    
    func deleteNode(storyId: String, nodeId: String) async {
        do {
            try await db.collection("stories")
                .document(storyId)
                .collection("nodes")
                .document(nodeId)
                .delete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteStory(storyId: String) async {
        do {
            let nodesSnapshot = try await db.collection("stories")
                .document(storyId)
                .collection("nodes")
                .getDocuments()
            for doc in nodesSnapshot.documents {
                try await doc.reference.delete()
            }
            try await db.collection("stories").document(storyId).delete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
