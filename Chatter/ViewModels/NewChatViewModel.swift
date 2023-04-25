//
//  NewChatViewModel.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/21/23.
//

import Foundation

class NewChatViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        self.fetchAllUsers()
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
}
