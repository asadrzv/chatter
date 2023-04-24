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
    
    @Published var isLoggedOut = false
    @Published var isShowingNewChatView = false
    
    // Build filtered list of chats according to search text in user names
    var filteredUsers: [User] {
       if searchText.isEmpty {
           return self.users
       }
       return self.users.filter {
           $0.name.lowercased().contains(searchText.lowercased())
       }
   }
    
    init() {
        self.fetchUser()
        self.fetchAllUsers()
    }
    
    // MARK: - Action Handlers
    
    // Segue to compose new chat message screen on button press
    func handleComposeNewChat() {
        self.isShowingNewChatView = true
    }
    
    // Logout user on button press
    func handleLogout() {
        self.logoutUser()
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
                    let user = User(id: id, email: email)
                    
                    // Only add new users not already in userList
                    if user.id != uid {
                        self.users.append(user)
                    }
                })
            }
    }
    
    // Fetch user data from Firebase and store in User data
    private func fetchUser() {
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
                self.user = User(id: uid, email: email)
            }
    }
    
    // Logout user from Firebase Auth using their credentials
    private func logoutUser() {
        do {
            try FirebaseManager.shared.auth.signOut()
            self.isLoggedOut = true
            print("Succesfully logged out!")
        } catch let err as NSError {
            print("Failed to log out user:", err)
        }
    }
}
