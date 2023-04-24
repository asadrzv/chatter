//
//  Message.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import Foundation

struct Message: Identifiable {
    // Message id
    var id: String { return UUID().uuidString }
    // User id who message is from
    var fromId: String
    // User id who message is to
    var toId: String
    // Text contained in message
    var text: String
    // Timestamp message sent/recieved
    var timestamp: Date
    
    // Dictionary Key-Value pair for storing message data in Firebase
    var dictionary: [String: Any] {
        return [
            "fromId": fromId,
            "toId": toId,
            "text": text,
            "timestamp": timestamp
        ]
    }
}
