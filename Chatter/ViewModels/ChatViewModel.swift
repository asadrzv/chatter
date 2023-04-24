//
//  ChatViewModel.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/23/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var messageText = ""
    
    let otherUser: User?
    
    init(otherUser: User) {
        self.otherUser = otherUser
        
        self.fetchAllMessages()
    }
    
    // MARK: - Action Handlers
    
    // Send message on button press
    func handleSendMessage() {
        self.sendMesage()
    }
    
    // MARK: - Firebase
    
    // Fetch all message data for current user from Firebase and store in Messages list
    private func fetchAllMessages() {
        // Get current user (sender) id from Firebase if user exists
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        // Get other user (recipient) id to send message to
        guard let toId = otherUser?.id else { return }
        
        FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, err in
                if let err = err {
                    // Failed to fetch all messages data
                    print("Failed to fetch messages: ", err)
                    return
                }
                // Get all messages data from Firebase snapshot
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        
                        let fromId = data["fromId"] as? String ?? ""
                        let toId = data["toId"] as? String ?? ""
                        let text = data["text"] as? String ?? ""
                        let date = data["timestamp"] as? Date ?? Date()
                        
                        // Store message date as Message model in list
                        let message = Message(fromId: fromId, toId: toId, text: text, timestamp: date)
                        self.messages.append(message)
                    }
                })
            }
    }
    
    // Update message list to include new message sent
    private func sendMesage() {
        // Get current user (sender) id from Firebase if user exists
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        // Get other user (recipient) id to send message to
        guard let toId = otherUser?.id else { return }
        
        let messageData = Message(fromId: fromId, toId: toId, text: messageText, timestamp: Date()).dictionary
        
        // Store sender message data in 'messages' collection
        FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
            .setData(messageData) { err in
                if let err = err {
                    // Failed to store message data
                    print("Failed to store message: \(err)")
                    return
                }
                // Succesfully stored message data
                print("Succesfully stored message for sending user: \(fromId)")
            }
        
        // Store recipient message data in 'messages' collection
        FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
            .setData(messageData) { err in
                if let err = err {
                    // Failed to store message data
                    print("Failed to store message: \(err)")
                    return
                }
                // Succesfully stored message data
                print("Succesfully stored message for recieving user: \(toId)")
            }
        
        // Empty message text field after sending it
        messageText = ""
    }
}
