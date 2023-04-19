//
//  ChatListViewModel.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/12/23.
//

import Foundation

class ChatListViewModel: ObservableObject {
    @Published var user: User?
    @Published var chatList = SAMPLE_CHAT_LIST
    @Published var searchText = ""
    @Published var isLoggedOut = false
    
    // Build filtered list of chats according to search text in user names
   var filteredChatList: [Chat] {
       if searchText.isEmpty {
           return self.chatList
       }
       return self.chatList.filter {
           $0.otherUser.name.lowercased().contains(searchText.lowercased())
       }
   }
    
    init() {
        fetchUser()
    }
    
    // Set chat as having no unread messages
    func markChatAsRead(chat: Chat) {
        if let index = chatList.firstIndex(where: { $0.id == chat.id}) {
            chatList[index].hasUnreadMessages = false
        }
    }
    
    // Update chatList messages to include new message sent
    func sendMesage(text: String, in chat: Chat) {
        if let index = chatList.firstIndex(where: { $0.id == chat.id}) {
            let message = Message(date: Date(), text: text, type: .Sent)
            chatList[index].messages.append(message)
        }
    }
    
    // MARK: - Action Handlers
    
    // Segue to compose new chat message screen on button press
    func handleComposeMessage() {
        print("Compose new message button pressed")
    }
    
    // Logout user on button press
    func handleLogout() {
        self.logoutUser()
    }
    
    // MARK: - Firebase
    
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
                } else {
                    // Get user data from Firebase snapshot
                    guard let data = snapshot?.data() else { return }
                    let email = data["email"] as? String ?? ""
                    self.user = User(email: email)
                }
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
