//
//  ChatListViewModel.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/12/23.
//

import Foundation

class ChatListViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var user: User?
    @Published var searchText = ""
    
    @Published var isSignedOut = false
    @Published var isShowingNewChatView = false
    
    // Build filtered list of chats according to search text in user names
    var filteredUsers: [User] {
       if searchText.isEmpty {
           return self.users
       }
       return self.users.filter {
           $0.email.lowercased().contains(searchText.lowercased())
       }
   }
    
    init() {
        self.fetchCurrentUser()
        self.fetchAllUsers()
    }
    
    // MARK: - Action Handlers
    
    // Segue to compose new chat message screen on button press
    func handleComposeNewChat() {
        self.isShowingNewChatView = true
    }
    
    // Logout user on button press
    func handleSignOut() {
        self.signOutUser()
    }
    
    // MARK: - Firebase
    
    // Fetch all users data from Firebase and store in User list
    private func fetchAllUsers() {
        // Get user id from Firebase if user exists
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, err in
                if let err = err {
                    // Failed to fetch all user data
                    print("Failed to fetch users: ", err)
                    return
                }
                // Get all user data from Firebase snapshot
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    
                    let id = data["id"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let user = User(id: id, email: email, name: name)
                    
                    // Only add new users not already in userList
                    if user.id != uid {
                        self.users.append(user)
                    }
                })
            }
    }
    
    // Fetch user data from Firebase and store in User data
    private func fetchCurrentUser() {
        // Get user id from Firebase if user exists
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // Get user data matching id from Firebase
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, err in
                if let err = err {
                    // Failed to fetch user data
                    print("Failed to fetch user:", err)
                    return
                }
                // Get user data from Firebase snapshot
                guard let data = snapshot?.data() else { return }
                let email = data["email"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                self.user = User(id: uid, email: email, name: name)
            }
    }
    
    // Logout user from Firebase Auth using their credentials
    private func signOutUser() {
        do {
            try FirebaseManager.shared.auth.signOut()
            
            self.isSignedOut = true
            self.isShowingNewChatView = false
            self.user = nil
            self.users = []
            self.searchText = ""
            
            print("Succesfully signed out!")
        } catch let err as NSError {
            print("Failed to sign out user:", err)
        }
    }
}
