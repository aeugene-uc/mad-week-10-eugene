//
//  StoriesViewModel.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class StoriesViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func startListening() {
        isLoading = true
        listener = db.collection("stories")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor in
                    guard let self else { return }
                    self.isLoading = false
                    if let error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    self.stories = documents.compactMap { doc -> Story? in
                        guard var story = try? doc.data(as: Story.self) else { return nil }
                        story.id = doc.documentID
                        return story
                    }
                }
            }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
