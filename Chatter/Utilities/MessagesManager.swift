//
//  MessagesManager.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/25/23.
//

import Foundation

class MessagesManager: ObservableObject {
    @Published var messages = [Message]()
    
    // Fetch all message data for current user from Firebase and store in Messages list
    private func fetchUserMessages() {
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
                        let timestamp = data["timestamp"] as? Date ?? Date()
                        
                        // Store message date as Message model in list
                        let message = Message(fromId: fromId, toId: toId, text: text, timestamp: timestamp)
                        self.messages.append(message)
                    }
                })
            }
    }
}
