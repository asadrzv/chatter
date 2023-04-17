//
//  Message.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import Foundation

struct Message: Identifiable {
    // Enum indicates if message was sent/received
    enum MessageType: String {
        case Sent
        case Received
    }
    // Message id
    let id = UUID()
    // Date message sent/recieved
    let date: Date
    // Text contained in message
    let text: String
    // Enum indicates if message was sent/received
    let type: MessageType
    
    // Dictionary Key-Value pair for storing message data in Firebase
    var dictionary: [String: Any] {
        return [
            "date": date.descriptiveString(),
            "text": text,
            "type": type.rawValue
        ]
    }
}
