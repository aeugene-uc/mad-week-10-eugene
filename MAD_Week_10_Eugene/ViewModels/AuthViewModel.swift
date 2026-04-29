//
//  AuthViewModel.swift
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthListener()
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func setupAuthListener() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                guard let self else { return }
                if let user {
                    self.isAuthenticated = true
                    await self.fetchUserProfile(uid: user.uid)
                } else {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
            }
        }
    }
    
    func login(userEmail: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: userEmail, password: password)
            await fetchUserProfile(uid: result.user.uid)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func register(userName: String, userEmail: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().createUser(withEmail: userEmail, password: password)
            let newUser = User(id: result.user.uid, userName: userName, userEmail: userEmail)
            try db.collection("users").document(result.user.uid).setData(from: newUser)
            currentUser = newUser
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchUserProfile(uid: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            if snapshot.exists {
                currentUser = try snapshot.data(as: User.self)
            } else if let firebaseUser = Auth.auth().currentUser {
                let fallback = User(id: uid,
                                       userName: firebaseUser.userEmail ?? "User",
                                       userEmail: firebaseUser.userEmail ?? "")
                try db.collection("users").document(uid).setData(from: fallback)
                currentUser = fallback
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func markStoryCompleted(storyId: String) async {
        guard let uid = currentUser?.id else { return }
        do {
            try await db.collection("users").document(uid).updateData([
                "completedStories": FieldValue.arrayUnion([storyId])
            ])
            await fetchUserProfile(uid: uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
