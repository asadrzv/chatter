//
//  Message.swift
//  Chatter
//
//  Created by Asad Rizvi on 4/13/23.
//

import Foundation

struct Message: Identifiable {
    var id: String { return UUID().uuidString }
    var fromId: String
    var toId: String
    var text: String
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
